
interface com.asunit.util.Observable {
	// Can accept either an event:String or an event:String[]
	// if the observer wants to subscribe to multiple events.
	public function addEventListener(event:String, observer:Object, scope:Object):Void;
	public function addListener(observer:Object, scope:Object):Void;
	// Should return bool false if handler ref was not found.
	// Should return bool true if handler ref was found
	public function removeEventListener(event:String, observer:Object):Boolean;
	public function removeListener(observer:Object):Boolean;
}
