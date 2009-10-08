package asunit.framework.support {
	import flash.display.Sprite;
	import asunit.asserts.*;

	public class SpriteMetadataTest {
		
		public var methodsCalled:Array;
		protected var sprite:Sprite;
	
		public function SpriteMetadataTest() {
			methodsCalled = [];
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
		
		
	}

}
