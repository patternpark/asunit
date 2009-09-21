package asunit.framework {
	/**
	 * ...
	 * @author Robert Penner
	 */
	import flash.display.Sprite;
	import asunit.asserts.*;

	public class SpriteFreeTest {
		public var methodsCalled:Array;
		protected var sprite:Sprite;
		
		public function SpriteFreeTest() {
			methodsCalled = [];
		}
		
		public function setUp():void {
			methodsCalled.push(arguments.callee);
			sprite = new Sprite();
		}
		
		public function tearDown():void {
			methodsCalled.push(arguments.callee);
			sprite = null;
		}
		
		public function test_numChildren_is_0_by_default():void {
			methodsCalled.push(arguments.callee);
			assertEquals(0, sprite.numChildren);
		}
		
		public function test_stage_is_null_by_default():void {
			methodsCalled.push(arguments.callee);
			assertNull(sprite);
			//assertTrue(null);
		}
		
		public function test_fail_assertEquals():void {
			methodsCalled.push(arguments.callee);
			assertEquals('wrongName', sprite.name);
		}
		
		public function test_throw_Error():void {
			throw new Error('What happen?');
		}
		
	}

}