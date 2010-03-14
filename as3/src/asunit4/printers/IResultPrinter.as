package asunit4.printers {
	import asunit4.framework.IResult;

	public interface IResultPrinter {
		
		function startTestRun():void;
		
		function addResult(result:IResult):void;
		
		function endTestRun():void;
		
	}
}
