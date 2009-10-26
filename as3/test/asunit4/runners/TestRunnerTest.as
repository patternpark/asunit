package asunit4.runners {
	import asunit.framework.TestCase;
	import flash.events.Event;
	import asunit4.support.FreeTestWithSprite;
	import asunit4.events.TestResultEvent;
	import asunit.framework.ITestFailure;
	import asunit4.framework.FreeTestFailure;

	public class TestRunnerTest extends TestCase {
		private var runner:TestRunner;
		private var test:FreeTestWithSprite;

		public function TestRunnerTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			runner = new TestRunner();
			test = new FreeTestWithSprite();
		}

		protected override function tearDown():void {
			runner = null;
		}

		public function testInstantiated():void {
			assertTrue("TestRunner instantiated", runner is TestRunner);
		}
		
		public function test_free_test_does_not_extend_TestCase():void
		{
			assertFalse(test is TestCase);
		}

		//////
		// For now, the test methods are sorted alphabetically to enable precise testing.
		public function test_run_calls_setup_before_and_tearDown_after_each_test_method():void {
			runner.addEventListener(TestResultEvent.TEST_COMPLETED, addAsync(check_methodsCalled_after_run, 100));
			runner.run(test);
		}
		
		private function check_methodsCalled_after_run(e:TestResultEvent):void {
			assertEquals(15, test.methodsCalled.length);
			
			assertSame(test.runBefore1, 						test.methodsCalled[0]);
			assertSame(test.runBefore2, 						test.methodsCalled[1]);
			assertSame(test.fail_assertEquals,					test.methodsCalled[2]);
			assertSame(test.runAfter1, 							test.methodsCalled[3]);
			assertSame(test.runAfter2, 							test.methodsCalled[4]);

			assertSame(test.runBefore1, 						test.methodsCalled[5]);
			assertSame(test.runBefore2, 						test.methodsCalled[6]);
			assertSame(test.numChildren_is_0_by_default,		test.methodsCalled[7]);
			assertSame(test.runAfter1, 							test.methodsCalled[8]);
			assertSame(test.runAfter2, 							test.methodsCalled[9]);
			
			assertSame(test.runBefore1, 						test.methodsCalled[10]);
			assertSame(test.runBefore2, 						test.methodsCalled[11]);
			assertSame(test.stage_is_null_by_default, 			test.methodsCalled[12]);
			assertSame(test.runAfter1, 							test.methodsCalled[13]);
			assertSame(test.runAfter2, 							test.methodsCalled[14]);
		}
		//////
		public function test_run_triggers_TestResultEvent_with_wasSuccessful_false_and_failures():void {
			runner.addEventListener(TestResultEvent.TEST_COMPLETED, addAsync(check_TestResult_wasSuccessful_false, 100));
			runner.run(test);
		}
		
		private function check_TestResult_wasSuccessful_false(e:TestResultEvent):void {
			//trace('failures: ' + e.testResult.failures());
			assertFalse(e.testResult.wasSuccessful);
			
			var failures:Array = e.testResult.failures;
			assertEquals('one failure in testResult', 1, failures.length);
			
			var failure0:ITestFailure = failures[0] as FreeTestFailure;
			assertSame(test, failure0.failedTest);
		}
		
	}
}
