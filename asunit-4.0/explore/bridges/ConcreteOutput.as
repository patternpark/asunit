package asunit.fixtures {

    public class ConcreteOutput implements IRunListener {

        [Inject]
        public function set bridge(bridge:AsUnitBridge):void {
            bridge.addListener(this);
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

