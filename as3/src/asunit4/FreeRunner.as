package asunit4 {
	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.clearTimeout;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import asunit4.async.Async;
	import asunit4.async.TimeoutCommand;
	import asunit.runner.ITestRunner;
	import asunit.textui.ResultPrinter;
	import asunit.util.ArrayIterator;
	import asunit.util.Iterator;
	import asunit.framework.Assert;
	import asunit4.events.TestResultEvent;
	import asunit.framework.ErrorEvent;
	import asunit.framework.ITestResult;

	public class FreeRunner extends EventDispatcher implements ITestRunner {
		protected var beforeMethodsList:Iterator;
		protected var testMethodsList:Iterator;
		protected var afterMethodsList:Iterator;
		
		protected var currentTest:Object;
		protected var currentMethod:Method;
		protected var _printer:ResultPrinter;
		protected var startTime:Number;
		protected var timer:Timer;
		protected var result:ITestResult;
		protected var allMethods:TestMethodIterator;
		protected var methodTimeoutID:int = -1;

		public function FreeRunner() {
			timer = new Timer(1, 1);
			timer.addEventListener(TimerEvent.TIMER, runNextMethod);
		}
		
		public function get printer():ResultPrinter { return _printer; }
		
        public function set printer(printer:ResultPrinter):void {
			if (_printer && result)
				result.removeListener(_printer);
				
			_printer = printer;
			
			if (result)
				result.addListener(_printer);
        }

		protected function get testCompleted():Boolean {
			return (!allMethods.hasNext() && asyncsCompleted);
		}
		
		public function run(test:Object, result:ITestResult = null):void {
			trace('-------------------- run(): ' + test + ' - result: ' + result);
			currentTest = test;
			currentMethod = null;
			this.result = result || new FreeTestResult();
			
			allMethods = new TestMethodIterator(test);
			
			startTime = getTimer();
			if (_printer)
				_printer.startTest(test);
			
			// If any methods in the test are async, we must use a slower path.

			if (allMethods.async) {
				runNextMethod();
				return;
			}
			
			// Since the test has no async methods, we can run a fast loop.

			while (allMethods.hasNext()) {
				runMethod(allMethods.next());
			}
			onTestCompleted();
		}
		
		protected function runMethod(method:Method):void {
			if (method == null) return;
			currentMethod = method;
			
			trace('runMethod() - currentMethod: ' + currentMethod);
			
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
			//timer.reset();
			//timer.start();
			
			runNextMethod();
		}
		
		protected function onMethodTimeout():void {
			trace('@@@ onMethodTimeout(): ' + currentMethod.timeout + ' - ' + currentMethod);
			recordFailure(new IllegalOperationError('Timeout (' + currentMethod.timeout + 'ms) exceeded during method ' + currentMethod.name));
			onMethodCompleted();
		}
		
		protected function onMethodCompleted():void {
			trace('onMethodCompleted() - ' + currentMethod);
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
				
			runNextMethod();
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
			trace('onAsyncMethodFailed() - currentMethod: ' + currentMethod + ' - event.error: ' + event.error);
			
			recordFailure(event.error);
			onAsyncMethodCompleted(event);
		}
		
		protected function onAsyncMethodCompleted(event:Event):void {
			var command:TimeoutCommand = TimeoutCommand(event.currentTarget);
			
			trace('onAsyncMethodCompleted() - command: ' + command);
			
			command.removeEventListener(TimeoutCommand.CALLED,	onAsyncMethodCompleted);
			command.removeEventListener(ErrorEvent.ERROR,		onAsyncMethodFailed);
			
			if (asyncsCompleted) {
				onMethodCompleted();
			}
		}
		
		protected function recordFailure(error:Error):void {
			result.addFailure(new FreeTestFailure(currentTest, currentMethod.name, error));
		}
		
		protected function onTestCompleted():void {
			trace('onTestCompleted()');
			FreeTestResult(result).runTime = getTimer() - startTime;
			dispatchEvent(new TestResultEvent(TestResultEvent.TEST_COMPLETED, result));
			
			if (!_printer) return;
			//TODO: Move this out to view and use event instead.
			_printer.endTest(currentTest);
			
		}
		
		protected function get asyncsCompleted():Boolean {
			//TODO: maybe have Async send an event instead of checking it
			var commands:Array = Async.instance.getCommandsForTest(currentTest);
			return (!commands || commands.length == 0);
		}
		
	}
}
