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
            return wrapHandlerWithCorrectNumberOfArgs();
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

        protected function wrapHandlerWithCorrectNumberOfArgs():Function {
            switch (handler.length) {
                case 0: return function():* { return callback(); };
                case 1: return function(a:*=null):* { return callback(a); };
                case 2: return function(a:*=null, b:*=null):* { return callback(a, b); };
                case 3: return function(a:*=null, b:*=null, c:*=null):* { return callback(a, b, c); };
                case 4: return function(a:*=null, b:*=null, c:*=null, d:*=null):* { return callback(a, b, c, d); };
                case 5: return function(a:*=null, b:*=null, c:*=null, d:*=null, e:*=null):* { return callback(a, b, c, d, e); };
                case 6: return function(a:*=null, b:*=null, c:*=null, d:*=null, e:*=null, f:*=null):* { return callback(a, b, c, d, e, f); };
                case 7: return function(a:*=null, b:*=null, c:*=null, d:*=null, e:*=null, f:*=null, g:*=null):* { return callback(a, b, c, d, e, f, g); };
                case 8: return function(a:*=null, b:*=null, c:*=null, d:*=null, e:*=null, f:*=null, g:*=null, h:*=null):* { return callback(a, b, c, d, e, f, g, h); };
                case 9: return function(a:*=null, b:*=null, c:*=null, d:*=null, e:*=null, f:*=null, g:*=null, h:*=null, i:*=null):* { return callback(a, b, c, d, e, f, g, h, i); };
            }
            return callback;
        }
		
		override public function toString():String {
			return '[TimeoutCommand scope=' + scope + ']';;
		}
	}
}
