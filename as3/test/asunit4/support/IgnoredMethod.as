package asunit4.support {

	import asunit.asserts.*;

	public class IgnoredMethod {
		
		[Before]
		public function runBefore():void {
		}
		
		[After]
		public function runAfter():void {
		}
		
		[Ignore("because")]
		[Test]
		public function should_be_ignored():void {
			fail('this test method should be ignored');
		}

		[Test]
        public function should_not_be_ignored():void {
        }
		
	}
}
