package asunit.runner {
	import asunit.textui.ResultPrinter;
	
	/**
	*
	*/
	public interface ITestRunner {
		function get printer():ResultPrinter;
		function set printer(value:ResultPrinter):void;
	}
	
}