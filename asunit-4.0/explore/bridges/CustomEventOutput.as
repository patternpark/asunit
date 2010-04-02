package asunit.fixtures {

    public class CustomEventOutput {

        [Inject]
        public function set customBridge(bridge:CustomEventBridge):void {
            bridge.addEventListener(CustomEventBridge.CUSTOM_METHOD_STARTED, startedHandler);
            bridge.addEventListener(CustomEventBridge.CUSTOM_METHOD_COMPLETED, completedHandler);
        }

        // This concrete could implement IRunListener,
        // and add itself to the AsUnitBridge, but it doesn't...
        // It's only interested in it's new, custom events.
        //[Inject]
        //public function set bridge(bridge:AsUnitBridge):void {
        // bridge.addListener(this);
        //}

        private function startedHandler(event:Event):void {
        }

        private function completedHandler(event:Event):void {
        }
    }
}

