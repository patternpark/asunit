
import com.asunit.framework.*;

class com.asunit.framework.TestSetup extends TestCase {
 
	private function runMethod(method:String):Void {
		setCurrentMethod(method);
		this[method]();
	}

	private function run():Void {
		var mList:Array = getMethods();
		setUp();
		for(var i:Number=0; i<mList.length; i++) {
			runMethod(mList[i]);
		}
		tearDown();
	}
}
