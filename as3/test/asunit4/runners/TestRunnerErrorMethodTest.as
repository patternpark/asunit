package asunit4.runners {
	import asunit.framework.TestCase;
	import flash.events.Event;
	import asunit4.support.ErrorInMethodTest;
	import asunit4.events.TestResultEvent;
	import asunit4.IFreeTestResult;
	import asunit4.FreeTestFailure;

	public class TestRunnerErrorMethodTest extends TestCase {
		private var runner:TestRunner;
		private var freeTest:ErrorInMethodTest;

		public function TestRunnerErrorMethodTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			runner = new TestRunner();
			freeTest = new ErrorInMethodTest();
		}

		protected override function tearDown():void {
			runner = null;
		}

		public function testInstantiated():void {
			assertTrue("TestRunner instantiated", runner is TestRunner);
		}
		
		//////
		public function test_runTest_triggers_TestResultEvent_with_errors():void {
			runner.addEventListener(TestResultEvent.TEST_COMPLETED, addAsync(check_TestResult_has_one_error, 100));
			runner.run(freeTest);
		}
		
		private function check_TestResult_has_one_error(e:TestResultEvent):void {
			var result:IFreeTestResult = e.testResult;
			assertFalse(result.wasSuccessful);
			
			assertEquals('one error in testResult',   1, result.errorCount);
			assertEquals('no failures in testResult', 0, result.failureCount);
			
			var failure0:FreeTestFailure = result.errors[0] as FreeTestFailure;
			assertTrue('thrownException is correct type', failure0.thrownException is ArgumentError);
			assertSame('failedTest reference', freeTest, failure0.failedTest);
			assertSame('failedMethod name', 'throw_ArgumentError', failure0.failedMethod);
		}
		
	}
}
