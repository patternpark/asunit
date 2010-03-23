package asunit.support {

	import asunit.asserts.*;

	public class SucceedAssertTrue{
		
		public var methodsCalled:Array;
		
		public function SucceedAssertTrue() {
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
		public function succeed_assertTrue():void {
			methodsCalled.push(arguments.callee);
			assertTrue(true);
		}
		
	}

}
