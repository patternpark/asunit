package asunit4.printers {
    
    import asunit.framework.Test;
    import asunit.framework.TestCase;
    import asunit4.framework.ITestSuccess;
    import asunit4.framework.TestSuccess;
    import asunit4.framework.ITestFailure;
    import asunit4.framework.TestFailure;
    import asunit4.framework.IResult;
    import asunit4.framework.Result;

    public class TextPrinterTest extends TestCase {

        private var printer:TextPrinter;
        private var test:Test;
        private var success:ITestSuccess;
        private var failure:ITestFailure;
        private var iResult:IResult;

        public function TextPrinterTest(method:String=null) {
            super(method);
        }

        override protected function setUp():void {
            super.setUp();
            printer = new TextPrinter();
            iResult = new Result();
            test    = new TestCase();
            failure = new TestFailure(test, 'testSomethingThatFails', new Error('Fake Failure'));
            success = new TestSuccess(test, 'testSomethingThatSucceeds');
            iResult.addListener(printer);
        }

        override protected function tearDown():void {
            super.tearDown();
            failure = null;
            printer = null;
            iResult = null;
            success = null;
            test    = null;
        }

        private function executeASucceedingTest():void {
            iResult.onRunStarted();
            iResult.onTestStarted(test);
            iResult.onTestSuccess(success);
            iResult.onTestCompleted(test);
            iResult.onRunCompleted(null);
        }


        public function testPrinterInstantiated():void {
            var printer:TextPrinter = new TextPrinter();
            assertNotNull(printer);
        }

        public function testPrinterOnTestSuccess():void {
            assertTrue(printer.toString().indexOf('OK') > -1);
            trace(">> printer: " + printer);
            //assertMatch(/\n\.\n/, printer.toString());
        }
    }
}

