package asunit4.framework {
	import asunit.framework.ITestFailure;
	import asunit4.framework.IResult;
	
	public interface IRunListener extends ITestListener {
		function onRunStarted():void;
		function onRunCompleted(result:IResult):void;
	}
}
