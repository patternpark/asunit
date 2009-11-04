package asunit4.framework {
	import asunit4.framework.ITestSuccess;
	import asunit.framework.ITestFailure;
	import asunit.framework.TestListener;
	import asunit4.framework.IRunListener;
	
	/**
	 *
	 */
	public interface IResult {
		
		function addListener(listener:IRunListener):void;
		function removeListener(listener:IRunListener):void;
		
		function addFailure(failure:ITestFailure):void;
		function addSuccess(success:ITestSuccess):void;
		function addIgnoredTest(method:Method):void;
		
		function get errors():Array;
		function get errorCount():uint;
		
		function get failures():Array;
		function get failureCount():uint;
		
		function get successes():Array;
		//function get successCount():uint;
		
		function get runCount():uint;
		
		function get wasSuccessful():Boolean;
		
		function startRun():void;
		function endRun():void;
		
		function startTest(test:Object):void;
		function endTest(test:Object):void;
		
		function get runTime():Number;
		function set runTime(value:Number):void;
	}
}
