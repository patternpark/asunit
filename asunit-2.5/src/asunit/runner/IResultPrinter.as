import asunit.framework.ITestListener;
import asunit.framework.TestResult;

interface asunit.runner.IResultPrinter extends ITestListener {
	
	public function printResult(result:TestResult, runTime:Number):Void;
	public function traceln():Void;
	public function setShowTrace(showTrace:Boolean):Void;
	public function getShowTrace():Boolean;
}