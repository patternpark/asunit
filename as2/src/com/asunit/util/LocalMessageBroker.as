
import com.asunit.util.*;

class com.asunit.util.LocalMessageBroker extends Object implements Observable {
	private static var instance:LocalMessageBroker;
	private var msgs:Array;
	private var eventSrc:EventSource;
	
	private function LocalMessageBroker() {
		init();
	}
	
	private function init():Void {
		msgs = new Array();
		eventSrc = new EventSource();
	}
	
	public static function getInstance():LocalMessageBroker {
		if(instance == undefined) {
			instance = new LocalMessageBroker();
		}
		return instance;
	}
	
	public function send(msg:String, category:String):String {
		msgs.push({message:msg, category:category});
		eventSrc.broadcastMessage("onMessageSent", {event:"onMessageSent", message:msg, category:category});
		return msg;
	}
	
	public function toString():String {
		var str:String = "";
		for(var i:Number = 0; i < msgs.length; i++) {
			str += msgs[i] + "\n";
		}
		return str;
	}
	
	// Can accept either an event:String or an event:String[]
	// if the observer wants to subscribe to multiple events.
	public function addEventListener(event:String, observer:Object, scope:Object):Void {
		eventSrc.addEventListener(event, observer, scope);
	}
	
	public function addListener(observer:Object, scope:Object):Void {
		eventSrc.addListener(observer, scope);
	}

	// Should return bool false if handler ref was not found.
	// Should return bool true if handler ref was found
	public function removeEventListener(event:String, observer:Object):Boolean {
		return eventSrc.removeEventListener(event, observer);
	}
	
	public function removeListener(observer:Object):Boolean {
		return eventSrc.removeListener(observer);
	}
}
