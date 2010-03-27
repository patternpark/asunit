package asunit.runners {

    import asunit.asserts.*;
    import asunit.framework.TestCase;
    import asunit.util.Iterator;

    import asunit.framework.IAsync;
    import asunit.framework.Method;
    import asunit.framework.Result;
    import asunit.framework.TestFailure;
    import asunit.framework.TestIterator;

    import flash.events.Event;
    import flash.utils.getQualifiedClassName;

    public class TestRunnerAsyncMethodTest {

        [Inject]
        public var async:IAsync;

        private var runner:TestRunner;
        private var runnerResult:Result;
        private var successTest:Class;
        private var syncTest:Class;
        private var tooSlowTest:Class;

        [Before]
        public function setUp():void {
            runner       = new TestRunner();
            runnerResult = new Result();
            successTest  = AsyncMethodSuccessTest
            syncTest     = AsyncDelegateCalledSynchronouslyTest
            tooSlowTest  = AsyncMethodTooSlowTest
        }

        [After]
        public function tearDown():void {
            runner       = null;
            runnerResult = null;
            successTest  = null;
            syncTest     = null;
            tooSlowTest  = null;
        }
        
        [Test]
        public function asyncMethodShouldHaveTimeout():void {
            var instance:* = new successTest();
            var iterator:Iterator = new TestIterator(instance);

            assertEquals(1, iterator.length);
            var method:Method = iterator.next();
            assertEquals('timeout value', 100, method.timeout);
        }

        [Test]
        public function asyncShouldWork():void {
            runner.addEventListener(Event.COMPLETE, async.add(ensureRunnerHasNotYetFailed, 100));
            runner.run(successTest, runnerResult);
        }

        [Test]
        public function runAsyncCallsAsyncDelegate():void {
            runner.addEventListener(Event.COMPLETE, async.add(ensureRunnerHasNotYetFailed, 10));
            runner.run(syncTest, runnerResult);
        }
        
        private function ensureRunnerHasNotYetFailed(e:Event):void {
            assertFalse('runner result has not failed', runnerResult.failureEncountered);
        }
        
        [Test]
        public function shouldSeeErrorWhenAsyncFailure():void {
            runner.addEventListener(Event.COMPLETE, async.add(checkResultForIllegalOperationError, 100));
            runner.run(tooSlowTest, runnerResult);
        }
        
        private function checkResultForIllegalOperationError(e:Event):void {
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

