import asunit.framework.TestFailure;
import asunit.framework.TestCase;

class asunit.framework.TestFailureTest extends TestCase {

	public var className:String = "asunit.framework.TestFailureTest";

	public function TestFailureTest(testMethod:String) {
		super(testMethod);
	}

	public function testInstantiated():Void {
		var failure : TestFailure = new TestFailure(this, new Error());
		assertTrue(failure instanceof TestFailure);
	}
}