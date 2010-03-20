package asunit4.runners {

	import asunit.framework.ITestFailure;
	import asunit.framework.TestCase;
	import asunit4.framework.Result;
	import asunit4.framework.TestFailure;
	import asunit4.support.MultiMethod;
    
	import flash.events.Event;

	public class TestRunnerTest extends TestCase {

		private var runner:TestRunner;
		private var runnerResult:Result;
		private var test:Class;

		public function TestRunnerTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
            super.setUp();
			runner = new TestRunner();
			runnerResult = new Result();
			// Yes, statics are ugly, but we're testing that static methods are called, e.g. [BeforeClass].
			MultiMethod.methodsCalled = [];
			test = MultiMethod;
		}

		protected override function tearDown():void {
            super.tearDown();
			runner = null;
			MultiMethod.methodsCalled = null;
		}

		public function testInstantiated():void {
			assertTrue("TestRunner instantiated", runner is TestRunner);
		}
		
		public function test_free_test_does_not_extend_TestCase():void {
			assertFalse(test is TestCase);
		}

		// For now, the test methods are sorted alphabetically to enable precise testing.
		public function test_run_test_instance_executes_proper_method_sequence():void {
			runner.addEventListener(Event.COMPLETE, addAsync(check_methodsCalled_after_running_test_instance, 500));
			runner.run(test, runnerResult);
		}
		
		private function check_methodsCalled_after_running_test_instance(e:Event):void {
			var i:uint = 0;
			
			assertSame(MultiMethod.runBeforeClass1, 		MultiMethod.methodsCalled[i++]);
			assertSame(MultiMethod.runBeforeClass2, 		MultiMethod.methodsCalled[i++]);
			
			assertSame(runner.currentTest.runBefore1, 						MultiMethod.methodsCalled[i++]);
			assertSame(runner.currentTest.runBefore2, 						MultiMethod.methodsCalled[i++]);
			assertSame(runner.currentTest.fail_assertEquals,				MultiMethod.methodsCalled[i++]);
			assertSame(runner.currentTest.runAfter1, 						MultiMethod.methodsCalled[i++]);
			assertSame(runner.currentTest.runAfter2, 						MultiMethod.methodsCalled[i++]);

			assertSame(runner.currentTest.runBefore1, 						MultiMethod.methodsCalled[i++]);
			assertSame(runner.currentTest.runBefore2, 						MultiMethod.methodsCalled[i++]);
			assertSame(runner.currentTest.numChildren_is_0_by_default,		MultiMethod.methodsCalled[i++]);
			assertSame(runner.currentTest.runAfter1, 						MultiMethod.methodsCalled[i++]);
			assertSame(runner.currentTest.runAfter2, 						MultiMethod.methodsCalled[i++]);
			
			assertSame(runner.currentTest.runBefore1, 						MultiMethod.methodsCalled[i++]);
			assertSame(runner.currentTest.runBefore2, 						MultiMethod.methodsCalled[i++]);
			assertSame(runner.currentTest.stage_is_null_by_default, 		MultiMethod.methodsCalled[i++]);
			assertSame(runner.currentTest.runAfter1, 						MultiMethod.methodsCalled[i++]);
			assertSame(runner.currentTest.runAfter2, 						MultiMethod.methodsCalled[i++]);
			
			assertSame(MultiMethod.runAfterClass1, 			MultiMethod.methodsCalled[i++]);
			assertSame(MultiMethod.runAfterClass2, 			MultiMethod.methodsCalled[i++]);
			
			assertEquals('checked all methodsCalled', MultiMethod.methodsCalled.length, i);
		}

		public function test_run_triggers_ResultEvent_with_wasSuccessful_false_and_failures():void {
			runner.addEventListener(Event.COMPLETE, addAsync(check_Result_wasSuccessful_false, 500));
			
			runner.run(test, runnerResult);
		}
		
		private function check_Result_wasSuccessful_false(e:Event):void {
			assertFalse(runnerResult.wasSuccessful);
			
			var failures:Array = runnerResult.failures;
			assertEquals('one failure in testResult', 1, failures.length);
			
			var failure0:ITestFailure = failures[0] as TestFailure;
			assertTrue("failedTest is instance of test class", failure0.failedTest is test);
		}

		public function test_run_test_method_by_name_executes_proper_method_sequence():void {
			var delegate:Function = addAsync(check_methodsCalled_after_running_test_method_by_name, 500);
			runner.addEventListener(Event.COMPLETE, delegate);
			
			var testMethodName:String = 'stage_is_null_by_default';
			runner.runMethodByName(test, runnerResult, testMethodName);
		}
		
		private function check_methodsCalled_after_running_test_method_by_name(e:Event):void {
			var i:uint = 0;
			
			assertSame(MultiMethod.runBeforeClass1, 		MultiMethod.methodsCalled[i++]);
			assertSame(MultiMethod.runBeforeClass2, 		MultiMethod.methodsCalled[i++]);
			
			assertSame(runner.currentTest.runBefore1, 						MultiMethod.methodsCalled[i++]);
			assertSame(runner.currentTest.runBefore2, 						MultiMethod.methodsCalled[i++]);
			assertSame(runner.currentTest.stage_is_null_by_default, 		MultiMethod.methodsCalled[i++]);
			assertSame(runner.currentTest.runAfter1, 						MultiMethod.methodsCalled[i++]);
			assertSame(runner.currentTest.runAfter2, 						MultiMethod.methodsCalled[i++]);
			
			assertSame(MultiMethod.runAfterClass1, 			MultiMethod.methodsCalled[i++]);
			assertSame(MultiMethod.runAfterClass2, 			MultiMethod.methodsCalled[i++]);
			
			assertEquals('checked all methodsCalled', MultiMethod.methodsCalled.length, i);
		}
	}
}

