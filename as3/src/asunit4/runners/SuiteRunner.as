package asunit4.runners {
	import asunit4.framework.IFreeTestResult;
	import flash.events.EventDispatcher;
	import asunit4.events.TestResultEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import asunit4.framework.SuiteIterator;
	
	public class SuiteRunner extends EventDispatcher {
		protected var testRunner:TestRunner;
		protected var suiteRunner:SuiteRunner;
		protected var testClasses:SuiteIterator;
		protected var timer:Timer;
		
		public function SuiteRunner() {
			timer = new Timer(0, 1);
			timer.addEventListener(TimerEvent.TIMER, runNextTest);
		}
		
		public function run(suite:Class):void {
			testRunner = new TestRunner();
			testRunner.addEventListener(TestResultEvent.TEST_COMPLETED, onTestCompleted);
			testClasses = new SuiteIterator(suite);
			
			runNextTest();
		}
		
		protected function runNextTest(e:TimerEvent = null):void{
			if (!testClasses.hasNext()) {
				onSuiteCompleted();
				return;
			}
			
			var testClass:Class = testClasses.next();
			testRunner.run(new testClass());
		}
		
		protected function onSuiteCompleted():void {
			testRunner.removeEventListener(TestResultEvent.TEST_COMPLETED, onTestCompleted);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function onTestCompleted(e:TestResultEvent):void {
			trace('SuiteRunner.onTestCompleted() - e.testResult: ' + e.testResult);
			dispatchEvent(e);
			
			// Start a new green thread.
			timer.reset();
			timer.start();
		}
		
	}
}
