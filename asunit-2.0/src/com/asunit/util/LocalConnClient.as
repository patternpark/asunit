
import com.asunit.util.*;

dynamic class com.asunit.util.LocalConnClient extends LocalConnection {

	public var serverId:String;

	public function LocalConnClient(srvrId:String) {
		init(srvrId);
	}

	private function init(srvrId:String):Void {
		serverId = srvrId;
	}

	public function __resolve(fname:String):Function {
		// Execute Any Method Call thru gateway on Server and return results...
		var ref:LocalConnClient = this;
		return Function( function() {
			arguments.unshift(fname);
			arguments.unshift("execResolve");
			arguments.unshift( ref.serverId);
			return ref.execMethod.apply(this, arguments);
		});
	}

	public function execMethod():Object {
		//send.apply(this, arguments);
		return send.apply(this, arguments);
	}

	public function onStatus(infoObject:Object):Void {
// 		trace("!! Client Local Connection Object.onStatus Called with : ");
// 		for(var i in arguments) {
// 			trace(i + " : " + arguments[i]);
// 			for(var k in arguments[i]) {
// 				trace(i + "." + k + " : "+ arguments[i][k]);
// 			}
// 		}
	}

}
