package  {
	import asunit4.FreeRunner;
	import asunit.textui.ResultPrinter;
	import asunit4.ui.MinimalUI;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import asunit4.events.TestResultEvent;
	import asunit4.FreeTestResult;
	import asunit4.SuiteRunner;
	import asunit4.support.DoubleFailSuite;
	
	[SWF(backgroundColor=0x333333)]
	public class AsUnit4Demo extends MovieClip {
		//protected var runner:FreeRunner;
		protected var runner:SuiteRunner;
		protected var ui:MinimalUI;
		
		public function AsUnit4Demo() {
			if (stage) {
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
			}
			
			ui = new MinimalUI()
			addChild(ui);

			//runner = new FreeRunner();
			runner = new SuiteRunner();
			
			runner.addEventListener(TestResultEvent.TEST_COMPLETED, onTestCompleted);
			runner.addEventListener(TestResultEvent.SUITE_COMPLETED, onSuiteCompleted);
			
			//runner.run(new SpriteFreeTest());
			runner.run(DoubleFailSuite);
		}
		
		protected function onTestCompleted(e:TestResultEvent):void {
			//ui.addTestResult(e.testResult);
		}
		
		protected function onSuiteCompleted(e:TestResultEvent):void {
			ui.addTestResult(e.testResult);
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

