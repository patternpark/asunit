package asunit4.async {
	import asunit.framework.TestCase;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import asunit.framework.ErrorEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import asunit4.events.TimeoutCommandEvent;

	public class ProceedOnEventTest extends TestCase {
		private var dispatcher:EventDispatcher;
		private var command:TimeoutCommand;
		private var timeoutID:int = -1;

		public function ProceedOnEventTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			dispatcher = new EventDispatcher();
		}

		protected override function tearDown():void {
			dispatcher = null;
			command = null;
			timeoutID = -1;
		}

		//////
		
		protected function foo():void { }
		
		public function test_proceedOnEvent_then_dispatch_correct_event_clears_pending_commands_for_test():void {
			Async.proceedOnEvent(this, dispatcher, Event.COMPLETE, 10);
			
			var commands:Array = Async.instance.getPending();
			assertEquals("one pending command for test after proceedOnEvent()", 1, commands.length);
			
			// send the correct event synchronously
			dispatchCompleteEvent();
			
			assertEquals("no pending commands for test after correct Event dispatched",
				0, Async.instance.getPending().length);
		}
		
		protected function dispatchCompleteEvent():void {
			dispatcher.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function test_proceedOnEvent_then_dispatch_correct_event_too_slowly_sends_timed_out_Event():void {
			Async.proceedOnEvent(this, dispatcher, Event.COMPLETE, 0);
			
			var commands:Array = Async.instance.getPending();
			var command:TimeoutCommand = commands[0];
			//command.addEventListener(ErrorEvent.ERROR, addAsync(onAsyncMethodFailed));
			command.addEventListener(TimeoutCommandEvent.TIMED_OUT, addAsync(onAsyncMethodFailed));
			
			// send the correct event too slowly
			timeoutID = setTimeout(dispatchCompleteEvent, 10);
		}
		
		protected function onAsyncMethodFailed(e:TimeoutCommandEvent):void {
			assertEquals("event type", TimeoutCommandEvent.TIMED_OUT, e.type);
			clearTimeout(timeoutID);
		}
		
		public function test_proceedOnEvent_then_dispatch_correct_event_in_time_sends_CALLED_Event():void {
			Async.proceedOnEvent(this, dispatcher, Event.COMPLETE, 10);
			
			command = Async.instance.getPending()[0];
			
			// Use AsUnit 3's addAsync() to verify onAsyncMethodCalled is called.
			command.addEventListener(TimeoutCommandEvent.CALLED, addAsync(onAsyncMethodCalled));
			
			// If all goes well, the ErrorEvent won't be dispatched.
			command.addEventListener(ErrorEvent.ERROR, failIfCalled);
			
			// send the correct event faster than Async.proceedOnEvent duration
			setTimeout(dispatchCompleteEvent, 0);
		}
		
		protected function onAsyncMethodCalled(e:Event):void {
			assertEquals("event type", TimeoutCommandEvent.CALLED, e.type);
		}
		
		protected function failIfCalled(e:Event = null):void {
			fail("This function should not have been called");
		}
		
	}
}
