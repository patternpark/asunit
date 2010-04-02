package asunit.fixtures {

    public class CustomEventRunner implements IRunner {
        
        [Inject]
        public var customBridge:CustomEventBridge;

        // This custom runner will also interact with the
        // AsUnitBridge instance and thereby broadcast messages to
        // Output handlers that are listening to the default Bridge.
        [Inject]
        public var bridge:AsUnitBridge;

        private var test:Class;

		public function run(test:Class, result:IResult, testMethod:String=null, visualContext:DisplayObjectContainer=null):void {
            this.test = test;
            // Dispatch a custom message type over the custom bridge:
            customBridge.dispatchEvent(new Event(CustomEventBridge.CUSTOM_METHOD_STARTED));
            // Dispatch a callback on the standard bridge:
            bridge.onTestStarted(test);
            bridge.onTestSuccess(null);
            bridge.onTestCompleted(test);
            // Dispatch another custom message over the custom bridge:
            customBridge.dispatchEvent(new Event(CustomEventBridge.CUSTOM_METHOD_COMPLETED));
        }
    }
}

