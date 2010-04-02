package asunit.fixtures {

    /**
     * Instances of this 'Bridge' will be [Inject]ed into
     * Any IRunner or IOutput that have asked for it.
     *
     * What makes this a Bridge? The fact that it stores no state, 
     * and at least one IRunner [Inject]s it, and zero or more 
     * ITestOutputs can [Inject] it.
     *
     * A Bridge will be instantiated for a given runner and 
     * injected into that runner and all Outputs that listen.
     */
    public class AsUnitBridge implements IRunListener {

        private var listeners:Array;

        public function AsUnitBridge() {
            listeners = new Array();
        }

        // Not in the interface?
        public function addListener(listener:IRunListener):void {
            listeners.push(listener);
        }

		public function onRunStarted():void {
        }

		public function onRunCompleted(result:IResult):void {
        }

		public function onTestStarted(test:Object):void {
        }

		public function onTestCompleted(test:Object):void {
        }

		public function onTestFailure(failure:ITestFailure):void {
        }

		public function onTestSuccess(success:ITestSuccess):void {
        }

		public function onTestIgnored(method:Method):void {
        }

        public function onWarning(warning:ITestWarning):void {
        }
    }
}

