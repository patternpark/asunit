package asunit4.framework {
	//import asunit.framework4.IResult;
	import asunit.framework.ITestFailure;
	
	public interface IRunListener {
		//function onRunStarted():void;
		function onRunCompleted(result:IResult):void;
		//function onTestStarted():void;
		//function onTestFinished():void;
		function onTestFailure(failure:ITestFailure):void;
		function onTestSuccess(success:ITestSuccess):void;
		//function onTestError(failure:ITestFailure):void;
		//function onTestIgnored():void;
	}
}
