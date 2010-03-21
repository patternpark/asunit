import asunit.flash.utils.Timer;
import asunit.textui.ResultPrinter;
import asunit.framework.Test;
import asunit.framework.TestResult;

import asunit.flash.events.Event;

/**
 * A command line based tool to run tests.
 * <pre>
 * java junit.textui.TestRunner TestCaseClass
 * </pre>
 * TestRunner expects the name of a TestCase class as argument.
 * If this class defines a static <code>suite</code> method it
 * will be invoked and the returned test is run. Otherwise all
 * the methods starting with "test" having no arguments are run.
 * <p>
 * TestRunner prints a trace as the tests are executed followed by a
 * summary at the end.
 */
class asunit.textui.TestRunner{
	public static var SUCCESS_EXIT:Number   = 0;
	public static var FAILURE_EXIT:Number   = 1;
	public static var EXCEPTION_EXIT:Number = 2;
	public static var SHOW_TRACE:Boolean = true;
	private var fPrinter : ResultPrinter;
	private var startTime:Number;
	private var result:TestResult;
	private var parent:MovieClip;

	public function TestRunner(parent:MovieClip) {
		this.parent = parent instanceof MovieClip ? parent : _root;
		fPrinter = null;
		result = null;
		startTime = 0;
		configureListeners();
	}

	private function configureListeners():Void {
		addedHandler();
	}

	private function addedHandler():Void {
		Stage.align = "TL";
		Stage.scaleMode = "noScale";
		var tR:TestRunner = this;
		Stage.addListener({
			onResize:function():Void{
				tR.resizeHandler();
			}
		});
		resizeHandler();
	}

	private function resizeHandler():Void {
		fPrinter.width = Stage.width;
		fPrinter.height = Stage.height;
	}

	/**
	 * Starts a test run based on the TestCase/TestSuite provided
	 * Create a new custom class that extends TestRunner
	 * and call start(TestCaseClass) from within the
	 * constructor.
	 */
	public function start(testCase:Function, testMethod:String, showTrace:Boolean):TestResult {
		if(testMethod==undefined) testMethod = null;
		if(showTrace==undefined) showTrace = false;
		try {
			var instance:Test;
			if(testMethod != null) {
				instance = new testCase(testMethod);
			}
			else {
				instance = new testCase();
			}
			return doRun(instance, showTrace);
		}
		catch(e:Error) {
			throw new Error("Could not create and run test suite: " + e.toString());
		}
		return null;
	}

	public function doRun(test:Test, showTrace:Boolean):TestResult {
		
		if(showTrace==undefined) showTrace=false;
		result = new TestResult();
		if(fPrinter == null) {
			setPrinter(new ResultPrinter(showTrace));
		}
		else {
			fPrinter.setShowTrace(showTrace);
		}
		result.addListener(getPrinter());
		startTime = getTimer();
		test.setResult(result);
		test.setContext(parent);
		test.addEventListener(Event.COMPLETE, testCompleteHandler, this);
		test.run();
		return result;
	}
	
	private function testCompleteHandler(event:Event):Void {
		var endTime:Number = getTimer();
		var runTime:Number = endTime - startTime;
		
		getPrinter().printResult(result, runTime);
	}

	public function setPrinter(printer:ResultPrinter):Void {
		// TODO - decouple the fact that printers need parents
		if(printer) printer.destroyAssets();
		fPrinter = printer;
		fPrinter.setParent(parent);
		resizeHandler();
	}

	public function getPrinter():ResultPrinter {
		return fPrinter;
	}
}