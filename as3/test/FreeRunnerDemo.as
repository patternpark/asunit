package  {
	import asunit.framework.FreeRunner;
	import asunit.textui.ResultPrinter;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	/**
	 * ...
	 * @author Robert Penner
	 */
	public class FreeRunnerDemo extends MovieClip {
		private var runner:FreeRunner;
		
		public function FreeRunnerDemo() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var printer:ResultPrinter = new ResultPrinter();
			addChild(printer);
			printer.width = stage.stageWidth;
			printer.height = stage.stageHeight;

			runner = new FreeRunner(this, printer);
			runner.run(new SpriteFreeTest());
		}
		
	}

}
///////////////////////////////////////////////////
/**
 *
 */
import flash.display.Sprite;
import asunit.asserts.*;

class SpriteFreeTest {
	protected var sprite:Sprite;
	
	public function SpriteFreeTest() {
	}
	
	[Before]
	public function before():void {
		sprite = new Sprite();
	}
	
	[After]
	public function after():void {
		sprite = null;
	}
	
	[Test]
	public function numChildren_is_0_by_default():void {
		assertEquals(0, sprite.numChildren);
	}
	
	[Test]
	public function stage_is_null_by_default():void {
		assertNull(sprite);
		//assertTrue(null);
	}
	
	[Test]
	public function fail_assertEquals():void {
		assertEquals('wrongName', sprite.name);
	}
	
	[Test]
	public function throw_Error():void {
		throw new Error('What happen?');
	}
	
}

