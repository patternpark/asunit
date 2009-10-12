package  {
	import asunit4.FreeRunner;
	import asunit.textui.ResultPrinter;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import asunit4.events.TestResultEvent;
	import asunit4.FreeTestResult;
	
	/**
	 * ...
	 * @author Robert Penner
	 */
	public class FreeRunnerDemo extends MovieClip {
		private var runner:FreeRunner;
		private var printer:ResultPrinter;
		
		public function FreeRunnerDemo() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			printer = new ResultPrinter();
			addChild(printer);
			printer.width = stage.stageWidth;
			printer.height = stage.stageHeight;

			runner = new FreeRunner();
			runner.printer = printer;
			runner.addEventListener(TestResultEvent.TEST_COMPLETED, onTestResult);
			runner.run(new SpriteFreeTest());
		}
		
		private function onTestResult(e:TestResultEvent):void {
			trace('onTestResult()');
			//printer.endTest(currentTest);
			printer.printResult(e.testResult, FreeTestResult(e.testResult).runTime);
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

