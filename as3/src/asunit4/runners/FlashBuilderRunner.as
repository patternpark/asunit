package asunit4.runners {
	import flash.events.Event;
	import asunit4.printers.IResultPrinter;
	import asunit4.printers.FlashBuilderPrinter;
	import asunit4.events.TestResultEvent;
	import asunit4.SuiteRunner;

	public class FlashBuilderRunner {
		protected var runner:SuiteRunner;
		protected var printer:IResultPrinter;
		
		public function FlashBuilderRunner() {
			runner = new SuiteRunner();
			printer = new FlashBuilderPrinter();
		}
		
		public function start(suite:Class):void {
			printer.startTestRun();
			
			runner.addEventListener(TestResultEvent.TEST_COMPLETED, onTestCompleted);
			runner.addEventListener(Event.COMPLETE, onSuiteCompleted);
			runner.run(suite);
		}
		
		protected function onTestCompleted(e:TestResultEvent):void {
			printer.addTestResult(e.testResult);
		}
		
		protected function onSuiteCompleted(e:Event):void {
			printer.endTestRun();
		}
	}
}
