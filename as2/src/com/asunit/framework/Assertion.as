
class com.asunit.framework.Assertion {
	private var className:String;
	private var methodName:String;
	private var message:String;
	private var assertion:String;
	private var passed:Boolean;

	private function Assertion(cName:String, mName:String, msg:String, assert:String)
	{
		className = cName;
		methodName = mName;
		message = msg;
		assertion = assert;
	}

	public function toString():String
	{
		var str:String = "";
		for(var i:String in this) {
			if(!(this[i] instanceof Function)) {
				str += i + " : " + this[i] + "\n";
			}
		}
		return str;
	}
}