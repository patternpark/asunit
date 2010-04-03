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

        [Inject]
        public var runnerResult:Result;
        
        [Test]
        public function asyncShouldWork():void {
            runner.addEventListener(Event.COMPLETE, async.add(ensureRunnerHasNotYetFailed, 100));
            runner.run(AsyncMethodSuccessTest, runnerResult);
        }

        [Test]
        public function runAsyncCallsAsyncDelegate():void {
            runner.addEventListener(Event.COMPLETE, async.add(ensureRunnerHasNotYetFailed, 10));
            runner.run(AsyncDelegateCalledSynchronouslyTest, runnerResult);
        }
        
        private function ensureRunnerHasNotYetFailed(e:Event):void {
            assertFalse('runner result has not failed', runnerResult.failureEncountered);
        }
        
        [Test]
        public function shouldSeeErrorWhenAsyncFailure():void {
            runner.addEventListener(Event.COMPLETE, async.add(checkResultForIllegalOperationError, 200));
            runner.run(AsyncMethodTooSlowTest, runnerResult);
        }
        
        private function checkResultForIllegalOperationError(e:Event):void {
            assertEquals('number of errors', 1, runnerResult.errors.length);
            var failure0:TestFailure = runnerResult.errors[0] as TestFailure;
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
        var delegate:Function = async.add(null, 1);
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

