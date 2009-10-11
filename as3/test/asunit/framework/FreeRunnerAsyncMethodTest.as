package asunit.framework {
	import asunit.framework.support.FailAssertTrueTest;
	import asunit.framework.TestCase;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.describeType;

	public class FreeRunnerAsyncMethodTest extends TestCase {
		private var runner:FreeRunner;
		private var successTest:AsyncMethodSuccessTest;
		private var tooSlowTest:AsyncMethodTooSlowTest;

		public function FreeRunnerAsyncMethodTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			runner = new FreeRunner();
			successTest = new AsyncMethodSuccessTest();
			tooSlowTest = new AsyncMethodTooSlowTest();
		}

		protected override function tearDown():void {
			runner = null;
		}
		
		//////
		
		public function test_isAsync_is_true_for_async_tests():void {
			assertTrue(TestMethodIterator.isAsync(successTest));
			assertTrue(TestMethodIterator.isAsync(tooSlowTest));
		}
		
		public function test_isAsync_is_false_for_non_async_test_instance():void {
			assertFalse(TestMethodIterator.isAsync(new FailAssertTrueTest()));
		}
		
		public function test_isAsync_is_false_for_null():void {
			assertFalse(TestMethodIterator.isAsync(null));
		}
		
		//////
		
		public function test_async_test_method_should_have_async_true_and_timeout_value():void {
			var testMethods:Array = TestMethodIterator.getTestMethods(successTest);
			
			assertEquals(1, testMethods.length);
			var method0:Method = Method(testMethods[0]);
			assertTrue(method0.async);
			assertEquals('timeout value', 100, method0.timeout);
		}

		//////
		
		public function test_run_with_successful_async_operation_triggers_successful_TestResultEvent():void {
			runner.addEventListener(TestResultEvent.NAME, addAsync(check_TestResult_wasSuccessful, 100));
			runner.run(successTest);
		}
		
		private function check_TestResult_wasSuccessful(e:TestResultEvent):void {
			var result:FreeTestResult = e.testResult;
			assertTrue(result.wasSuccessful);
		}
		
		//////
		
		public function test_run_with_too_slow_async_operation_triggers_result_with_IllegalOperationError():void {
			runner.addEventListener(TestResultEvent.NAME, addAsync(check_TestResult_has_IllegalOperationError, 100));
			runner.run(tooSlowTest);
		}
		
		private function check_TestResult_has_IllegalOperationError(e:TestResultEvent):void {
			var result:FreeTestResult = e.testResult;
			assertEquals('number of errors', 1, result.errors.length);
			var failure0:FreeTestFailure = result.errors[0] as FreeTestFailure;
			assertTrue('exception is IllegalOperationError', failure0.thrownException is IllegalOperationError);
			assertEquals('failed method name', 'operation_too_slow_will_fail', failure0.failedMethod);
		}
	}
}
//////////////////////////////////////////
import flash.utils.setTimeout;
import asunit.framework.async.addAsync;

class AsyncMethodSuccessTest {
	
	[Test(async,timeout="100")]
	public function operation_delayed_but_fast_enough_will_succeed():void {
		var delegate:Function = asunit.framework.async.addAsync(this, onComplete, 100);
		setTimeout(delegate, 10);
	}
	
	private function onComplete():void {
	}
	
}

class AsyncMethodTooSlowTest {
	
	[Test(async,timeout="5")]
	public function operation_too_slow_will_fail():void {
		var delegate:Function = asunit.framework.async.addAsync(this, onComplete, 5);
		setTimeout(delegate, 50);
	}
	
	private function onComplete():void {
	}
	
}
