package asunit4.printers {
    
    import asunit.framework.Test;
    import asunit.framework.TestCase;
    import asunit4.framework.ITestSuccess;
    import asunit4.framework.TestSuccess;
    import asunit.framework.ITestFailure;
    import asunit4.framework.TestFailure;
    import asunit4.framework.IResult;
    import asunit4.framework.Result;

    public class TextPrinterTest extends TestCase {

        private var printer:TextPrinter;
        private var test:Test;
        private var success:ITestSuccess;
        private var failure:ITestFailure;
        private var testResult:IResult;

        public function TextPrinterTest(method:String=null) {
            super(method);
        }

        override protected function setUp():void {
            super.setUp();
            printer    = new FakeTextPrinter();
            testResult = new Result();
            test       = new TestCase();
            failure    = new TestFailure(test, 'testSomethingThatFails', new Error('Fake Failure'));
            success    = new TestSuccess(test, 'testSomethingThatSucceeds');
            testResult.addListener(printer);
        }

        override protected function tearDown():void {
            super.tearDown();
            failure    = null;
            printer    = null;
            testResult = null;
            success    = null;
            test       = null;
            removeChild(printer);
        }

        private function executeASucceedingTest():void {
            testResult.onRunStarted();
            testResult.onTestStarted(test);
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
            assertTrue("Printer should print OK", printer.toString().indexOf('OK') > -1);
        }

        public function testPrinterFailure():void {
            executeAFailingTest();
            var expected:String = "testSomethingThatFails : Error: Fake Failure";
            assertTrue("Printer should fail", printer.toString().indexOf(expected) > -1);
        }

        public function testPrinterDisplayed():void {
            executeASucceedingTest();
            addChild(printer);
        }
    }
}

import asunit4.printers.TextPrinter;

class FakeTextPrinter extends TextPrinter {

    // Prevent the printer from tracing results:
    override protected function logResult():void {
    }
}
