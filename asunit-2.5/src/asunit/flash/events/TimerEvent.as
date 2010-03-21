import asunit.flash.events.Event;

class asunit.flash.events.TimerEvent extends Event {

	public static var TIMER_COMPLETE:String = "timerComplete";
	
	public function TimerEvent(type:String, target:Object) {
		super(type, target);
	}
	
	
}