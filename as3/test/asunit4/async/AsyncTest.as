package asunit4.async {

	import asunit.framework.TestCase;

    import asunit4.async.Async;
    import asunit4.async.IAsync;
	import asunit4.events.TimeoutCommandEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;

	public class AsyncTest extends TestCase {

        private var async:IAsync;
		private var command:TimeoutCommand;
		private var dispatcher:EventDispatcher;

		public function AsyncTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
            super.setUp();
            async = new Async();
			dispatcher = new EventDispatcher();
		}

		protected override function tearDown():void {
            super.tearDown();
            command    = null;
			dispatcher = null;
		}
        
		public function test_addAsync_handler_can_be_retrieved_by_test_instance():void {
			var cancelTimeout:Function = async.add(foo, 111);
			
			var commands:Array = async.getPending();
			assertEquals("one command for test after addAsync()", 1, commands.length);
			
			var command:TimeoutCommand = commands[0];
			assertSame("handler is the same function passed to addAsync", foo, command.handler);
			
			cancelTimeout();
			
			assertEquals("no commands for test after handler called",
				0, async.getPending().length);
		}
		
		protected function foo():void { }
		
		public function test_addAsync_sends_CALLED_Event_if_delegate_called_in_time():void {
			var cancelTimeout:Function = async.add(foo, 50);
			
			command = async.getPending()[0];
			
			// Use AsUnit 3's addAsync() to verify onAsyncMethodCalled is called.
			command.addEventListener(TimeoutCommandEvent.CALLED, addAsync(onAsyncMethodCalled));
			
			// If all goes well, the ErrorEvent won't be dispatched.
			command.addEventListener(TimeoutCommandEvent.TIMED_OUT, failIfCalled);

			// cancelTimeout is called faster than async.add duration
			setTimeout(cancelTimeout, 0);
		}
		
		protected function onAsyncMethodCalled(e:Event):void {
			assertEquals("event type", TimeoutCommandEvent.CALLED, e.type);
		}
		
		public function test_addAsync_sends_ErrorEvent_if_delegate_not_called_in_time():void {
			// set an extremely short timeout
			var cancelTimeout:Function = async.add(foo, 0);
			
			command = async.getPending()[0];
			command.addEventListener(TimeoutCommandEvent.CALLED, failIfCalled);
			command.addEventListener(TimeoutCommandEvent.TIMED_OUT, addAsync(onAsyncMethodFailed));

			// cancelTimeout isn't called fast enough
			setTimeout(cancelTimeout, 10);
		}
		
		protected function onAsyncMethodFailed(e:TimeoutCommandEvent):void {
			assertEquals("event type", TimeoutCommandEvent.TIMED_OUT, e.type);
			command.removeEventListener(TimeoutCommandEvent.CALLED, failIfCalled);
			command.removeEventListener(TimeoutCommandEvent.TIMED_OUT, onAsyncMethodFailed);
		}
		
		protected function failIfCalled(e:Event = null):void {
			fail("This function should not have been called");
		}
		
	}
}

