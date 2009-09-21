package asunit.framework.async {
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import asunit.framework.ErrorEvent;
	
	[Event(name="complete",	type="flash.events.Event")]
	[Event(name="error",	type="asunit.framework.ErrorEvent")]

	public class FreeAsyncOperation extends EventDispatcher {

		public var scope:Object;
		public var handler:Function; // public for now for testing
		
		protected var timeout:Timer;
		protected var duration:Number;
		protected var failureHandler:Function;

		public function FreeAsyncOperation(scope:Object, handler:Function, duration:Number, failureHandler:Function=null){
			this.scope = scope;
			this.handler = handler || function(...args):* {};
			this.duration = duration;
			this.failureHandler = failureHandler;
			
			timeout = new Timer(duration, 1);
			timeout.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeoutComplete);
			timeout.start();
		}
		
		protected function execute(...args):* {
			timeout.stop();
			try {
				handler.apply(scope, args);
			}
			catch(error:Error) {
				sendError(error);
			}
			finally {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function getCallback():Function{
			return execute;
		}
		
		protected function sendError(error:Error):void {
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, error));
		}

		protected function onTimeoutComplete(event:TimerEvent):void {
			sendError(new IllegalOperationError('Async operation timed out.'));
		}
		
		override public function toString():String {
			return '[FreeAsyncOperation scope=' + scope + ']';;
		}
		
	}
}
