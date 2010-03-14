package asunit4.runners
{
	import asunit.framework.TestCase;

	import asunit4.framework.Result;
	import asunit4.support.DoubleFailSuite;

	import flash.events.Event;

	public class SuiteRunnerTest extends TestCase {
		private var suiteRunner:SuiteRunner;
		private var runnerResult:Result;

		public function SuiteRunnerTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			suiteRunner = new SuiteRunner();
			runnerResult = new Result();
		}

		protected override function tearDown():void {
			suiteRunner = null;
			runnerResult = null;
		}
		
		//////
		
		public function test_run_triggers_COMPLETE_Event():void {
			suiteRunner.addEventListener(Event.COMPLETE, addAsync(check_Result_wasSuccessful_false, 500));
			suiteRunner.run(DoubleFailSuite, runnerResult);
		}
		
		private function check_Result_wasSuccessful_false(e:Event):void {
			assertFalse(runnerResult.wasSuccessful);
		}
	}
}
