package asunit4 {
	import asunit.framework.TestCase;
	import flash.events.Event;
	import flash.utils.describeType;
	import asunit4.support.DoubleFailSuite;
	import asunit4.support.FailAssertTrueTest;
	import asunit4.support.FailAssertEqualsTest;
	import asunit4.events.TestResultEvent;
	import asunit.framework.ITestFailure;

	public class SuiteRunnerTest extends TestCase {
		private var suiteRunner:SuiteRunner;
		private var suiteClass:Class;

		public function SuiteRunnerTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			suiteRunner = new SuiteRunner();
			suiteClass = DoubleFailSuite;
		}

		protected override function tearDown():void {
			suiteRunner = null;
			suiteClass = null;
		}
		
		//////
		
		public function test_run_triggers_COMPLETE_Event():void {
			suiteRunner.addEventListener(Event.COMPLETE, addAsync(check_TestResult_wasSuccessful_false, 100));
			suiteRunner.run(suiteClass);
		}
		
		private function check_TestResult_wasSuccessful_false(e:Event):void {
			assertSame(suiteRunner, e.currentTarget);
		}
	}
}
