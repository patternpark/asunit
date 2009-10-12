package asunit4 {
	import asunit.framework.TestCase;
	import flash.events.Event;
	import flash.utils.describeType;
	import asunit4.support.DoubleFailSuite;
	import asunit4.support.FailAssertTrueTest;
	import asunit4.support.FailAssertEqualsTest;

	public class FreeSuiteTest extends TestCase {
		private var runner:FreeRunner;
		private var suite:Object;

		public function FreeSuiteTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			runner = new FreeRunner();
			suite = new DoubleFailSuite();
			//trace(describeType(suite));
			//throw(new Error('sldkjlkjlj'));
		}

		protected override function tearDown():void {
			runner = null;
		}

		public function testInstantiated():void {
			assertTrue("FreeRunner instantiated", runner is FreeRunner);
		}
		
		//////
		
/*
		
		public function test_run_calls_setup_before_and_tearDown_after_each_test_method():void {
			runner.addEventListener(TestResultEvent.NAME, addAsync(check_methodsCalled_after_run, 100));
			runner.run(spriteTest);
		}
		
		private function check_methodsCalled_after_run(e:TestResultEvent):void {
			assertEquals(9, spriteTest.methodsCalled.length);
			
			assertSame(spriteTest.setUp, 								spriteTest.methodsCalled[0]);
			assertSame(spriteTest.test_fail_assertEquals,				spriteTest.methodsCalled[1]);
			assertSame(spriteTest.tearDown, 							spriteTest.methodsCalled[2]);

			assertSame(spriteTest.setUp, 								spriteTest.methodsCalled[3]);
			assertSame(spriteTest.test_numChildren_is_0_by_default,		spriteTest.methodsCalled[4]);
			assertSame(spriteTest.tearDown, 							spriteTest.methodsCalled[5]);
			
			assertSame(spriteTest.setUp,								spriteTest.methodsCalled[6]);
			assertSame(spriteTest.test_stage_is_null_by_default, 		spriteTest.methodsCalled[7]);
			assertSame(spriteTest.tearDown, 							spriteTest.methodsCalled[8]);
		}
		//////
		public function test_run_triggers_TestResultEvent_with_wasSuccessful_false_and_failures():void {
			runner.addEventListener(TestResultEvent.NAME, addAsync(check_TestResult_wasSuccessful_false, 100));
			runner.run(spriteTest);
		}
		
		private function check_TestResult_wasSuccessful_false(e:TestResultEvent):void {
			//trace('failures: ' + e.testResult.failures());
			assertFalse(e.testResult.wasSuccessful);
			
			var failures:Array = e.testResult.failures;
			assertEquals('one failure in testResult', 1, failures.length);
			
			var failure0:ITestFailure = failures[0] as FreeTestFailure;
			assertSame(spriteTest, failure0.failedTest);
		}
*/
	}
}

