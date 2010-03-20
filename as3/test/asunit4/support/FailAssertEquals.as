package asunit4.support {

	import asunit.asserts.*;
	
	public class FailAssertEquals {

		public var methodsCalled:Array;
		
		public function FailAssertEquals() {
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
			assertEquals('Words should be equal', 'right', 'wrong');
		}
	}
}
