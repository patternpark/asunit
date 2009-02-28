
import com.asunit.util.*;

class com.asunit.util.EventSource implements Observable {
	private var listeners:Array;

	public function EventSource() {
		listeners = new Array();
	}
	
	public function addEventListener(event:String, observer:Object, scope:Object):Void {
		if(typeof(observer) == "string") {
			Sys.println(">> failed to addEventListener because observer argument is type:String.");
			return;
		} else if(event.indexOf(",") > -1) {
			parseMultipleEvents(event, observer, scope);
			return;
		} else if(getListenerIndex(event, observer) > -1) {
			return;
		}
		listeners.push(new EventListener(event, observer, scope));
	}
	
	public function removeEventListener(event:String, observer:Object):Boolean {
		var index:Number = getListenerIndex(event, observer);
		var found:Boolean = false;

		do {
			listeners.splice(index, 1);
			index = getListenerIndex(event, observer);
			found = true;
		} while (index > -1);
		return found;
	}
	
	public function addListener(observer:Object, scope:Object):Void {
		if(typeof(observer) == "string") {
			Sys.println(">> attempting to addListener with invalid argument - try addEventListener");
			return;
		}
		addEventListener(EventListener.defaultEvent, observer, scope);
	}
	
	public function removeListener(observer:Object):Boolean {
		// Needs updated to remove all instances that have this observer?
		// If no event name identified...
		return removeEventListener(EventListener.defaultEvent, observer);
	}
	
	public function getListenerCount():Number {
		return listeners.length;
	}
	
	public function getListenerIndex(event:Object, observer:Object):Number {
		for(var i:Number=0; i<listeners.length; i++) {
			if(event == null || event == undefined || event == EventListener.defaultEvent) {
				if(listeners[i].getSource() == observer) {
					return i;
				}
			} else if(listeners[i].getEvent() == event && listeners[i].getSource() == observer) {
				return i;
			}
		}
		return -1;
	}
	
	public function parseMultipleEvents(events:Object, observer:Object):Void {
		var evnts:Array = events.split(",");
		var ln:Number = evnts.length;
		for(var i:Number = 0; i < ln; i++) {
			addEventListener(evnts[i], observer);
		}
	}
	
	public function broadcastMessage():Void {
		var eventName:Object = arguments.shift();
		var list:Array = listeners;
		var ln:Number = list.length;
		for(var i:Number = 0; i < ln; i++) {
			if(list[i].getEvent() == eventName || list[i].getEvent() == EventListener.defaultEvent) {
				if(list[i].getSource() instanceof Function) {
 					list[i].getSource().apply(list[i].getScope(), arguments);
				} else {
					list[i].getSource()[eventName].apply(list[i].getSource(), arguments);
				}
			}
		}	
	}
}