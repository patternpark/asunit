import asunit.textui.XMLTestResult;import asunit.textui.ResultPrinter;import asunit.errors.AssertionFailedError;
import asunit.framework.Test;
import asunit.framework.TestListener;
import asunit.framework.TestResult;

class asunit.textui.XMLResultPrinter extends ResultPrinter {
	private var results:Object;
	
	public function XMLResultPrinter() {
		results = {};
	}

	public function startTest(test:Test):Void {
		super.startTest(test);
		var result:TestListener = new XMLTestResult(test);
		results[test.getName()] = result;
		result.startTest(test);
	}

	public function endTest(test:Test):Void {
		super.endTest(test);
		results[test.getName()].endTest(test);
	}
	
	public function startTestMethod(test:Test, methodName:String):Void {
		super.startTestMethod(test, methodName);
		results[test.getName()].startTestMethod(test, methodName);
	}

	public function endTestMethod(test:Test, methodName:String):Void {
		super.endTestMethod(test, methodName);
		results[test.getName()].endTestMethod(test, methodName);
	}

	public function addFailure(test:Test, t:AssertionFailedError):Void {
		super.addFailure(test, t);
		results[test.getName()].addFailure(test, t);
	}
	
	public function addError(test:Test, t:Error):Void {
		super.addError(test, t);
		results[test.getName()].addError(test, t);
	}

/*
<testsuites>
  <testsuite name="Flash Profile Card AsUnit Test Suite" errors="1" failures="1" tests="8" time="8.002">
    <testcase classname="lib.test.cases.FailureTest" name="testError" time="0.049">
      <error type="java.lang.NullPointerException">
      	<!-- stack trace -->
      </error>
      <failure type="Error">Reference runtime test error</failure>
    </testcase>
    <testcase classname="lib.test.cases.FailureTest" name="testAssertion">
      <failure type="AssertionFailedError">Reference assertion test failure</failure>
    </testcase>
  </testsuite>
</testsuites>
*/
	public function printResult(result:TestResult, runTime:Number):Void {
		super.printResult(result, runTime);

/*
			if(result.errorCount()) {
				var error:TestFailure;
				for each(error in result.errors()) {
					results[error.failedTest().getName()].addFailure(error);
				}
			}
			if(result.failureCount()) {
				var failure:TestFailure;
				for each(failure in result.failures()) {
					results[failure.failedTest().getName()].addFailure(failure);
				}
			}
*/

		trace("<XMLResultPrinter>");
		trace("<?xml version='1.0' encoding='UTF-8'?>");
		trace("<testsuites>");
		trace("<testsuite name='AllTests' errors='" + result.errorCount() + "' failures='" + result.failureCount() + "' tests='" + result.runCount() + "' time='" + elapsedTimeAsString(runTime) + "'>");
		for(var p:String in results){			trace(results[p].toString());		}
		trace("</testsuite>");
		trace("</testsuites>");
		trace("</XMLResultPrinter>");
	}
}
