import asunit.textui.TestRunner;
import asunit.framework.TestCase;

class asunit.textui.TestRunnerTest extends TestCase {
	
	public var className:String = "asunit.textui.TestRunnerTest";
	
	private var instance : TestRunner;

	public function TestRunnerTest(testMethod:String) {
		super(testMethod);
	}

	private function setUp():Void {
		instance = new TestRunner();
	}

	private function tearDown():Void {
		instance = null;
	}

	public function testInstantiated():Void {
		assertTrue("TestRunner instantiated with: " + instance, instance instanceof TestRunner);
	}
}
