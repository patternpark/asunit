package asunit4.runners {
	import flash.events.Event;
	import asunit4.printers.IResultPrinter;
	import asunit4.printers.FlashBuilderPrinter;
	import asunit4.events.TestResultEvent;
	import asunit4.runners.SuiteRunner;
	import flash.events.EventDispatcher;

	public class BaseRunner extends EventDispatcher {
		protected var suiteRunner:SuiteRunner;
		protected var printer:IResultPrinter;
		
		public function BaseRunner(printer:IResultPrinter) {
			suiteRunner = new SuiteRunner();
			this.printer = printer;
		}
		
		public function start(suite:Class):void {
			printer.startTestRun();
			
			suiteRunner.addEventListener(TestResultEvent.TEST_COMPLETED, onTestCompleted);
			suiteRunner.addEventListener(Event.COMPLETE, onSuiteCompleted);
			suiteRunner.run(suite);
		}
		
		protected function onTestCompleted(e:TestResultEvent):void {
			printer.addTestResult(e.testResult);
		}
		
		protected function onSuiteCompleted(e:Event):void {
			printer.endTestRun();
			suiteRunner.removeEventListener(TestResultEvent.TEST_COMPLETED, onTestCompleted);
			suiteRunner.removeEventListener(Event.COMPLETE, onSuiteCompleted);
			dispatchEvent(e);
		}
	}
}
