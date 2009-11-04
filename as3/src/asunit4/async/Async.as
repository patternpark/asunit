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
		
		public var commandsByTest:Dictionary;
		
		public function Async() {
			commandsByTest = new Dictionary(true);
		}
		
		public static function get instance():Async {
			if (!_instance) _instance = new Async();
			return _instance;
		}
		
		public function getCommandsForTest(test:Object):Array {
			var commands:Array = commandsByTest[test];
			// Clone to prevent changing by reference.
			return commands ? commands.concat() : [];
		}
		
		public function addAsync(test:Object, handler:Function, duration:int):Function {
			var command:TimeoutCommand = new TimeoutCommand(test, handler, duration);
			addCommandForTest(test, command);
			return command.getCallback();
		}
		
		protected function addCommandForTest(test:Object, command:TimeoutCommand):void {
			if (!commandsByTest[test])
				commandsByTest[test] = [];
				
			commandsByTest[test].push(command);
			command.addEventListener(TimeoutCommand.CALLED,	onTestResult);
			command.addEventListener(ErrorEvent.ERROR, 		onTestResult);
		}
		
		protected function onTestResult(e:Event):void {
			var command:TimeoutCommand = TimeoutCommand(e.currentTarget);
			command.removeEventListener(TimeoutCommand.CALLED,	onTestResult);
			command.removeEventListener(ErrorEvent.ERROR,		onTestResult);
			
			removeCommandForTest(command.scope, command);
		}
		
		public function removeCommandForTest(test:Object, command:TimeoutCommand):void {
			var commands:Array = commandsByTest[test];
			if (!commands) return;
			
			commands.splice(commands.indexOf(command), 1);
			// Remove the array when emptied.
			if (!commands.length)
				delete commandsByTest[test];
			//TODO: maybe dispatch event when the last command is removed
		}
		
	}
	
}
