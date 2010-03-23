package asunit.printers {
    
    import asunit.framework.ITestFailure;
    import asunit.framework.TestCase;

    import asunit.framework.IResult;
    import asunit.framework.ITestSuccess;
    import asunit.framework.ITestWarning;
    import asunit.framework.Result;
    import asunit.framework.TestFailure;
    import asunit.framework.TestSuccess;
    import asunit.framework.TestWarning;

    public class TextPrinterTest extends TestCase {

        private var printer:FakeTextPrinter;
        private var test:*;
        private var success:ITestSuccess;
        private var failure:ITestFailure;
        private var testResult:IResult;

        public function TextPrinterTest(method:String=null) {
            super(method);
        }

        override protected function setUp():void {
            super.setUp();
            printer    = new FakeTextPrinter();
            printer.backgroundColor = 0xffcc00;
            printer.textColor = 0x000000;

            testResult = new Result();
            test       = new TestCase();
            failure    = new TestFailure(test, 'testSomethingThatFails', new Error('Fake Failure'));
            success    = new TestSuccess(test, 'testSomethingThatSucceeds');
            testResult.addListener(printer);
        }

        override protected function tearDown():void {
            super.tearDown();
            removeChild(printer);
            failure    = null;
            printer    = null;
            testResult = null;
            success    = null;
            test       = null;
        }

        private function executeASucceedingTest():void {
            testResult.onRunStarted();
            testResult.onTestStarted(test);
            testResult.onTestSuccess(success);
            testResult.onTestCompleted(test);
            testResult.onRunCompleted(null);
        }

        private function executeASucceedingTestWithWarning(warning:ITestWarning):void {
            testResult.onRunStarted();
            testResult.onTestStarted(test);
            testResult.onWarning(warning);
            testResult.onTestSuccess(success);
            testResult.onTestCompleted(test);
            testResult.onRunCompleted(null);
        }

        private function executeAFailingTest():void {
            testResult.onRunStarted();
            testResult.onTestStarted(test);
            testResult.onTestFailure(failure);
            testResult.onTestCompleted(test);
            testResult.onRunCompleted(null);
        }

        public function testPrinterOnTestSuccess():void {
            executeASucceedingTest();
            var actual:String = printer.toString();
            assertTrue("Printer should print OK", actual.indexOf('OK') > -1);
            assertTrue("Printer should include Test count: ", actual.match(/\nOK \(1 test\)/));
        }

        public function testPrinterFailure():void {
            executeAFailingTest();
            var expected:String = "testSomethingThatFails : Error: Fake Failure";
            var actual:String = printer.toString();
            assertTrue("Printer should fail", actual.indexOf(expected) > -1);
            assertTrue("Printer should include Test Duration: ", actual.match(/\nTotal Time: \d/));
        }

        public function testPrinterWithNoTests():void {
            testResult.onRunStarted();
            testResult.onRunCompleted(null);
            assertTrue("Printer should include Warning for no tests", printer.toString().indexOf("[WARNING]") > -1);
        }

        public function testPrinterDisplayed():void {
            addChild(printer);
            executeASucceedingTest();
            assertTrue("The output was displayed.", printer.getTextDisplay().text.indexOf('Time Summary:') > -1);
        }

        public function testDisplaysWarnings():void {
            var message:String = "problem"
            executeASucceedingTestWithWarning(new TestWarning(message));
            assertTrue("Printer displays warnings", printer.toString().indexOf(message) > -1);
        }
    }
}

import asunit.printers.TextPrinter;
import flash.text.TextField;

class FakeTextPrinter extends TextPrinter {

    // Prevent the printer from tracing results:
    override protected function logResult():void {
    }

    public function getTextDisplay():TextField {
        return textDisplay;
    }
}

