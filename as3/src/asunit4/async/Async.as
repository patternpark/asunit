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
		
		public var pendingForTest:Dictionary;
		
		public function Async() {
			pendingForTest = new Dictionary(true);
		}
		
		public static function get instance():Async {
			if (!_instance) _instance = new Async();
			return _instance;
		}
		
		public function getPendingForTest(test:Object):Array {
			var commands:Array = pendingForTest[test];
			// Clone to prevent changing by reference.
			return commands ? commands.concat() : [];
		}
		
		public function addAsync(test:Object, handler:Function, duration:int):Function {
			var command:TimeoutCommand = new TimeoutCommand(test, handler, duration);
			addPendingForTest(test, command);
			return command.getCallback();
		}
		
		public static function proceedOnEvent(test:Object, target:IEventDispatcher, eventName:String, timeout:int = 500, timeoutHandler:Function = null):void {
			
			target.addEventListener(eventName, addAsync(test, null, timeout), false, 0, true);
		}
		
		protected function addPendingForTest(test:Object, command:TimeoutCommand):void {
			if (!pendingForTest[test])
				pendingForTest[test] = [];
				
			pendingForTest[test].push(command);
			command.addEventListener(TimeoutCommand.CALLED,	onTestResult);
			command.addEventListener(ErrorEvent.ERROR, 		onTestResult);
		}
		
		protected function onTestResult(e:Event):void {
			var command:TimeoutCommand = TimeoutCommand(e.currentTarget);
			command.removeEventListener(TimeoutCommand.CALLED,	onTestResult);
			command.removeEventListener(ErrorEvent.ERROR,		onTestResult);
			
			removePendingForTest(command.scope, command);
		}
		
		public function removePendingForTest(test:Object, command:TimeoutCommand):void {
			var commands:Array = pendingForTest[test];
			if (!commands) return;
			
			commands.splice(commands.indexOf(command), 1);
			// Remove the array when emptied.
			if (!commands.length)
				delete pendingForTest[test];
			//TODO: maybe dispatch event when the last command is removed
		}
		
	}
	
}
