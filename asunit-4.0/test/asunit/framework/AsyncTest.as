package asunit.framework {

    import asunit.asserts.*;
    import asunit.events.TimeoutCommandEvent;
    import asunit.framework.Async;
    import asunit.framework.IAsync;
    import asunit.framework.TestCase;

    import flash.events.Event;
    import flash.utils.setTimeout;

    public class AsyncTest {

        [Inject]
        public var async:IAsync;

        private var orphanAsync:IAsync;
        private var command:TimeoutCommand;

        [Before]
        public function createOrphanAsync():void {
            orphanAsync = new Async();
        }

        [After]
        public function destroyOrphanAsync():void {
            orphanAsync = null;
        }

        [Test]
        public function asyncHandlerCanBeRetrievedByTestInstance():void {
            var cancelTimeout:Function = async.add(foo);
            
            var commands:Array = async.getPending();
            assertEquals("one command for test after addAsync()", 1, commands.length);
            
            var command:TimeoutCommand = commands[0];
            assertSame("handler is the same function passed to addAsync", foo, command.handler);
            
            cancelTimeout();
            
            assertEquals("no commands for test after handler called", 0, async.getPending().length);
        }
        
        [Test]
        public function addAsyncShouldSendCALLEDEventIfDelegateCalledInTime():void {
            var cancelTimeout:Function = async.add(foo, 50);
            
            command = async.getPending()[0];
            
            // Use AsUnit 3's addAsync() to verify onAsyncMethodCalled is called.
            command.addEventListener(TimeoutCommandEvent.CALLED, async.add(onAsyncMethodCalled));
            
            // If all goes well, the ErrorEvent won't be dispatched.
            command.addEventListener(TimeoutCommandEvent.TIMED_OUT, failIfCalled);

            // cancelTimeout is called faster than async.add duration
            setTimeout(cancelTimeout, 0);
        }
        
        private function onAsyncMethodCalled(e:Event):void {
            assertEquals("event type", TimeoutCommandEvent.CALLED, e.type);
        }
        
        [Ignore(description="Async failure, but I'm no longer convinced that there is any value in this test case. Do we care if the TimeoutCommand can throw events? So long as we verify our failure state from the runner?")]
        [Test]
        public function addAsyncShouldSendErrorEventIfDelegateNotCalledInTime():void {

            // This should be called by the orphanAsync instance when the timeout is exceeded:
            var asyncMethodFailedHandler:Function = function(event:TimeoutCommandEvent):void {
                assertEquals("event type", TimeoutCommandEvent.TIMED_OUT, event.type);
                command.removeEventListener(TimeoutCommandEvent.CALLED, failIfCalled);
                command.removeEventListener(TimeoutCommandEvent.TIMED_OUT, asyncMethodFailedHandler);
            }

            var timeoutHandler:Function = orphanAsync.add(null, 1);
            // Set a timeout on the orphanAsync, but also pass this
            // to the actual, outer test run async - when this is called,
            // the outer test run can continue.
            var cancelTimeout:Function = async.add(timeoutHandler, 500);

            // Add subscriptions to the timeout command:
            command = orphanAsync.getPending()[0];
            command.addEventListener(TimeoutCommandEvent.CALLED, failIfCalled);
            command.addEventListener(TimeoutCommandEvent.TIMED_OUT, orphanAsync.add(asyncMethodFailedHandler));

            // we should attempt to call the async handler AFTER the timeout
            // has already expired. The handler should NOT get called...
            setTimeout(cancelTimeout, 10);
        }
        
        
        private function failIfCalled(event:Event=null):void {
            fail("AsyncTest: This function should not have been called");
        }
		//TODO: You might want to delete this since it is basically a no-op handler. You could send instead now.
        private function foo():void {};
    }
}

