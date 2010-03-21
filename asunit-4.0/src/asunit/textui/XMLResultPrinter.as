package asunit.textui {

    import asunit.errors.AssertionFailedError;
    import asunit.framework.Test;
    import asunit.framework.TestListener;
    import asunit.framework.TestResult;
	import asunit.framework.ITestResult;
	import asunit.framework.ITestFailure;
    import flash.utils.setTimeout;
    import flash.utils.Dictionary;

    /**
    *   The <code>XMLResultPrinter</code> is used to transform AsUnit test results
    *   to JUnit-compatible XML content.
    *
    *   This printer will send JUnit-compatible XML content to trace output. The XML content
    *   will be enclosed by '&lt;XMLResultPrinter/&gt;' tags.
    *
    *   @includeExample XMLResultPrinterExample.as
    *   @includeExample XMLResultPrinterExample.xml
    **/
    public class XMLResultPrinter extends ResultPrinter {

        protected var results:Dictionary;

        public function XMLResultPrinter() {
            results = new Dictionary();
        }

        override public function startTest(test:Object):void {
            super.startTest(test);
            var result:TestListener = new XMLTestResult(test);
            results[test.getName()] = result;
            result.startTest(test);
        }

        override public function endTest(test:Object):void {
            super.endTest(test);
            results[test.getName()].endTest(test);
        }

        override public function startTestMethod(test:Object, methodName:String):void {
            super.startTestMethod(test, methodName);
            results[test.getName()].startTestMethod(test, methodName);
        }

        override public function endTestMethod(test:Object, methodName:String):void {
            super.endTestMethod(test, methodName);
            results[test.getName()].endTestMethod(test, methodName);
        }

        override public function addFailure(failure:ITestFailure):void {
            super.addFailure(failure);
            results[failure.failedTest.getName()].addFailure(failure);
        }

        override public function addError(failure:ITestFailure):void {
            super.addError(failure);
            results[failure.failedTest.getName()].addError(failure);
        }

        override public function printResult(result:ITestResult, runTime:Number):void {
            super.printResult(result, runTime);
            trace("<XMLResultPrinter>");
            trace("<?xml version='1.0' encoding='UTF-8'?>");
            trace("<testsuites>");
            trace("<testsuite name='AllTests' errors='" + result.errorCount + "' failures='" + result.failureCount + "' tests='" + result.runCount + "' time='" + elapsedTimeAsString(runTime) + "'>");
            var xmlTestResult:XMLTestResult;
            for each(xmlTestResult in results) {
                trace(xmlTestResult.toString());
            }
            trace("</testsuite>");
            trace("</testsuites>");
            trace("</XMLResultPrinter>");
        }
    }
}

import asunit.framework.Test;
import asunit.framework.TestFailure;
import asunit.framework.ITestFailure;
import flash.utils.getQualifiedClassName;
import flash.utils.getTimer;
import asunit.framework.TestListener;
import asunit.errors.AssertionFailedError;
import asunit.framework.TestMethod;
import flash.utils.Dictionary;

class XMLTestResult implements TestListener {

    private var _duration:Number;
    private var start:Number;
    private var test:Object;
    private var testName:String;
    private var failureHash:Dictionary;
    private var failures:Array;
    private var errorHash:Dictionary;
    private var errors:Array;
    private var methodHash:Dictionary;
    private var methods:Array;

    public function XMLTestResult(test:Object) {
        this.test = test;
        testName = test.getName().split("::").join(".");
        failures = new Array();
        errors = new Array();
        methods = new Array();

        failureHash = new Dictionary();
        errorHash = new Dictionary();
        methodHash = new Dictionary();
    }

    public function startTest(test:Object):void {
        start = getTimer();
    }

    public function run(test:Object):void {
    }

    public function addError(failure:ITestFailure):void {
        errors.push(failure);
        errorHash[failure.failedMethod] = failure;
    }

    public function addFailure(failure:ITestFailure):void {
        failures.push(failure);
        failureHash[failure.failedMethod] = failure;
    }

    public function startTestMethod(test:Object, methodName:String):void {
        var method:TestMethod = new TestMethod(test, methodName);
        methods.push(method);
        methodHash[method.getName()] = method;
    }

    public function endTestMethod(test:Object, methodName:String):void {
        methodHash[methodName].endTest(test);
    }

    public function endTest(test:Object):void {
        _duration = (getTimer() - start) * .001;
    }

    private function errorCount():int {
        return errors.length;
    }

    private function failureCount():int {
        return failures.length;
    }

    private function duration():Number {
        return _duration;
    }

    private function renderSuiteOpener():String {
        return "<testsuite name='" + testName + "' errors='" + errorCount() + "' failures='" + failureCount() + "' tests='" + methods.length + "' time='" + duration() + "'>\n";
    }

    private function renderTestOpener(methodName:String):String {
        return "<testcase classname='" + testName + "' name='" + methodName + "' time='" + methodHash[methodName].duration() + "'>\n";
    }

    private function renderTestBody(method:String):String {
        if(errorHash[method]) {
            return renderError(errorHash[method]);
        }
        else if(failureHash[method]) {
            return renderFailure(failureHash[method]);
        }
        else {
            return "";
        }
    }

    private function renderError(failure:ITestFailure):String {
        return "<error type='" + getQualifiedClassName(failure.thrownException).split("::").join(".") + "'><![CDATA[\n" + failure.thrownException.getStackTrace() + "\n]]></error>\n";
    }

    private function renderFailure(failure:ITestFailure):String {
        return "<failure type='" + getQualifiedClassName(failure.thrownException).split("::").join(".") + "'><![CDATA[\n" + failure.thrownException.getStackTrace() + "\n]]></failure>\n";
    }

    private function renderTestCloser():String {
        return '</testcase>\n';
    }

    private function renderSuiteCloser():String {
        return '</testsuite>\n';
    }

    public function toString():String {
        var str:String = '';
        str += renderSuiteOpener();
        for(var name:String in methodHash) {
            str += renderTestOpener(name);
            str += renderTestBody(name);
            str += renderTestCloser();
        }
        str += renderSuiteCloser();
        return str;
    }
}

