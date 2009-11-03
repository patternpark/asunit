package asunit4.framework {
	import asunit.framework.ITestFailure;
	import asunit4.framework.IResult;
	
	public interface IRunListener {
		function onRunStarted():void;
		function onRunCompleted(result:IResult):void;
		function onTestFailure(failure:ITestFailure):void;
		function onTestSuccess(success:ITestSuccess):void;
		function onTestIgnored(method:Method):void;
	}
}
