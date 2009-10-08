package asunit.framework.support {
	import asunit.asserts.*;

	public class FailAssertTrueTest {
		
		public var methodsCalled:Array;
		
		public function FailAssertTrueTest() {
			methodsCalled = [];
		}
		
		[Before]
		public function runBefore():void {
			methodsCalled.push(arguments.callee);
		}
		
		[After]
		public function runAfter():void {
			methodsCalled.push(arguments.callee);
		}
		
		[Test]
		public function fail_assertTrue():void {
			methodsCalled.push(arguments.callee);
			assertTrue(false);
		}
		
	}

}
