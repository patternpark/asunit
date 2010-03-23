package asunit.framework {

	import asunit.framework.ITestFailure;
	import asunit.framework.IResult;
	
	public interface IRunListener extends ITestListener {
		function onRunStarted():void;
		function onRunCompleted(result:IResult):void;
	}
}

