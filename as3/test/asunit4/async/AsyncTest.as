package asunit4.async {
	import asunit.framework.TestCase;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import asunit.framework.ErrorEvent;
	import flash.utils.setTimeout;

	public class AsyncTest extends TestCase {
		private var dispatcher:EventDispatcher;
		private var command:TimeoutCommand;

		public function AsyncTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			dispatcher = new EventDispatcher();
		}

		protected override function tearDown():void {
			dispatcher = null;
			command = null;
		}

		//////
		
		public function test_addAsync_handler_can_be_retrieved_by_test_instance():void {
			var cancelTimeout:Function = asunit4.async.addAsync(this, foo, 111);
			
			var commands:Array = Async.instance.getPending();
			assertEquals("one command for test after addAsync()", 1, commands.length);
			
			var command:TimeoutCommand = commands[0];
			assertSame("handler is the same function passed to addAsync", foo, command.handler);
			
			cancelTimeout();
			
			assertEquals("no commands for test after handler called",
				0, Async.instance.getPending().length);
		}
		
		protected function foo():void { }
		
		public function test_addAsync_sends_CALLED_Event_if_delegate_called_in_time():void {
			var cancelTimeout:Function = asunit4.async.addAsync(this, foo, 10);
			
			command = Async.instance.getPending()[0];
			
			// Use AsUnit 3's addAsync() to verify onAsyncMethodCalled is called.
			command.addEventListener(TimeoutCommand.CALLED, addAsync(onAsyncMethodCalled));
			
			// If all goes well, the ErrorEvent won't be dispatched.
			command.addEventListener(ErrorEvent.ERROR, failIfCalled);

			// cancelTimeout is called faster than asunit4.async.addAsync duration
			setTimeout(cancelTimeout, 0);
		}
		
		protected function onAsyncMethodCalled(e:Event):void {
			assertEquals("event type", TimeoutCommand.CALLED, e.type);
		}
		
		public function test_addAsync_sends_ErrorEvent_if_delegate_not_called_in_time():void {
			// set an extremely short timeout
			var cancelTimeout:Function = asunit4.async.addAsync(this, foo, 0);
			
			command = Async.instance.getPending()[0];
			command.addEventListener(TimeoutCommand.CALLED, failIfCalled);
			command.addEventListener(ErrorEvent.ERROR, addAsync(onAsyncMethodFailed));

			// cancelTimeout isn't called fast enough
			setTimeout(cancelTimeout, 10);
		}
		
		protected function onAsyncMethodFailed(e:ErrorEvent):void {
			assertEquals("event type", ErrorEvent.ERROR, e.type);
			command.removeEventListener(TimeoutCommand.CALLED, failIfCalled);
			command.removeEventListener(ErrorEvent.ERROR, onAsyncMethodFailed);
		}
		
		protected function failIfCalled(e:Event = null):void {
			fail("This function should not have been called");
		}
		
	}
}
