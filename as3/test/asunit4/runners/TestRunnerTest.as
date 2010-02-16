package asunit4.runners {
	import asunit.framework.TestCase;
	import asunit4.framework.Result;
	import flash.events.Event;
	import asunit4.support.MultiMethodTest;
	import asunit.framework.ITestFailure;
	import asunit4.framework.TestFailure;

	public class TestRunnerTest extends TestCase {
		private var runner:TestRunner;
		private var runnerResult:Result;
		private var test:MultiMethodTest;

		public function TestRunnerTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			runner = new TestRunner();
			runnerResult = new Result();
			MultiMethodTest.methodsCalled = [];
			test = new MultiMethodTest();
		}

		protected override function tearDown():void {
			runner = null;
			MultiMethodTest.methodsCalled = null;
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
			runner.addEventListener(Event.COMPLETE, addAsync(check_methodsCalled_after_run, 500));
			runner.run(test, runnerResult);
		}
		
		private function check_methodsCalled_after_run(e:Event):void {
			assertEquals(19, MultiMethodTest.methodsCalled.length);
			var i:uint = 0;
			
			assertSame(MultiMethodTest.runBeforeClass1, 		MultiMethodTest.methodsCalled[i++]);
			assertSame(MultiMethodTest.runBeforeClass2, 		MultiMethodTest.methodsCalled[i++]);
			
			assertSame(test.runBefore1, 						MultiMethodTest.methodsCalled[i++]);
			assertSame(test.runBefore2, 						MultiMethodTest.methodsCalled[i++]);
			assertSame(test.fail_assertEquals,					MultiMethodTest.methodsCalled[i++]);
			assertSame(test.runAfter1, 							MultiMethodTest.methodsCalled[i++]);
			assertSame(test.runAfter2, 							MultiMethodTest.methodsCalled[i++]);

			assertSame(test.runBefore1, 						MultiMethodTest.methodsCalled[i++]);
			assertSame(test.runBefore2, 						MultiMethodTest.methodsCalled[i++]);
			assertSame(test.numChildren_is_0_by_default,		MultiMethodTest.methodsCalled[i++]);
			assertSame(test.runAfter1, 							MultiMethodTest.methodsCalled[i++]);
			assertSame(test.runAfter2, 							MultiMethodTest.methodsCalled[i++]);
			
			assertSame(test.runBefore1, 						MultiMethodTest.methodsCalled[i++]);
			assertSame(test.runBefore2, 						MultiMethodTest.methodsCalled[i++]);
			assertSame(test.stage_is_null_by_default, 			MultiMethodTest.methodsCalled[i++]);
			assertSame(test.runAfter1, 							MultiMethodTest.methodsCalled[i++]);
			assertSame(test.runAfter2, 							MultiMethodTest.methodsCalled[i++]);
		}
		//////
		public function test_run_triggers_ResultEvent_with_wasSuccessful_false_and_failures():void {
			runner.addEventListener(Event.COMPLETE, addAsync(check_Result_wasSuccessful_false, 500));
			runner.run(test, runnerResult);
		}
		
		private function check_Result_wasSuccessful_false(e:Event):void {
			assertFalse(runnerResult.wasSuccessful);
			
			var failures:Array = runnerResult.failures;
			assertEquals('one failure in testResult', 1, failures.length);
			
			var failure0:ITestFailure = failures[0] as TestFailure;
			assertSame(test, failure0.failedTest);
		}
		
	}
}
