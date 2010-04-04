package asunit.framework {

    import asunit.asserts.*;
    import asunit.events.TimeoutCommandEvent;
    import asunit.framework.Async;
    import asunit.framework.IAsync;
    import asunit.framework.TestCase;

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.setTimeout;

    public class AsyncTest {

        [Inject]
        public var async:IAsync;

        [Inject]
        public var dispatcher:EventDispatcher;

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
        
        [Ignore(description="Having trouble getting this test to make sense...")]
        [Test]
        public function addAsyncShouldSendErrorEventIfDelegateNotCalledInTime():void {
            // set an extremely short timeout
            var cancelTimeout:Function = orphanAsync.add(foo, 1);
            
            command = orphanAsync.getPending()[0];
            command.addEventListener(TimeoutCommandEvent.CALLED, failIfCalled);
            command.addEventListener(TimeoutCommandEvent.TIMED_OUT, orphanAsync.add(onAsyncMethodFailed));

            // cancelTimeout isn't called fast enough
            setTimeout(cancelTimeout, 100);
        }
        
        private function onAsyncMethodFailed(e:TimeoutCommandEvent):void {
            assertEquals("event type", TimeoutCommandEvent.TIMED_OUT, e.type);
            command.removeEventListener(TimeoutCommandEvent.CALLED, failIfCalled);
            command.removeEventListener(TimeoutCommandEvent.TIMED_OUT, onAsyncMethodFailed);
        }
        
        private function failIfCalled(event:Event=null):void {
            fail("This function should not have been called");
        }

        private function foo():void {};
    }
}

