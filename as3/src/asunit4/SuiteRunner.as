package asunit4 {
	import asunit.framework.ITestResult;
	import flash.events.EventDispatcher;
	import asunit4.events.TestResultEvent;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class SuiteRunner extends EventDispatcher {
		protected var testRunner:FreeRunner;
		protected var testClasses:SuiteIterator;
		protected var result:ITestResult;
		protected var timer:Timer;
		
		public function SuiteRunner() {
			timer = new Timer(0, 1);
			timer.addEventListener(TimerEvent.TIMER, runNextTest);
		}
		
		public function run(suite:Object, result:ITestResult = null):void {
			this.result = result || new FreeTestResult();
			testRunner = new FreeRunner();
			testRunner.addEventListener(TestResultEvent.TEST_COMPLETED, onTestCompleted);
			testClasses = new SuiteIterator(suite);
			
			runNextTest();
		}
		
		protected function runNextTest(e:TimerEvent = null):void{
			trace('later: ' + getTimer());
			if (!testClasses.hasNext()) {
				testRunner.removeEventListener(TestResultEvent.TEST_COMPLETED, onTestCompleted);
				dispatchEvent(new TestResultEvent(TestResultEvent.SUITE_COMPLETED, result));
				return;
			}
			
			var testClass:Class = testClasses.next();
			testRunner.run(new testClass(), result);
		}
		
		protected function onTestCompleted(e:TestResultEvent):void {
			trace('SuiteRunner.onTestCompleted() - e.testResult: ' + e.testResult);
			trace('timer: ' + getTimer());

			// Start a new green thread.
			timer.reset();
			timer.start();
		}
		
	}
}
