package asunit.framework {
	
	/**
	 *
	 */
	public interface ITestResult {
		
		function addFailure(failure:FreeTestFailure):void;
		
		function get errors():Array;
		function get errorCount():uint;
		
		function get failures():Array;
		function get failureCount():uint;
		
		function get wasSuccessful():Boolean;
	}
	
}