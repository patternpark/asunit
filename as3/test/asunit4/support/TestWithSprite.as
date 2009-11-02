package asunit4.support {
	import flash.display.Sprite;
	import asunit.asserts.*;

	public class TestWithSprite {
		
		public static var methodsCalled:Array;
		protected var sprite:Sprite;
	
		public function TestWithSprite() {
		}
		
		[BeforeClass]
		public static function runBeforeClass1():void {
			methodsCalled.push(arguments.callee);
		}
		
		[BeforeClass]
		public static function runBeforeClass2():void {
			methodsCalled.push(arguments.callee);
		}
		
		[Before]
		public function runBefore1():void {
			methodsCalled.push(arguments.callee);
			sprite = new Sprite();
		}
		
		[Before]
		public function runBefore2():void {
			methodsCalled.push(arguments.callee);
		}
		
		[After]
		public function runAfter1():void {
			methodsCalled.push(arguments.callee);
			sprite = null;
		}
		
		[After]
		public function runAfter2():void {
			methodsCalled.push(arguments.callee);
		}
		
		[Test]
		public function numChildren_is_0_by_default():void {
			methodsCalled.push(arguments.callee);
			assertEquals(0, sprite.numChildren);
		}
		
		[Test]
		public function stage_is_null_by_default():void {
			methodsCalled.push(arguments.callee);
			assertNull(sprite.stage);
		}
		
		[Test]
		public function fail_assertEquals():void {
			methodsCalled.push(arguments.callee);
			assertEquals('wrongName', sprite.name);
		}
		
		[AfterClass]
		public static function runAfterClass1():void {
			methodsCalled.push(arguments.callee);
		}
		
		[AfterClass]
		public static function runAfterClass2():void {
			methodsCalled.push(arguments.callee);
		}
		
		
	}

}
