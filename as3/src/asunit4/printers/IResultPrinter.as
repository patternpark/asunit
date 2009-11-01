package asunit4.printers {
	
	import asunit4.framework.ITestResult;
	
	public interface IResultPrinter {
		
		function startTestRun():void;
		
		function addTestResult(result:ITestResult):void;
		
		function endTestRun():void;
		
	}
}
