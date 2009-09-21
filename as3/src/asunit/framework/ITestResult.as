package asunit.framework {
	
	/**
	 *
	 */
	public interface ITestResult {
		
		function addFailure(failure:ITestFailure):void;
		
		function get errors():Array;
		function get errorCount():uint;
		
		function get failures():Array;
		function get failureCount():uint;
		
		function get runCount():uint;
		
		function get wasSuccessful():Boolean;
		
		function addListener(listener:TestListener):void;
		function removeListener(listener:TestListener):void;
	}
	
}