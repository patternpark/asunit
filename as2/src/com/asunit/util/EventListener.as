
// immutable, protected class...
class com.asunit.util.EventListener extends Object {
	private var source:Object;
	private var event:String;
	private var scope:Object;
	public static var defaultEvent:String = "all"
	
	public function EventListener(evnt:String, src:Object, scp:Object) {
		if(src instanceof Function && !(scp instanceof Object)) {
			Sys.println(">> EventListener constructor may cause problems because Function reference passed without appropriate scope argument.");
		}
		source = src;
		scope = scp;
		event = (evnt == undefined || evnt == null) ? EventListener.defaultEvent : evnt;
	}
	
	public function getScope():Object {
		return scope;
	}
	
	public function getSource():Object {
		return source;
	}
	
	public function getEvent():String {
		return event;
	}
}
