package asunit.framework {

	import asunit.framework.ErrorEvent;

	import asunit.events.TimeoutCommandEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class Async extends EventDispatcher implements IAsync {
		
		public static var DEFAULT_TIMEOUT:uint = 50;
		
        private var _timeout:int = DEFAULT_TIMEOUT;
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
         *  [Inject]
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

        public function set timeout(timeout:int):void {
            _timeout = timeout;
        }

        public function get timeout():int {
            return _timeout;
        }
		
        /**
         * Returns a new async handler that should be used as the observer of some
         * presumably asynchronous event.
         *
         * You can optionally pass a function closure that you would like to have
         * executed when the provided handler is called. If this closure includes
         * assertions, they will display in the test result.
         *
         * You can also override the default timeout (50ms) with a new value for
         * this particular handler.
         *
         * This method may be called any number of times in a given [Test], [BeforeClass],
         * or [Before] method.
         *
         * Test execution will be paused until all async handlers have returned
         * or timed out.
         *
         * One way to use this method, is to simply send it to an event that you
         * expect to have dispatched within a given time.
         * 
         *     instance.addEventListener(Event.COMPLETE, addAsync());
         *
         * In this example, you will receive a timeout error if the COMPLETE
         * event is not dispatched within 50ms.
         *
         */
		public function add(handler:Function=null, duration:int=-1):Function {
			if (duration == -1) duration = timeout;
            handler ||= function(...args):* {};
			var command:TimeoutCommand = new TimeoutCommand(null, handler, duration);
			addPending(command);
			return command.getCallback();
		}
		
		public function proceedOnEvent(target:IEventDispatcher, eventName:String, timeout:int=500, timeoutHandler:Function=null):void {
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
            dispatchEvent(new TimeoutCommandEvent(TimeoutCommandEvent.ADDED, command));
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

