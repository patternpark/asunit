import asunit.flash.events.TimerEvent;
import asunit.flash.events.EventDispatcher;

class asunit.flash.utils.Timer extends EventDispatcher {

	private static var STOPPED:Number = 0;
	private static var RUNNING:Number = 1;

	private var _intervalID : Number;
	private var _delay : Number;
	private var _repeatCount : Number;
	private var _currentCount : Number;
	
	private var state:Number;

	public function Timer(delay:Number, repeatCount:Number) {
		if(repeatCount==undefined) repeatCount=0;
		_delay = delay;
		_repeatCount = repeatCount;
		_currentCount = 0;
	}

	public function start() : Void {
		if(state==RUNNING) return;
		state = RUNNING;
		_intervalID = setInterval(this, "onInterval", _delay);
	}

	public function stop() : Void {
		if(state==STOPPED) return;
		clear();
		state = STOPPED;
	}

	public function reset() : Void {
		clear();
		state = STOPPED;
		_currentCount = 0;
	}

	private function clear() : Void{
		if(_intervalID!=null) clearInterval(_intervalID);	
	}

	private function onInterval():Void{
		_currentCount++;
		if(_currentCount==_repeatCount) {
			stop();
			dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE, this));
		}
	}
	
	public function get currentCount():Number{
		return _currentCount;
	}
	
	/*
	 * _global.setTimeout() is only available in FP8+
	 */
	public static function setTimeout(scope:Object, callback:Object, duration:Number):Void{
		var t:Timer = new Timer(duration, 1);
		var args:Array = arguments.length > 3 ? arguments.slice(3) : [];
		// normalise callback as Function
		if(callback instanceof String) callback = scope[callback];
		t.addEventListener(TimerEvent.TIMER_COMPLETE,
							function():Void{
								Function(callback).apply(scope, args);
							});
		t.start();
	}
}