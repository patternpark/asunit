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

    public class ColorTracePrinterTest extends TestCase {

        private var printer:FakeTextPrinter;
        private var test:*;
        private var success:ITestSuccess;
        private var failure:ITestFailure;
        private var testResult:IResult;

        public function ColorTracePrinterTest(method:String=null) {
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
			const GREEN:String = String.fromCharCode(27) + "[32m";
			const RESET:String = String.fromCharCode(27) + "[0m"

            assertTrue("Printer should print OK in green", actual.indexOf( GREEN + 'OK' + RESET ) > -1);
            assertTrue("Printer should include Tests run: ", actual.match(/Tests run: 1/));
        }

        public function testPrinterFailure():void {
            executeAFailingTest();
            var expected:String = "Fake Failure";
            var actual:String = printer.toString();
			const RED:String = String.fromCharCode(27) + "[31m";
			const RESET:String = String.fromCharCode(27) + "[0m"

			assertTrue("Printer should print FAILURE in red", actual.indexOf(RED + 'FAILURE' + RESET) > -1);
            assertTrue("Printer should fail", actual.indexOf(expected) > -1);
            assertTrue("Printer should include Test Duration: ", actual.match(/Total Time: \d/));
        }

        public function testPrinterWithNoTests():void {
            testResult.onRunStarted();
            testResult.onRunCompleted(null);
            assertTrue("Printer should include Warning for no tests", printer.toString().indexOf("[WARNING]") > -1);
        }

        public function testDisplaysWarnings():void {
            var message:String = "problem"
            executeASucceedingTestWithWarning(new TestWarning(message));

			var actual:String = printer.toString();
			
			const YELLOW:String = String.fromCharCode(27) + "[33m";
			const RESET:String = String.fromCharCode(27) + "[0m"
			assertTrue("Printer should print Warning in yellow", actual.indexOf(YELLOW + 'Warning' + RESET) > -1);
            assertTrue("Printer displays warnings", actual.indexOf(message) > -1);
        }
    }
}

import asunit.printers.ColorTracePrinter;

class FakeTextPrinter extends ColorTracePrinter {

    // Prevent the printer from tracing results:
    override protected function logResult():void {
    }
}

