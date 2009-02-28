
import com.asunit.framework.*;

class com.asunit.framework.Reflection {
	private var visitedObjects:Array;
	private var qualifiedName:String;

	public static function getQualifiedName(ref:Object)
	{
		return new Reflection(ref).toString();
	}

	// Use static Constructor / getQualifiedName
	private function Reflection(ref:Object)
	{
		visitedObjects = new Array();
		qualifiedName = getNameSpace("", _global, ref);
	}

	public function toString()
	{
		return qualifiedName;
	}

	public function beenVisited(obj:Object):Boolean
	{
		for(var i in visitedObjects) {
			if(visitedObjects[i] == obj) {
				return true;
			}
		}
		return false;
	}

	public function openMember(ref:Object)
	{
		_global.ASSetPropFlags(ref, null, 6, true);
	}

	public function closeMember(ref:Object)
	{
		_global.ASSetPropFlags(ref, null, 0, true);
	}

	public function getNameSpace(name:String, ref:Object, obj:Object)
	{
		if(!beenVisited(ref)) {
			var str = name;
			openMember(ref);
			visitedObjects.push(ref);
			for(var i in ref) {
   				if(i == "prototype" || i == "__proto__" || i == "toLocaleString" || i == "constructor") {
   					continue;
   				}
				str += ((str == "") ? "" :".") + i;
				if(ref[i] == obj) {
					closeMember(ref);
					return str;
				}
				closeMember(ref);
				// check here so that looping continues if result is invalid...
				return getNameSpace(str, ref[i], obj);
			}
			closeMember(ref);
			return str;
		}
	}
}