package asunit.printers {
    
    import asunit.asserts.*;
    import asunit.errors.AssertionFailedError;
    import asunit.framework.ITestFailure;
    import asunit.framework.TestCase;

    import asunit.framework.IResult;
    import asunit.framework.ITestSuccess;
    import asunit.framework.ITestWarning;
    import asunit.framework.Method;
    import asunit.framework.Result;
    import asunit.framework.TestFailure;
    import asunit.framework.TestSuccess;
    import asunit.framework.TestWarning;

    import p2.reflect.Reflection;
    import p2.reflect.ReflectionMethod;


    public class XMLPrinterTest extends TestCase {

        private var printer:XMLPrinter;
        private var test:*;
        private var testSuccess:ITestSuccess;
        private var testError:ITestFailure;
        private var testFailure:ITestFailure;
        private var testResult:IResult;
        private var testWarning:ITestWarning;

        public function XMLPrinterTest(method:String=null) {
            super(method);
        }

        override protected function setUp():void {
            super.setUp();
            printer    = new XMLPrinter();
            printer.traceResults = false;

            test        = new FakeTestCase();
            var reflect:Reflection = Reflection.create(test);
            var methodReflection:ReflectionMethod = reflect.methods[0];
            var method:Method = new Method(test, methodReflection);

            testResult  = new Result();
            testError   = new TestFailure(test, 'testSomethingThatErrors', new Error('Fake Error'));
            testFailure = new TestFailure(test, 'testSomethingThatFails', new AssertionFailedError('Fake Failure'));
            testSuccess = new TestSuccess(test, 'testSomethingThatSucceeds');
            testWarning = new TestWarning(test, method);
            testResult.addListener(printer);
        }

        private function executeTestWith(handler:Function):void {
            testResult.onRunStarted();
            testResult.onTestStarted(test);
            handler.call(this);
            testResult.onTestCompleted(test);
            testResult.onRunCompleted(null);
        }

        private function executeASucceedingTest():String {
            executeTestWith(function():void {
                testResult.onTestSuccess(testSuccess);
            });
            return printer.toString();
        }

        private function executeASucceedingTestWithWarning():String {
            executeTestWith(function():void {
                testResult.onWarning(testWarning);
                testResult.onTestSuccess(testSuccess);
            });
            testResult.onRunStarted();
            testResult.onTestStarted(test);
            testResult.onTestCompleted(test);
            testResult.onRunCompleted(null);
            return printer.toString();
        }

        private function executeAFailingTest():String {
            executeTestWith(function():void {
                testResult.onTestFailure(testFailure);
            });
            return printer.toString();
        }

        private function executeAnErrorTest():String {
            executeTestWith(function():void {
                testResult.onTestFailure(testError);
            });
            return printer.toString();
        }

        public function testPrinterStartAndFinish():void {
            var actual:String = executeASucceedingTest();
            assertMatches(/<TestResults>/, actual);
            assertMatches(/startTestRun/, actual);
            assertMatches(/<endOfTestRun \/>/, actual);
            assertMatches(/<\/TestResults>/, actual);

            assertMatches(/status='success'/, actual);
        }

        public function testPrinterFailure():void {
            var actual:String = executeAFailingTest();
            assertMatches(/status='failure'/, actual);
            assertMatches(/stackTraceInfo/, actual);
            assertMatches(/asunit\/printers\/XMLPrinterTest.as/, actual);
        }

        public function testPrinterError():void {
            var actual:String = executeAnErrorTest();
            assertMatches(/status='error'/, actual);
            assertMatches(/stackTraceInfo/, actual);
            assertMatches(/asunit\/printers\/XMLPrinterTest.as/, actual);
        }

        public function testPrinterWarning():void {
            var actual:String = executeASucceedingTestWithWarning();
            assertMatches(/status='warning'/, actual);
            assertMatches(/status='success'/, actual);
        }
    }
}

class FakeTestCase {

    [Test]
    public function testSomething():void {
    }
}
