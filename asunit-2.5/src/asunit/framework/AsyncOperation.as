import asunit.errors.AssertionFailedError;
import asunit.flash.errors.IllegalOperationError;
import asunit.flash.events.TimerEvent;
import asunit.flash.utils.Timer;
import asunit.framework.TestCase;	

class asunit.framework.AsyncOperation{

	private var timeout:Timer;
	private var testCase:TestCase;
	private var callback:Function;
	private var duration:Number;

	public function AsyncOperation(testCase:TestCase, handler:Function, duration:Number){
		this.testCase = testCase;
		this.duration = duration;
		timeout = new Timer(duration, 1);
		timeout.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeoutComplete, this);
		timeout.start();
		if(handler == null) {
			handler = function():Void{};
		}
		var context:AsyncOperation = this;
		callback = function():Void{
			context.timeout.stop();
			try {
				handler.apply(testCase, arguments);
			}
			catch(e:AssertionFailedError) {
				testCase.getResult().addFailure(testCase, e);
			}
			catch(ioe:IllegalOperationError) {
				testCase.getResult().addError(testCase, ioe);
			}
			finally {
				testCase.asyncOperationComplete(context);
			}
		};
	}
	
	public function getCallback():Function{
		return callback;
	}

	private function onTimeoutComplete(event:TimerEvent):Void{
		testCase.asyncOperationTimeout(this, duration);
	}
}
