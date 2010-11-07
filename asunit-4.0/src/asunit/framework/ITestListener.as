package asunit.framework {

	import asunit.framework.ITestFailure;
	
	public interface ITestListener {
		function onTestStarted(test:Object):void;
		function onTestCompleted(test:Object):void;
		function onTestFailure(failure:ITestFailure):void;
		function onTestSuccess(success:ITestSuccess):void;
		function onTestIgnored(method:Method):void;
        function onWarning(warning:ITestWarning):void;
	}
}

