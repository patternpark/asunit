package asunit4.runners {
	import asunit.errors.AssertionFailedError;
	import asunit.framework.TestCase;
	import flash.events.Event;
	import asunit4.events.TestResultEvent;
	import asunit4.framework.IFreeTestResult;
	import asunit4.framework.FreeTestFailure;

	public class TestRunnerExpectsErrorTest extends TestCase {
		private var runner:TestRunner;
		private var successTest:TestExpectsArgumentErrorAndThrowsIt;
		private var throwNothingTest:TestExpectsArgumentErrorButThrowsNothing;
		private var throwWrongErrorTest:TestExpectsArgumentErrorButThrowsWrongError;

		public function TestRunnerExpectsErrorTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			runner = new TestRunner();
			successTest = new TestExpectsArgumentErrorAndThrowsIt();
			throwNothingTest = new TestExpectsArgumentErrorButThrowsNothing();
			throwWrongErrorTest = new TestExpectsArgumentErrorButThrowsWrongError();
		}

		protected override function tearDown():void {
			runner = null;
			successTest = null;
			throwNothingTest = null;
			throwWrongErrorTest = null;
		}

		//////
		
		public function test_method_expects_specific_error_and_throws_it_yields_successful_test_result():void {
			runner.addEventListener(TestResultEvent.TEST_COMPLETED, addAsync(check_TestResult_has_no_errors, 100));
			runner.run(successTest);
		}
		
		private function check_TestResult_has_no_errors(e:TestResultEvent):void {
			var result:IFreeTestResult = e.testResult;
			assertEquals('no errors in testResult',   0, result.errorCount);
			assertEquals('no failures in testResult', 0, result.failureCount);
		}
		
		//////
		
		public function test_method_expects_specific_error_but_nothing_thrown_yields_assertion_failure():void {
			runner.addEventListener(TestResultEvent.TEST_COMPLETED, addAsync(check_TestResult_has_one_assertion_failure, 100));
			runner.run(throwNothingTest);
		}
		
		private function check_TestResult_has_one_assertion_failure(e:TestResultEvent):void {
			var result:IFreeTestResult = e.testResult;
			assertFalse(result.wasSuccessful);
			
			assertEquals('one failure in testResult', 1, result.failureCount);
			assertEquals('no errors in testResult',   0, result.errorCount);
			
			var failure0:FreeTestFailure = result.failures[0] as FreeTestFailure;
			assertTrue('thrownException is correct type', failure0.thrownException is AssertionFailedError);
			assertSame('failedTest reference', throwNothingTest, failure0.failedTest);
			assertSame('failedMethod name', 'fail_by_throwing_nothing', failure0.failedMethod);
		}
		
		//////
		
		public function test_method_expects_specific_error_but_wrong_one_thrown_yields_assertion_failure():void {
			runner.addEventListener(TestResultEvent.TEST_COMPLETED, addAsync(check_TestResult_has_one_assertion_failure, 100));
			runner.run(throwNothingTest);
		}
		
	}
}

class TestExpectsArgumentErrorAndThrowsIt {
	
	[Test(expects="ArgumentError")]
	public function throwArgumentError():void {
		throw new ArgumentError('generated by TestExpectsArgumentError');
	}
}

class TestExpectsArgumentErrorButThrowsNothing {
	
	[Test(expects="ArgumentError")]
	public function fail_by_throwing_nothing():void {
		
	}
}

class TestExpectsArgumentErrorButThrowsWrongError {
	
	[Test(expects="ArgumentError")]
	public function fail_by_throwing_wrong_error():void {
		throw new Error('generated by TestExpectsArgumentErrorButThrowsWrongError');
	}
}
