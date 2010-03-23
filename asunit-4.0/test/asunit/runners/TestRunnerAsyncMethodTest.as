package asunit.runners {

    import asunit.framework.TestCase;
    import asunit.util.Iterator;

    import asunit.framework.Method;
    import asunit.framework.Result;
    import asunit.framework.TestFailure;
    import asunit.framework.TestIterator;

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

        public function testRunAsyncWithoutFailing():void {
            runner.addEventListener(Event.COMPLETE, addAsync(ensureRunnerHasNotYetFailed, 100));
            runner.run(successTest, runnerResult);
        }
                
        public function testRunAsyncCallsAsyncDelegate():void {
            runner.addEventListener(Event.COMPLETE, addAsync(ensureRunnerHasNotYetFailed, 10));
            runner.run(syncTest, runnerResult);
        }
        
        private function ensureRunnerHasNotYetFailed(e:Event):void {
            assertFalse('runner result has not failed', runnerResult.failureEncountered);
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
import asunit.framework.IAsync;
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

