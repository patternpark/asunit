package asunit4.framework {
	import asunit4.framework.ITestSuccess;
	import asunit.framework.ITestFailure;
	import asunit.framework.TestListener;
	
	/**
	 *
	 */
	public interface IFreeTestResult {
		
		function addFailure(failure:ITestFailure):void;
		function addSuccess(success:ITestSuccess):void;
		
		function get errors():Array;
		function get errorCount():uint;
		
		function get failures():Array;
		function get failureCount():uint;
		
		function get successes():Array;
		//function get successCount():uint;
		
		function get runCount():uint;
		function set runCount(value:uint):void;
		
		function get wasSuccessful():Boolean;
		
		function addListener(listener:TestListener):void;
		function removeListener(listener:TestListener):void;
	}
	
}
