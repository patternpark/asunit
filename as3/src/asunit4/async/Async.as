package asunit4.async {
	import asunit4.async.TimeoutCommand;
	import asunit.framework.ErrorEvent;
	import flash.utils.Dictionary;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import asunit.framework.Assert;
	
	/**
	 *
	 */
	public class Async {
		
		private static var _instance:Async;
		
		public var pending:Array;
		
		public function Async() {
			pending = [];
		}
		
		public static function get instance():Async {
			if (!_instance) _instance = new Async();
			return _instance;
		}
		
		public function getPending():Array {
			// Clone to prevent changing by reference.
			return pending.concat();
		}
		
		public function addAsync(handler:Function, duration:int):Function {
			var command:TimeoutCommand = new TimeoutCommand(null, handler, duration);
			addPending(command);
			return command.getCallback();
		}
		
		public static function proceedOnEvent(test:Object, target:IEventDispatcher, eventName:String, timeout:int = 500, timeoutHandler:Function = null):void {
			
			target.addEventListener(eventName, addAsync(null, timeout), false, 0, true);
		}
		
		protected function addPending(command:TimeoutCommand):void {
			pending.push(command);
			command.addEventListener(TimeoutCommand.CALLED,	onTestResult);
			command.addEventListener(ErrorEvent.ERROR, 		onTestResult);
		}
		
		protected function onTestResult(e:Event):void {
			var command:TimeoutCommand = TimeoutCommand(e.currentTarget);
			command.removeEventListener(TimeoutCommand.CALLED,	onTestResult);
			command.removeEventListener(ErrorEvent.ERROR,		onTestResult);
			
			removePending(command);
		}
		
		protected function removePending(command:TimeoutCommand):void {
			pending.splice(pending.indexOf(command), 1);
			//TODO: maybe dispatch event when the last command is removed
		}
		
	}
	
}
