package asunit.framework.async {
	import asunit.framework.Command;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import asunit.framework.ErrorEvent;
	
	[Event(name="called",	type="flash.events.Event")]
	[Event(name="error",	type="asunit.framework.ErrorEvent")]

	public class FreeAsyncOperation extends EventDispatcher implements Command {
		public static const CALLED:String = 'called';
		public var scope:Object;
		public var handler:Function; // public for now for testing
		protected var params:Array;
		
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
		
		public function execute():* {
			return handler.apply(scope, params);
		}
		
		public function getCallback():Function{
			return callback;
		}
		
		protected function callback(...params):* {
			timeout.stop();
			this.params = params;
			dispatchEvent(new Event(CALLED));
		}
		
		protected function onTimeoutComplete(event:TimerEvent):void {
			sendError(new IllegalOperationError('Async operation timed out.'));
		}
		
		protected function sendError(error:Error):void {
			var event:ErrorEvent = new ErrorEvent(ErrorEvent.ERROR, error);
			dispatchEvent(event);
			if (failureHandler != null) failureHandler(event);
		}

		override public function toString():String {
			return '[FreeAsyncOperation scope=' + scope + ']';;
		}
		
	}
}
