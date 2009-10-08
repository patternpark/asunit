package asunit.framework.support {
	import asunit.asserts.*;
	
	public class FailAssertEqualsTest {

		public var methodsCalled:Array;
		
		public function FailAssertEqualsTest() {
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
		public function fail_assertEquals():void {
			methodsCalled.push(arguments.callee);
			assertEquals('right', 'wrong');
		}
	}
}
