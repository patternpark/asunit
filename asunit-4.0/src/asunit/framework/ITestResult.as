package asunit.framework {

	public interface ITestResult {
		
		function addFailure(failure:ITestFailure):void;
		
		function get errors():Array;
		function get errorCount():uint;
		
		function get failures():Array;
		function get failureCount():uint;
		
		function get runCount():uint;
		function set runCount(value:uint):void;
		
		function get wasSuccessful():Boolean;
		
		function addListener(listener:ITestListener):void;
		function removeListener(listener:ITestListener):void;
	}
}
