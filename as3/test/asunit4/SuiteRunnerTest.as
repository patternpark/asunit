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
		private var suite:Object;

		public function SuiteRunnerTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			suiteRunner = new SuiteRunner();
			suite = new DoubleFailSuite();
			//trace(describeType(suite));
		}

		protected override function tearDown():void {
			suiteRunner = null;
			suite = null;
		}

		//////
		
/*
		public function test_run_calls_setup_before_and_tearDown_after_each_test_method():void {
			suiteRunner.addEventListener(TestResultEvent.TEST_COMPLETED, addAsync(check_methodsCalled_after_run, 100));
			suiteRunner.run(spriteTest);
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
*/
		
		//////
		public function test_run_triggers_TestResultEvent_with_wasSuccessful_false_and_failures():void {
			suiteRunner.addEventListener(TestResultEvent.SUITE_COMPLETED, addAsync(check_TestResult_wasSuccessful_false, 100));
			suiteRunner.run(suite);
		}
		
		private function check_TestResult_wasSuccessful_false(e:TestResultEvent):void {
			assertFalse(e.testResult.wasSuccessful);
			
			var failures:Array = e.testResult.failures;
			assertEquals('failures in testResult', 2, failures.length);
			
			var failure0:ITestFailure = failures[0] as ITestFailure;
			assertSame('failure0 test class', FailAssertTrueTest, failure0.failedTest['constructor']);
			
			var failure1:ITestFailure = failures[1] as ITestFailure;
			assertSame('failure1 test class', FailAssertTrueTest, failure1.failedTest['constructor']);
		}
	}
}
