package asunit4.runners {
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.clearTimeout;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import asunit.framework.Assert;
	import asunit.framework.ErrorEvent;
	import asunit4.async.Async;
	import asunit4.async.TimeoutCommand;
	import asunit4.events.TestResultEvent;
	import asunit4.framework.IFreeTestResult;
	import asunit4.framework.Method;
	import asunit4.framework.TestIterator;
	import asunit4.framework.FreeTestResult;
	import asunit4.framework.TestSuccess;
	import asunit4.framework.FreeTestFailure;

	public class TestRunner extends EventDispatcher {
		protected var currentTest:Object;
		protected var currentMethod:Method;
		protected var startTime:Number;
		protected var timer:Timer;
		protected var result:IFreeTestResult;
		protected var allMethods:TestIterator;
		protected var methodTimeoutID:int = -1;
		protected var methodPassed:Boolean = true;

		public function TestRunner() {
			timer = new Timer(0, 1);
			timer.addEventListener(TimerEvent.TIMER, runNextMethod);
		}
		
		protected function get testCompleted():Boolean {
			return (!allMethods.hasNext() && asyncsCompleted);
		}
		
		public function run(test:Object):void {
			trace('-------------------- run(): ' + test + ' - result: ' + result);
			currentTest = test;
			currentMethod = null;
			result = new FreeTestResult();
			
			allMethods = new TestIterator(test);
			
			startTime = getTimer();
			
			// If any methods in the test are async, we must use a slower path.

			if (allMethods.async) {
				runNextMethod();
				return;
			}
			
			// Since the test has no async methods, we can run a fast loop.

			while (allMethods.hasNext()) {
				runMethod(allMethods.next());
				onMethodCompleted();
			}
			onTestCompleted();
		}
		
		protected function runMethod(method:Method):void {
			if (method == null) return;
			currentMethod = method;
			methodPassed = true; // innocent until proven guilty by recordFailure()
			
			//trace('runMethod() - currentMethod: ' + currentMethod);
			
			if (currentMethod.timeout >= 0) {
				methodTimeoutID = setTimeout(onMethodTimeout, currentMethod.timeout);
			}
			
			if (currentMethod.expects) {
				var errorClass:Class = getDefinitionByName(currentMethod.expects) as Class;
				try {
					Assert.assertThrows(errorClass, currentMethod.value);
				}
				catch (error:Error) {
					recordFailure(error);
				}
			}
			else {
				try {
					currentMethod.value();
				}
				catch (error:Error) {
					recordFailure(error);
				}
			}
		}

		protected function runNextMethod(e:TimerEvent = null):void {
			if (testCompleted) {
				onTestCompleted();
				return;
			}
			
			runMethod(allMethods.next());
			
			if (currentMethod.async) {
				var commands:Array = Async.instance.getCommandsForTest(currentTest);
				// find the async commands and listen to them
				for each (var command:TimeoutCommand in commands) {
					command.addEventListener(TimeoutCommand.CALLED, onAsyncMethodCalled);
					command.addEventListener(ErrorEvent.ERROR, onAsyncMethodFailed);
				}
				return;
			}
			
			// Start a new green thread.
			timer.reset();
			timer.start();
			
			//runNextMethod();
		}
		
		protected function onMethodTimeout():void {
			//trace('@@@ onMethodTimeout(): ' + currentMethod.timeout + ' - ' + currentMethod);
			recordFailure(new IllegalOperationError('Timeout (' + currentMethod.timeout + 'ms) exceeded during method ' + currentMethod.name));
			onAllAsyncsCompleted();
		}
		
		protected function onAllAsyncsCompleted():void {
			//trace('onAllAsyncsCompleted() - ' + currentMethod);
			clearTimeout(methodTimeoutID);
			
			if (currentMethod.async) {
				var commands:Array = Async.instance.getCommandsForTest(currentTest);
				// clean up all async listeners
				for each (var command:TimeoutCommand in commands) {
					command.cancel();
					command.removeEventListener(TimeoutCommand.CALLED, onAsyncMethodCalled);
					command.removeEventListener(ErrorEvent.ERROR, onAsyncMethodFailed);
				}
			}
			onMethodCompleted();
			runNextMethod();
		}
		
		protected function onMethodCompleted():void {
			if (!currentMethod.isTest) return;
			if (methodPassed) {
				result.addSuccess(new TestSuccess(currentTest, currentMethod.name));
			}
			result.runCount++;
		}
		
		protected function onAsyncMethodCalled(event:Event):void {
			var command:TimeoutCommand = TimeoutCommand(event.currentTarget);
			trace('onAsyncMethodCalled() - command: ' + command);
			
			try {
				command.execute();
			}
			catch (error:Error) {
				recordFailure(error);
			}
			onAsyncMethodCompleted(event);
		}
		
		protected function onAsyncMethodFailed(event:ErrorEvent):void {
			//trace('onAsyncMethodFailed() - currentMethod: ' + currentMethod + ' - event.error: ' + event.error);
			recordFailure(event.error);
			onAsyncMethodCompleted(event);
		}
		
		protected function onAsyncMethodCompleted(event:Event):void {
			var command:TimeoutCommand = TimeoutCommand(event.currentTarget);
			//trace('onAsyncMethodCompleted() - command: ' + command);
			command.removeEventListener(TimeoutCommand.CALLED,	onAsyncMethodCompleted);
			command.removeEventListener(ErrorEvent.ERROR,		onAsyncMethodFailed);
			
			if (asyncsCompleted) {
				onAllAsyncsCompleted();
			}
		}
		
		protected function recordFailure(error:Error):void {
			methodPassed = false;
			result.addFailure(new FreeTestFailure(currentTest, currentMethod.name, error));
		}
		
		protected function onTestCompleted():void {
			trace('FreeRunner.onTestCompleted()');
			FreeTestResult(result).runTime = getTimer() - startTime;
			dispatchEvent(new TestResultEvent(TestResultEvent.TEST_COMPLETED, result));
		}
		
		protected function get asyncsCompleted():Boolean {
			//TODO: maybe have Async send an event instead of checking it
			var commands:Array = Async.instance.getCommandsForTest(currentTest);
			return (!commands || commands.length == 0);
		}
	}
}
