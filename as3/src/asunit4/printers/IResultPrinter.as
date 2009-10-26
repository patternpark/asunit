package asunit4.printers {
	
	import asunit4.framework.IFreeTestResult;
	
	public interface IResultPrinter {
		
		function startTestRun():void;
		
		function addTestResult(result:IFreeTestResult):void;
		
		function endTestRun():void;
		
	}
}
