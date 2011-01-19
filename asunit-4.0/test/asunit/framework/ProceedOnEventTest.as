package asunit.framework {

    import asunit.asserts.*;
    import asunit.events.TimeoutCommandEvent;
    import asunit.framework.ErrorEvent;
    import asunit.framework.TestCase;

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;

    public class ProceedOnEventTest {

        [Inject]
        public var async:IAsync;
        public var dispatcher:EventDispatcher;

        private var orphanAsync:IAsync;
        private var command:TimeoutCommand;
        private var timeoutID:int = -1;

        [Before]
        public function setUp():void {
            orphanAsync = new Async();
			dispatcher = new EventDispatcher();
        }

        [After]
        public function tearDown():void {
            command     = null;
            orphanAsync = null;
            timeoutID   = -1;
        }

        protected function foo():void { }
        
        [Test]
        public function proceedOnEventShouldDispatchCorrectEventAndClearPendingCommands():void {
            orphanAsync.proceedOnEvent(dispatcher, Event.COMPLETE, 10);
            
            var commands:Array = orphanAsync.getPending();
            assertEquals("one pending command for test after proceedOnEvent()", 1, commands.length);
            
            // send the correct event synchronously
            dispatchCompleteEvent();
            
            var message:String = "No pending commands for test after correct Event dispatched.";
            assertEquals(message, 0, orphanAsync.getPending().length);
        }
        
        protected function dispatchCompleteEvent():void {
            dispatcher.dispatchEvent(new Event(Event.COMPLETE));
        }
        
        [Test]
        public function proceedOnEventShouldTimeoutAppropriately():void {

            // Grab a reference to the Dispatcher so that we still have
            // it after the test run (Fixing uncaught RTE null pointer exception)
            var source:IEventDispatcher = dispatcher;

            // This is the initial setup, we want test execution to pause
            // for 1ms OR until the COMPLETE event fires:
            orphanAsync.proceedOnEvent(source, Event.COMPLETE, 1);
            
            // Get the Command so that we can just wait for the TIMED_OUT event:
            var commands:Array = orphanAsync.getPending();
            var command:TimeoutCommand = commands[0];
            command.addEventListener(TimeoutCommandEvent.TIMED_OUT, async.add(onAsyncMethodFailed, 500));
            
            // send the correct event too slowly
            timeoutID = setTimeout(function():void {
                source.dispatchEvent(new Event(Event.COMPLETE));
            }, 10);
        }
        
        protected function onAsyncMethodFailed(event:TimeoutCommandEvent):void {
            assertEquals("event type", TimeoutCommandEvent.TIMED_OUT, event.type);
            clearTimeout(timeoutID);
        }
        
        [Test]
        public function proceedOnEventShouldSendCALLEDEventAsExpected():void {
            orphanAsync.proceedOnEvent(dispatcher, Event.COMPLETE, 10);
            
            command = orphanAsync.getPending()[0];
            
            // Use AsUnit 3's orphanAsync.add() to verify onAsyncMethodCalled is called.
            command.addEventListener(TimeoutCommandEvent.CALLED, async.add(onAsyncMethodCalled));
            
            // If all goes well, the ErrorEvent won't be dispatched.
            command.addEventListener(ErrorEvent.ERROR, failIfCalled);
            
            // send the correct event faster than orphanAsync.proceedOnEvent duration
            setTimeout(dispatchCompleteEvent, 0);
        }
        
        protected function onAsyncMethodCalled(e:Event):void {
            assertEquals("event type", TimeoutCommandEvent.CALLED, e.type);
        }
        
        protected function failIfCalled(e:Event = null):void {
            fail("ProceedOnEventTest: This function should not have been called");
        }
    }
}
