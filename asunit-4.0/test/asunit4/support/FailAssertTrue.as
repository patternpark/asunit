package asunit4.support {

	import asunit.asserts.*;

	public class FailAssertTrue {
		
		public var methodsCalled:Array;
		
		[Before]
		public function runBefore():void {
			methodsCalled = [];
			methodsCalled.push(arguments.callee);
		}
		
		[After]
		public function runAfter():void {
			methodsCalled.push(arguments.callee);
		}
		
		[Test]
		public function fail_assertTrue():void {
			methodsCalled.push(arguments.callee);
			assertTrue('Law of non-contradiction', false);
		}
		
	}

}
