package asunit4.async {

	import asunit.framework.ErrorEvent;

	import asunit4.events.TimeoutCommandEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class Async extends EventDispatcher implements IAsync {
		
		public static var DEFAULT_TIMEOUT:uint = 50;
		
		protected var pending:Array;
		
        /**
         * Asynchronous handler class.
         *
         * This class give you the ability to create Asynchronous event handlers
         * and pause test execution until those handlers are triggered.
         *
         * To take advantage of Asynchronous features, add a member variable
         * to your test like:
         * 
         *  [Async]
         *  public var async:IAsync;
         *
         * This public property will be injected with an IAsync instance 
         * before each test method. 
         * 
         * Within your test methods, you can add Async callbacks with:
         *
         *  [Test]
         *  public function verifySomething():void {
         *      async.add(handler);
         *  }
         * 
         * In the previous example, test execution will be halted until the
         * +handler+ method is called.
         *
         * It's worth noting that AsUnit does not store any state related
         * to the playback of your test harness in global variables.
         *
         */
		public function Async() {
			pending = [];
		}
		
		public function get hasPending():Boolean {
			return pending.length > 0;
		}
		
		public function add(handler:Function, duration:int = -1):Function {
			if (duration == -1) duration = DEFAULT_TIMEOUT;
			var command:TimeoutCommand = new TimeoutCommand(null, handler, duration);
			addPending(command);
			return command.getCallback();
		}
		
		public function proceedOnEvent(test:Object, target:IEventDispatcher, eventName:String, timeout:int = 500, timeoutHandler:Function = null):void {
            var asyncHandler:Function = add(null, timeout);
			target.addEventListener(eventName, asyncHandler, false, 0, true);
		}
		
		public function cancelPending():void {
			for (var i:uint = pending.length; i--; ) {
				var command:TimeoutCommand = TimeoutCommand(pending.pop());
				command.cancel();
				command.removeEventListener(TimeoutCommandEvent.CALLED,	onTestResult);
				command.removeEventListener(TimeoutCommandEvent.TIMED_OUT,	onTestResult);
			}
		}
		
		// Partially opened for testing purposes.
		public function getPending():Array {
			// Clone to prevent changing by reference.
			return pending.slice();
		}
		
		protected function addPending(command:TimeoutCommand):void {
			pending.push(command);
			command.addEventListener(TimeoutCommandEvent.CALLED,	onTestResult);
			command.addEventListener(TimeoutCommandEvent.TIMED_OUT,	onTestResult);
			command.addEventListener(ErrorEvent.ERROR, 				onTestResult);
		}
		
		protected function onTestResult(e:Event):void {
			var command:TimeoutCommand = TimeoutCommand(e.currentTarget);
			command.removeEventListener(TimeoutCommandEvent.CALLED,		onTestResult);
			command.removeEventListener(TimeoutCommandEvent.TIMED_OUT,	onTestResult);
			removePending(command);
			dispatchEvent(e);
		}
		
		protected function removePending(command:TimeoutCommand):void {
			pending.splice(pending.indexOf(command), 1);
		}
	}
}

