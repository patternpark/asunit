
import com.asunit.framework.*;

class com.asunit.framework.AsUnit extends TestSuite {
	private var className:String = "asunit.framework.AsUnit";
	private var output:Sys;
	private var testCase:TestCase;
	private var testSuite:TestSuite;

	public function AsUnit() {
		init();
	}

	private function init():Void {
		testSuite = new TestSuite();
		testCase = new TestCase();
	}

}