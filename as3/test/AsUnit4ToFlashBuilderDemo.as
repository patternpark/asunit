package  {
	import asunit4.FlashBuilderPrinter;
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
	import asunit4.support.SuiteOfTwoSuites;
	import flash.events.Event;
	
	[SWF(backgroundColor=0x333333)]
	public class AsUnit4ToFlashBuilderDemo extends MovieClip {
		protected var runner:SuiteRunner;
		protected var ui:MinimalUI;
		protected var printer:FlashBuilderPrinter;
		
		public function AsUnit4ToFlashBuilderDemo() {
			if (stage) {
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
			}

			runner = new SuiteRunner();
			
			runner.addEventListener(TestResultEvent.TEST_COMPLETED, onTestCompleted);
			runner.addEventListener(TestResultEvent.SUITE_COMPLETED, onSuiteCompleted);
			
			printer = new FlashBuilderPrinter();
			printer.addEventListener(Event.CONNECT, onPrinterReady);
			printer.connect();
		}
		
		protected function onPrinterReady(e:Event):void {
			printer.startTestRun();
			runner.run(SuiteOfTwoSuites);
		}
		
		protected function onTestCompleted(e:TestResultEvent):void {
			printer.addTestResult(e.testResult);
		}
		
		protected function onSuiteCompleted(e:TestResultEvent):void {
			printer.endTestRun();
		}
		
	}
}
