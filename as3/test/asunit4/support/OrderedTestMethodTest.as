package asunit4.support {
	import flash.display.Sprite;
	import asunit.asserts.*;

	public class OrderedTestMethodTest {
		
		public var methodsCalled:Array = [];
	
		public function OrderedTestMethodTest() {
		}
		
		// Method names are chosen to avoid coinciding with alphabetical order.
		
		[Test(order=2)]
		public function two():void {
			methodsCalled.push(arguments.callee);
		}
		
		[Test(order=3)]
		public function three():void {
			methodsCalled.push(arguments.callee);
		}
		
		[Test]
		public function orderZeroByDefault():void {
			methodsCalled.push(arguments.callee);
		}
		
		[Test(order=-1)]
		public function negativeOrderIsAllowed():void {
			methodsCalled.push(arguments.callee);
		}
		
		
	}
}
