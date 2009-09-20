package asunit.framework.async {
	import asunit.framework.TestCase;
	import flash.events.Event;

	public class AsyncTest extends TestCase {

		public function AsyncTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
		}

		protected override function tearDown():void {
		}

		//////
		public function test_addAsync_handler_can_be_retrieved_with_same_information():void {
			var cancelTimeout:Function = asunit.framework.async.addAsync(this, foo, 111);
			
			var operations:Array = Async.instance.getOperationsForTest(this);
			assertNotNull(operations);
			var operation0:FreeAsyncOperation = operations[0];
			
			// handler is public for now, for testing
			assertSame(foo, operation0.handler);
			cancelTimeout();
		}
		
		protected function foo():void {}
	}
}
