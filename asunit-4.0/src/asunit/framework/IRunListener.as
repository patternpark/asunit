package asunit.framework {

	public interface IRunListener extends ITestListener {
		function onRunStarted():void;
		function onRunCompleted(result:IResult):void;
	}
}

