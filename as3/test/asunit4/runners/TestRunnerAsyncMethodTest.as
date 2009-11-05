package asunit4.runners {
	import asunit4.framework.IRunListener;
	import asunit4.framework.Result;
	import asunit4.support.FailAssertTrueTest;
	import asunit.framework.TestCase;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import asunit4.framework.IResult;
	import asunit4.framework.TestIterator;
	import asunit4.framework.Method;
	import asunit4.framework.TestFailure;

	public class TestRunnerAsyncMethodTest extends TestCase {
		private var runner:TestRunner;
		private var runnerResult:Result;
		private var successTest:AsyncMethodSuccessTest;
		private var tooSlowTest:AsyncMethodTooSlowTest;
		private var syncTest:AsyncDelegateCalledSynchronouslyTest;

		public function TestRunnerAsyncMethodTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			runner = new TestRunner();
			runnerResult = new Result();
			successTest = new AsyncMethodSuccessTest();
			syncTest = new AsyncDelegateCalledSynchronouslyTest();
			tooSlowTest = new AsyncMethodTooSlowTest();
		}

		protected override function tearDown():void {
			runner = null;
			runnerResult = null;
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
		
		public function test_run_with_successful_async_operation():void {
			runner.addEventListener(Event.COMPLETE, addAsync(check_runner_result_wasSuccessful, 100));
			runner.run(successTest, runnerResult);
		}
				
		private function check_runner_result_wasSuccessful(e:Event):void {
			assertTrue('runner result was successful', runnerResult.wasSuccessful);
		}
		
		//////
		
		public function test_run_synchronous_call_of_async_delegate():void {
			runner.addEventListener(Event.COMPLETE, addAsync(check_runner_result_wasSuccessful2, 100));
			runner.run(syncTest, runnerResult);
		}
		
		private function check_runner_result_wasSuccessful2(e:Event):void {
			trace('->->->->->-> ' + runnerResult.failures);
			assertTrue('runner result was successful222', runnerResult.wasSuccessful);
		}
		
		//////
		
		public function test_run_with_too_slow_async_operation_triggers_result_with_IllegalOperationError():void {
			runner.addEventListener(Event.COMPLETE, addAsync(check_Result_has_IllegalOperationError, 100));
			runner.run(tooSlowTest, runnerResult);
		}
		
		private function check_Result_has_IllegalOperationError(e:Event):void {
			assertEquals('number of errors', 1, runnerResult.errors.length);
			var failure0:TestFailure = runnerResult.errors[0] as TestFailure;
			assertEquals('exception type', 'flash.errors::IllegalOperationError', getQualifiedClassName(failure0.thrownException));
			assertEquals('failed method name', 'operation_too_slow_will_fail', failure0.failedMethod);
		}
	}
}
//////////////////////////////////////////
import asunit.framework.ITestFailure;
import asunit4.framework.IResult;
import asunit4.framework.IRunListener;
import asunit4.framework.ITestSuccess;
import flash.utils.setTimeout;
import asunit4.async.addAsync;
import asunit.asserts.*;

class AsyncMethodSuccessTest {
	
	[Test(async,timeout="100")]
	public function operation_delayed_but_fast_enough_will_succeed():void {
		var delegate:Function = asunit4.async.addAsync(onComplete);
		setTimeout(delegate, 0);
	}
	
	private function onComplete():void {
	}
	
}

class AsyncMethodTooSlowTest {
	
	[Test(async,timeout="0")]
	public function operation_too_slow_will_fail():void {
		var delegate:Function = asunit4.async.addAsync(onComplete);
		setTimeout(delegate, 1);
	}
	
	private function onComplete():void {
	}
	
}

class AsyncDelegateCalledSynchronouslyTest {
	
	private var handlerWasCalled:Boolean = false;
	
	[Test(async,timeout="10")]
	public function calling_delegate_synchronously_should_succeed():void {
		var delegate:Function = asunit4.async.addAsync(onComplete);
		delegate();
		assertTrue(handlerWasCalled);
	}
	
	private function onComplete():void {
		handlerWasCalled = true;
	}
	
}

/*
class DelegateListener implements IRunListener {
	public var _onTestFailure:Function;
	public var _onTestSuccess:Function;
	public var _onRunCompleted:Function;
	
	public function onTestFailure(failure:ITestFailure):void {
		if (_onTestFailure != null) _onTestFailure(failure);
	}
	
	public function onTestSuccess(success:ITestSuccess):void {
		if (_onTestSuccess != null) _onTestSuccess(success);
	}
	
	public function onRunCompleted(result:IResult):void {
		if (_onRunCompleted != null) _onRunCompleted(result);
	}
}
*/
