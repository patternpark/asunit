package asunit.framework {
	import asunit.framework.Command;

	import asunit.events.TimeoutCommandEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	[Event(name="called",	type="flash.events.TimeoutCommandEvent")]
	[Event(name="timedOut",	type="flash.events.TimeoutCommandEvent")]
	public class TimeoutCommand extends EventDispatcher implements Command {

		public var scope:Object;
		public var handler:Function;
		public var duration:Number;
		
		protected var params:Array;
		protected var timeout:Timer;
		protected var failureHandler:Function;

		public function TimeoutCommand(scope:Object, handler:Function, duration:int = 0, failureHandler:Function=null) {
			this.scope = scope;
			this.handler = handler || function(...args):* {};
			this.duration = duration;
			this.failureHandler = failureHandler;
			
			//if (duration < 0) return;
			timeout = new Timer(duration, 1);
			timeout.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeoutComplete);
			timeout.start();
		}
		
		public function execute():* {
			return handler.apply(scope, params);
		}
		
		public function getCallback():Function {
            return function(...args):* {
                return callback.apply(this, args);
            };
		}
		
		public function cancel():void {
			if (timeout) timeout.stop();
		}
		
		protected function callback(...args):* {
			if (timeout) timeout.stop();
			this.params = args;
			var event:Event = new TimeoutCommandEvent(TimeoutCommandEvent.CALLED, this);
			dispatchEvent(event);
		}
		
		protected function onTimeoutComplete(timerEvent:TimerEvent):void {
			var event:TimeoutCommandEvent = new TimeoutCommandEvent(TimeoutCommandEvent.TIMED_OUT, this);
			dispatchEvent(event);
			if (failureHandler != null) failureHandler(event);
		}
		
		override public function toString():String {
			return '[TimeoutCommand scope=' + scope + ']';;
		}
	}
}
