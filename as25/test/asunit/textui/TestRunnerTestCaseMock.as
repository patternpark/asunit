import asunit.framework.TestCase;

class asunit.textui.TestRunnerTestCaseMock extends TestCase {
	public var testMethod1Run:Boolean;
	public var testMethod2Run:Boolean;
	public var testMethod3Run:Boolean;
	
	public function TestRunnerTestCaseMock(methodName:String) {
		super(methodName);
	}
	
	public function testMethod1():Void {
		testMethod1Run = true;
	}
	
	public function testMethod1Completed():Void {
		trace("testMethod1Handler called");
	}
	
	public function testMethod2():Void {
		testMethod2Run = true;
	}
	
	public function testMethod3():Void {
		testMethod3Run = true;
	}
}