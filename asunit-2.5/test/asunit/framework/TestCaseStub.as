import asunit.framework.TestCase;

class asunit.framework.TestCaseStub extends TestCase {
	
	public var className:String = "asunit.framework.TestCaseMock";
	
	public var testMethod1Run:Boolean;
	public var testMethod2Run:Boolean;
	public var testMethod3Run:Boolean;
	
	public function TestCaseStub(methodName:String) {
		super(methodName);
	}
	
	public function testMethod1():Void {
		testMethod1Run = true;
	}
	
	public function testMethod2():Void {
		testMethod2Run = true;
	}
	
	public function testMethod3():Void {
		testMethod3Run = true;
	}
}
