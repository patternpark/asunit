package asunit.support {

    import asunit.framework.IResult;
    import asunit.framework.IRunListener;
    import asunit.framework.ITestFailure;
    import asunit.framework.ITestSuccess;
    import asunit.framework.ITestWarning;
    import asunit.framework.Method;

    public class FakeObserver implements IRunListener {

        public var onRunStartedCalled:Boolean;
        public var onTestStartedCalled:Boolean;

		public function onRunStarted():void {
            onRunStartedCalled = true;
        }

		public function onRunCompleted(result:IResult):void {
        }

		public function onTestStarted(test:Object):void {
            onTestStartedCalled = true;
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

