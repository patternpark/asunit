package asunit4.events {

	import asunit4.async.TimeoutCommand;

	import flash.events.Event;

	public class TimeoutCommandEvent extends Event {
		public static const CALLED:String    = 'called';
		public static const TIMED_OUT:String = 'timedOut';
		
		public var command:TimeoutCommand;
		
		public function TimeoutCommandEvent(type:String, command:TimeoutCommand, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.command = command;
		}
		
		public override function clone():Event {
			return new TimeoutCommandEvent(type, command, bubbles, cancelable);
		}
		
		public override function toString():String {
			return formatToString("TimeoutCommandEvent", "command", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}
