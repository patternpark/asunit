
import com.asunit.framework.*;
import com.asunit.util.*;

class com.asunit.framework.TestRunner extends Array {
	public static var localConn:LocalConnClient;
	private var intervalId:Number;
	private var interval:Number = 10;
	private var tests:Array;

	private static function getLocalConn():LocalConnClient {
		if(localConn == null) {
			localConn = LocalConnGateway.createClient("_AsUnitTestRunner");
			localConn["clearTestDisplay"]();
		}
		return localConn;
	}

	public function TestRunner() {
		tests = new Array();
	}

	public function push(item:Object):Number {
		var num:Number = tests.push(item);
		clearInterval(intervalId);

		if(num > 100) {
			renderTests();
		} else {
			intervalId = setInterval(this, "renderTests", interval);
		}
		return num;
	}

	public function renderTests():Void {
		clearInterval(intervalId);
		var lc:LocalConnClient = getLocalConn();
		lc["addTests"](tests);
		tests = new Array();
	}
}
