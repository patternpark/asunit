package asunit4.async
{
	import asunit.framework.ErrorEvent;
	import asunit4.events.TimeoutCommandEvent;
	import flash.events.EventDispatcher;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 *
	 */
	public class Async extends EventDispatcher {
		
		public static var DEFAULT_TIMEOUT:uint = 50;
		
		private static var _instance:Async;
		
		public var pending:Array;
		
		public function Async() {
			pending = [];
		}
		
		public static function get instance():Async {
			if (!_instance) _instance = new Async();
			return _instance;
		}
		
		public function get hasPending():Boolean {
			return pending.length > 0;
		}
		
		public function addAsync(handler:Function, duration:int = -1):Function {
			if (duration == -1) duration = DEFAULT_TIMEOUT;
			var command:TimeoutCommand = new TimeoutCommand(null, handler, duration);
			addPending(command);
			return command.getCallback();
		}
		
		public static function proceedOnEvent(test:Object, target:IEventDispatcher, eventName:String, timeout:int = 500, timeoutHandler:Function = null):void {
			
			target.addEventListener(eventName, addAsync(null, timeout), false, 0, true);
		}
		
		public function cancelPending():void {
			for (var i:uint = pending.length; i--; ) {
				var command:TimeoutCommand = TimeoutCommand(pending.pop());
				command.cancel();
				command.removeEventListener(TimeoutCommandEvent.CALLED,	onTestResult);
				command.removeEventListener(TimeoutCommandEvent.TIMED_OUT,	onTestResult);
			}
		}
		
		internal function getPending():Array {
			// Clone to prevent changing by reference.
			return pending.concat();
		}
		
		protected function addPending(command:TimeoutCommand):void {
			pending.push(command);
			command.addEventListener(TimeoutCommandEvent.CALLED,	onTestResult);
			command.addEventListener(TimeoutCommandEvent.TIMED_OUT,	onTestResult);
			command.addEventListener(ErrorEvent.ERROR, 				onTestResult);
		}
		
		protected function onTestResult(e:Event):void {
			var command:TimeoutCommand = TimeoutCommand(e.currentTarget);
			command.removeEventListener(TimeoutCommandEvent.CALLED,		onTestResult);
			command.removeEventListener(TimeoutCommandEvent.TIMED_OUT,	onTestResult);
			removePending(command);
			dispatchEvent(e);
		}
		
		protected function removePending(command:TimeoutCommand):void {
			pending.splice(pending.indexOf(command), 1);
		}
	}
}
