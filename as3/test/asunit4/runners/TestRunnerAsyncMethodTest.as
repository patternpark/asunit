package asunit4.runners {
	import asunit4.support.FailAssertTrueTest;
	import asunit.framework.TestCase;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import asunit4.events.TestResultEvent;
	import asunit4.framework.IFreeTestResult;
	import asunit4.framework.TestIterator;
	import asunit4.framework.Method;
	import asunit4.framework.FreeTestFailure;

	public class TestRunnerAsyncMethodTest extends TestCase {
		private var runner:TestRunner;
		private var successTest:AsyncMethodSuccessTest;
		private var tooSlowTest:AsyncMethodTooSlowTest;

		public function TestRunnerAsyncMethodTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			runner = new TestRunner();
			successTest = new AsyncMethodSuccessTest();
			tooSlowTest = new AsyncMethodTooSlowTest();
		}

		protected override function tearDown():void {
			runner = null;
		}
		
		//////
		
		public function test_isAsync_is_true_for_async_test_instances():void {
			assertTrue(TestIterator.isAsync(successTest));
			assertTrue(TestIterator.isAsync(tooSlowTest));
		}
		
		public function test_isAsync_is_true_for_async_test_classes():void {
			assertTrue(TestIterator.isAsync(AsyncMethodSuccessTest));
			assertTrue(TestIterator.isAsync(AsyncMethodTooSlowTest));
		}
		
		public function test_isAsync_is_false_for_non_async_test_instance():void {
			assertFalse(TestIterator.isAsync(new FailAssertTrueTest()));
		}
		
		public function test_isAsync_is_false_for_null():void {
			assertFalse(TestIterator.isAsync(null));
		}
		
		//////
		
		public function test_async_test_method_should_have_async_true_and_timeout_value():void {
			var testMethods:Array = TestIterator.getTestMethods(successTest);
			
			assertEquals(1, testMethods.length);
			var method0:Method = Method(testMethods[0]);
			assertTrue(method0.async);
			assertEquals('timeout value', 100, method0.timeout);
		}

		//////
		
		public function test_run_with_successful_async_operation_triggers_successful_TestResultEvent():void {
			runner.addEventListener(TestResultEvent.TEST_COMPLETED, addAsync(check_TestResult_wasSuccessful, 100));
			runner.run(successTest);
		}
		
		private function check_TestResult_wasSuccessful(e:TestResultEvent):void {
			var result:IFreeTestResult = e.testResult;
			assertTrue(result.wasSuccessful);
		}
		
		//////
		
		public function test_run_with_too_slow_async_operation_triggers_result_with_IllegalOperationError():void {
			runner.addEventListener(TestResultEvent.TEST_COMPLETED, addAsync(check_TestResult_has_IllegalOperationError, 100));
			runner.run(tooSlowTest);
		}
		
		private function check_TestResult_has_IllegalOperationError(e:TestResultEvent):void {
			var result:IFreeTestResult = e.testResult;
			assertEquals('number of errors', 1, result.errors.length);
			var failure0:FreeTestFailure = result.errors[0] as FreeTestFailure;
			assertEquals('exception type', 'flash.errors::IllegalOperationError', getQualifiedClassName(failure0.thrownException));
			assertEquals('failed method name', 'operation_too_slow_will_fail', failure0.failedMethod);
		}
	}
}
//////////////////////////////////////////
import flash.utils.setTimeout;
import asunit4.async.addAsync;

class AsyncMethodSuccessTest {
	
	[Test(async,timeout="100")]
	public function operation_delayed_but_fast_enough_will_succeed():void {
		var delegate:Function = asunit4.async.addAsync(this, onComplete);
		setTimeout(delegate, 0);
	}
	
	private function onComplete():void {
	}
	
}

class AsyncMethodTooSlowTest {
	
	[Test(async,timeout="0")]
	public function operation_too_slow_will_fail():void {
		var delegate:Function = asunit4.async.addAsync(this, onComplete);
		setTimeout(delegate, 1);
	}
	
	private function onComplete():void {
	}
	
}
