package asunit4.runners {
	import asunit.framework.Assert;

	import asunit4.async.Async;
	import asunit4.events.TimeoutCommandEvent;
	import asunit4.framework.ITestListener;
	import asunit4.framework.Method;
	import asunit4.framework.TestFailure;
	import asunit4.framework.TestIterator;
	import asunit4.framework.TestSuccess;

	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	public class TestRunner extends EventDispatcher {
		internal var currentTest:Object; // partially exposed for unit testing
		protected var currentMethod:Method;
		protected var startTime:Number;
		protected var timer:Timer;
		protected var testListener:ITestListener;
		protected var methodsToRun:TestIterator;
		protected var methodTimeoutID:int = -1;
		protected var methodPassed:Boolean = true;
		protected var methodIsExecuting:Boolean = false;

		public function TestRunner() {
			timer = new Timer(0, 1);
			timer.addEventListener(TimerEvent.TIMER, runNextMethod);
		}
		
		public function run(test:Class, testListener:ITestListener):void {
			runMethodByName(test, testListener, "");
		}
		
		public function runMethodByName(test:Class, testListener:ITestListener, testMethodName:String):void {
			currentTest = new test();
			this.testListener = testListener;
			currentMethod = null;
						
			Async.instance.addEventListener(TimeoutCommandEvent.CALLED,		onAsyncMethodCalled);
			Async.instance.addEventListener(TimeoutCommandEvent.TIMED_OUT,	onAsyncMethodTimedOut);
			
			startTime = getTimer();
			this.testListener.onTestStarted(currentTest);
			
			methodsToRun = new TestIterator(currentTest, testMethodName);
			runNextMethod();			
		}
		
		protected function runNextMethod(e:TimerEvent = null):void {
			if (testCompleted) {
				onTestCompleted();
				return;
			}
			
			runMethod(methodsToRun.next());
		}
		
		protected function runMethod(method:Method):void {
			if (!method) return;
			currentMethod = method;
			methodPassed = true; // innocent until proven guilty by recordFailure()
			
			if (currentMethod.ignore) {
				testListener.onTestIgnored(currentMethod);
				onMethodCompleted();
				return;
			}
			
			if (currentMethod.timeout >= 0) {
				methodTimeoutID = setTimeout(onMethodTimeout, currentMethod.timeout);
			}
			
			// This is used to prevent async callbacks from triggering onMethodCompleted too early.
			methodIsExecuting = true;
			
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
			
			methodIsExecuting = false;
			
			if (Async.instance.hasPending) return;
			onMethodCompleted();
		}

		protected function onMethodTimeout():void {
			recordFailure(new IllegalOperationError('Timeout (' + currentMethod.timeout + 'ms) exceeded during method ' + currentMethod.name));
			onMethodCompleted();
		}
		
		protected function onMethodCompleted():void {
			clearTimeout(methodTimeoutID);
			Async.instance.cancelPending();
			
			if (currentMethod.isTest && methodPassed && !currentMethod.ignore) {
				testListener.onTestSuccess(new TestSuccess(currentTest, currentMethod.name));
			}

			// Calling synchronously is faster but keeps adding to the call stack.
			runNextMethod();
			
			// green thread for runNextMethod()
			// This runs much slower in Flash Player 10.1.
			//timer.reset();
			//timer.start();
		}
		
		protected function onAsyncMethodCalled(event:TimeoutCommandEvent):void {
			try {
				event.command.execute();
			}
			catch (error:Error) {
				recordFailure(error);
			}
			onAsyncMethodCompleted(event);
		}
		
		protected function onAsyncMethodTimedOut(event:TimeoutCommandEvent):void {
			var error:IllegalOperationError = new IllegalOperationError("Timeout (" + event.command.duration + "ms) exceeded on an asynchronous operation.");
			recordFailure(error);
			onAsyncMethodCompleted(event);
		}
		
		protected function recordFailure(error:Error):void {
			methodPassed = false;
			testListener.onTestFailure(new TestFailure(currentTest, currentMethod.name, error));
		}
		
		protected function onAsyncMethodCompleted(event:Event = null):void {
			if (!methodIsExecuting && !Async.instance.hasPending) {
				onMethodCompleted();
			}
		}
		
		protected function onTestCompleted():void {
			Async.instance.removeEventListener(TimeoutCommandEvent.CALLED,		onAsyncMethodCalled);
			Async.instance.removeEventListener(TimeoutCommandEvent.TIMED_OUT,	onAsyncMethodTimedOut);
			Async.instance.cancelPending();
			
			this.testListener.onTestCompleted(currentTest);
			
			//TODO: move out because runTime is for whole run, not one test
			//testListener.runTime = getTimer() - startTime;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function get testCompleted():Boolean {
			return (!methodsToRun.hasNext() && !Async.instance.hasPending);
		}
	}
}
