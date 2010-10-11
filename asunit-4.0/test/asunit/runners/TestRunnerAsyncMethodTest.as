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

        [Inject]
        public var runner:TestRunner;

        [Test]
        public function asyncShouldWork():void {
            runner.addEventListener(Event.COMPLETE, async.add(ensureRunnerHasNotYetFailed, 100));
            runner.run(AsyncMethodSuccessTest);
        }

        [Test]
        public function runAsyncCallsAsyncDelegate():void {
            runner.addEventListener(Event.COMPLETE, async.add(ensureRunnerHasNotYetFailed, 10));
            runner.run(AsyncDelegateCalledSynchronouslyTest);
        }
        
        private function ensureRunnerHasNotYetFailed(e:Event):void {
            assertFalse('runner result has not failed', runner.result.failureEncountered);
        }
        
        [Test]
        public function shouldSeeErrorWhenAsyncFailure():void {
            runner.addEventListener(Event.COMPLETE, async.add(checkResultForIllegalOperationError, 200));
            runner.run(AsyncMethodTooSlowTest);
        }
        
        private function checkResultForIllegalOperationError(e:Event):void {
            assertEquals('number of errors', 1, runner.result.errors.length);
            var failure0:TestFailure = runner.result.errors[0] as TestFailure;
            assertEquals('exception type', 'flash.errors::IllegalOperationError', getQualifiedClassName(failure0.thrownException));
            assertEquals('failed method name', 'shouldFailForBeingTooSlow', failure0.failedMethod);
        }
    }
}

import asunit.asserts.*;
import asunit.framework.IAsync;
import flash.utils.setTimeout;

class AsyncMethodSuccessTest {

    [Inject]
    public var async:IAsync;
    
    [Test]
    public function operationDelayedButFastEnoughToSucceed():void {
        var delegate:Function = async.add();
        setTimeout(delegate, 0);
    }
}

class AsyncMethodTooSlowTest {

    [Inject]
    public var async:IAsync;

    [Test]
    public function shouldFailForBeingTooSlow():void {
        // This will force an async timeout in 1 millisecond:
        var delegate:Function = async.add(null, 1);
        // This will still call the async handler in 100ms,
        // but the test run should have already continued:
        setTimeout(delegate, 100);
    }
}

class AsyncDelegateCalledSynchronouslyTest {

    import asunit.asserts.*;

    [Inject]
    public var async:IAsync;

    private var handlerWasCalled:Boolean = false;
    
    [Test]
    public function callingDelegateSynchronouslyShouldStillSucceed():void {
        var delegate:Function = async.add(onComplete);
        delegate();
        assertTrue(handlerWasCalled);
    }
    
    private function onComplete():void {
        handlerWasCalled = true;
    }
}

