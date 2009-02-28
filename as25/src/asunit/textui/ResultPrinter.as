import asunit.util.ArrayUtil;
import asunit.textui.SuccessBar;
import asunit.errors.AssertionFailedError;
import asunit.framework.Test;
import asunit.framework.TestFailure;
import asunit.framework.TestListener;
import asunit.framework.TestResult;
import asunit.runner.BaseTestRunner;
import asunit.runner.Version;

import asunit.flash.utils.Timer;

class asunit.textui.ResultPrinter implements TestListener {
	
	private var fColumn:Number = 0;
	private var textArea:TextField;
	private var gutter:Number = 0;
	private var backgroundColor:Number = 0x333333;
	private var bar : SuccessBar;
	private var barHeight:Number = 3;
	private var showTrace:Boolean;

	public function ResultPrinter(showTrace:Boolean) {
		this.showTrace = showTrace==undefined ? false : showTrace;
	}

	public function setParent(parent:MovieClip):Void{
		configureAssets(parent);
		println();
	}
	
	public function destroyAssets():Void {
		bar.removeMovieClip();
		textArea.removeTextField();
	}

	private function configureAssets(base:MovieClip):Void {

		// assume FP7
		base.createTextField("textArea", 0, 0, 0, 100, 100);
		textArea = TextField(base["textArea"]);		
		
		textArea.background = true;
		textArea.backgroundColor = backgroundColor;
		textArea.border = true;
		textArea.wordWrap = true;
		var format:TextFormat = new TextFormat();
		format.font = "Verdana";
		format.size = 10;
		format.color = 0xFFFFFF;
		textArea.setNewTextFormat(format);

		println("AsUnit " + Version.id() + " by Luke Bayes and Ali Mills");

		bar = SuccessBar.create(base.createEmptyMovieClip("successBar", 1));
	}

	public function setShowTrace(showTrace:Boolean):Void {
		this.showTrace = showTrace;
	}
	
	public function set width(w:Number):Void {
		textArea._x = gutter;
		textArea._width = w - gutter*2;
		bar._x = gutter;
		bar.width = textArea._width;
	}

	public function set height(h:Number):Void {
		textArea._height = h - ((gutter*2) + barHeight);
		textArea._y = gutter;
		bar._y = h - (gutter + barHeight);
		bar.height = barHeight;
	}

	public function println():Void {
		textArea.text += (arguments.toString() + "\n");
	}

	/*
	 * Flash IDE compiler mandates that "print must have two parameters",
	 * as a workaround have renamed to _print.
	 */
	public function _print():Void {
		textArea.text += (arguments.toString());
	}
	
	/**
	 * API for use by textui.TestRunner
	 */
	 
	public function run(test:Test):Void {
	}
	
	public function printResult(result:TestResult, runTime:Number):Void {
		printHeader(runTime);
	    printErrors(result);
	    printFailures(result);
	    printFooter(result);

	    bar.setSuccess(result.wasSuccessful());
	    if(showTrace) {
			trace(textArea.text.split("\r").join("\n"));
	    }
	}

	/* Internal methods
	 */
	private function printHeader(runTime:Number):Void {
		println();
		println();
		println("Time: " + elapsedTimeAsString(runTime));
	}

	private function printErrors(result:TestResult):Void {
		printDefects(result.errors(), result.errorCount(), "error");
	}

	private function printFailures(result:TestResult):Void {
		printDefects(result.failures(), result.failureCount(), "failure");
	}

	private function printDefects(booBoos:Array, count:Number, type:String):Void {
		if (count == 0) {
			return;
		}
		if (count == 1) {
			println("There was " + count + " " + type + ":");
		}
		else {
			println("There were " + count + " " + type + "s:");
		}
		var rP:ResultPrinter = this;
		ArrayUtil.forEach(booBoos,
			function(item:TestFailure, i:Number):Void{
				rP.printDefect(TestFailure(item), i);
			}
		);
	}

	public function printDefect(booBoo:TestFailure, count:Number ):Void { // only public for testing purposes
		printDefectHeader(booBoo, count);
		printDefectTrace(booBoo);
	}

	private function printDefectHeader(booBoo:TestFailure, count:Number):Void {
		// I feel like making this a println, then adding a line giving the throwable a chance to print something
		// before we get to the stack trace.
		var startIndex:Number = textArea.text.length;
		println(count + ") " + booBoo.failedFeature());
		var endIndex:Number = textArea.text.length;

		var format:TextFormat = textArea.getTextFormat();
		format.bold = true;

		// GROSS HACK because of bug in flash player - TextField isn't accepting formats...
		Timer.setTimeout(this, onFormatTimeout, 1, format, startIndex, endIndex);
	}

	public function onFormatTimeout(format:TextFormat, startIndex:Number, endIndex:Number):Void {
		textArea.setTextFormat(format, startIndex, endIndex);
	}

	private function printDefectTrace(booBoo:TestFailure):Void {
		println(BaseTestRunner.getFilteredTrace(booBoo.thrownException().toString()));
	}

	private function printFooter(result:TestResult):Void {
		println();
		if (result.wasSuccessful()) {
			_print("OK");
			println (" (" + result.runCount() + " test" + (result.runCount() == 1 ? "": "s") + ")");
		} else {
			println("FAILURES!!!");
			println("Tests run: " + result.runCount()+
				         ",  Failures: "+result.failureCount()+
				         ",  Errors: "+result.errorCount());
		}
	    println();
	}

	/**
	 * Returns the formatted string of the elapsed time.
	 * Duplicated from BaseTestRunner. Fix it.
	 */
	private function elapsedTimeAsString(runTime:Number):String {
		return Number(runTime/1000).toString();
	}

	/**
	 * @see asunit.framework.TestListener#addError(Test, Throwable)
	 */
	public function addError(test:Test, t:Error):Void {
		_print("E");
	}

	/**
	 * @see asunit.framework.TestListener#addFailure(Test, AssertionFailedError)
	 */
	public function addFailure(test:Test, t:AssertionFailedError):Void {
		_print("F");
	}

	/**
	 * @see asunit.framework.TestListener#endTestMethod(test, testMethod);
	 */
	public function startTestMethod(test:Test, methodName:String):Void {
	}

	/**
	 * @see asunit.framework.TestListener#endTestMethod(test, testMethod);
	 */
	public function endTestMethod(test:Test, methodName:String):Void {
	}

	/**
	 * @see asunit.framework.TestListener#endTest(Test)
	 */
	public function endTest(test:Test):Void {
	}

	/**
	 * @see asunit.framework.TestListener#startTest(Test)
	 */
	public function startTest(test:Test):Void {
		var count:Number = test.countTestCases();
		for(var i:Number=0; i < count; i++) {
			_print(".");
			if (fColumn++ >= 80) {
				println();
				fColumn = 0;
			}
		}
	}
}
