package asunit.framework.async {
	import asunit.errors.AssertionFailedError;
	import asunit.framework.TestResult;
	import asunit.framework.TestResultEvent;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import asunit.framework.FreeTestResult;

	public class FreeAsyncOperation extends EventDispatcher {

		protected var timeout:Timer;
		protected var test:Object;
		protected var duration:Number;
		public var handler:Function; // public for now for testing
		protected var failureHandler:Function;
		protected var _testResult:FreeTestResult;

		public function FreeAsyncOperation(test:Object, handler:Function, duration:Number, failureHandler:Function=null){
			this.test = test;
			this.handler = handler || function(...args):* {};
			this.duration = duration;
			this.failureHandler = failureHandler;
			
			timeout = new Timer(duration, 1);
			timeout.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeoutComplete);
			timeout.start();
		}
		
		public function get testResult():FreeTestResult { return _testResult; }
		
		public function set testResult(value:FreeTestResult):void {
			_testResult = value;
		}
		
		protected function callback(...args):* {
			timeout.stop();
			try {
				handler.apply(test, args);
			}
			catch(assertionError:AssertionFailedError) {
				testResult.addFailure(test, 'TODO: method name', assertionError);
			}
			catch(error:Error) {
				testResult.addError(test, 'TODO: method name', error);
			}
			finally {
				sendResult();
			}
			return;
		}
		
		public function getCallback():Function{
			return callback;
		}
		
		protected function sendResult():void {
			//TODO: use event instead
			Async.instance.removeOperationForTest(test, this);
			dispatchEvent(new TestResultEvent(TestResultEvent.NAME, testResult));
		}

		protected function onTimeoutComplete(event:TimerEvent):void {
			//if(null != failureHandler) {
				//failureHandler(new Event('async timeout'));
			//}
			
			//trace('onTimeoutComplete() - test: ' + test + ' duration: ' + duration);
			//if (!testResult) return;
			testResult.addError(test, 'TODO: method name', new IllegalOperationError('Async operation timed out.'));
			sendResult();
		}
		
	}
}
