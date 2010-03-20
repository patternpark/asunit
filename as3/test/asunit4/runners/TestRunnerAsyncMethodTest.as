package asunit4.runners {

    import asunit.framework.TestCase;
    import asunit.util.Iterator;

    import asunit4.framework.Method;
    import asunit4.framework.Result;
    import asunit4.framework.TestFailure;
    import asunit4.framework.TestIterator;

    import flash.events.Event;
    import flash.utils.getQualifiedClassName;

    public class TestRunnerAsyncMethodTest extends TestCase {
        private var runner:TestRunner;
        private var runnerResult:Result;
        private var successTest:Class;
        private var syncTest:Class;
        private var tooSlowTest:Class;

        public function TestRunnerAsyncMethodTest(testMethod:String = null) {
            super(testMethod);
        }

        protected override function setUp():void {
            super.setUp();
            runner       = new TestRunner();
            runnerResult = new Result();
            successTest  = AsyncMethodSuccessTest
            syncTest     = AsyncDelegateCalledSynchronouslyTest
            tooSlowTest  = AsyncMethodTooSlowTest
        }

        protected override function tearDown():void {
            super.tearDown();
            runner       = null;
            runnerResult = null;
            successTest  = null;
            syncTest     = null;
            tooSlowTest  = null;
        }
        
        public function test_async_test_method_should_have_timeout_value():void {
            var instance:* = new successTest();
            var iterator:Iterator = new TestIterator(instance);

            assertEquals(1, iterator.length);
            var method:Method = iterator.next();
            assertEquals('timeout value', 100, method.timeout);
        }

        public function test_run_with_successful_async_operation():void {
            runner.addEventListener(Event.COMPLETE, addAsync(check_runner_result_wasSuccessful, 100));
            runner.run(successTest, runnerResult);
        }
                
        private function check_runner_result_wasSuccessful(e:Event):void {
            assertTrue('runner result was successful', runnerResult.wasSuccessful);
        }
        
        public function test_run_synchronous_call_of_async_delegate():void {
            runner.addEventListener(Event.COMPLETE, addAsync(check_runner_result_wasSuccessful2, 10));
            runner.run(syncTest, runnerResult);
        }
        
        private function check_runner_result_wasSuccessful2(e:Event):void {
            assertTrue('runner result was successful 2', runnerResult.wasSuccessful);
        }
        
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

import asunit.asserts.*;
import asunit4.async.IAsync;
import flash.utils.setTimeout;

class AsyncMethodSuccessTest {

    [Inject]
    public var async:IAsync;
    
    [Test(timeout="100")]
    public function operation_delayed_but_fast_enough_will_succeed():void {
        var delegate:Function = async.add(onComplete);
        setTimeout(delegate, 0);
    }
    
    private function onComplete():void {
    }
}

class AsyncMethodTooSlowTest {
    
    [Inject]
    public var async:IAsync;

    [Test(timeout="0")]
    public function operation_too_slow_will_fail():void {
        var delegate:Function = async.add(onComplete);
        setTimeout(delegate, 1);
    }
    
    private function onComplete():void {
    }
}

class AsyncDelegateCalledSynchronouslyTest {

    import asunit.asserts.*;

    [Inject]
    public var async:IAsync;

    private var handlerWasCalled:Boolean = false;
    
    [Test(timeout="10")]
    public function calling_delegate_synchronously_should_succeed():void {
        var delegate:Function = async.add(onComplete);
        delegate();
        assertTrue(handlerWasCalled);
    }
    
    private function onComplete():void {
        handlerWasCalled = true;
    }
}

