package asunit4.framework {

    import asunit.framework.Test;
    import asunit.framework.TestCase;
    import asunit4.framework.ITestSuccess;
    import asunit4.framework.TestSuccess;
    import asunit.framework.ITestFailure;
    import asunit4.framework.TestFailure;
    import asunit4.framework.IResult;
    import asunit4.framework.Result;

	public class ResultTest extends TestCase {

        private var test:Test;
        private var success:ITestSuccess;
        private var failure:ITestFailure;
        private var testResult:IResult;

		public function ResultTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
            failure    = new TestFailure(test, 'testSomethingThatFails', new Error('Fake Failure'));
            success    = new TestSuccess(test, 'testSomethingThatSucceeds');
            test       = new TestCase();
            testResult = new Result();
		}

		override protected function tearDown():void {
			super.tearDown();
            failure    = null;
            success    = null;
            test       = null;
            testResult = null;
		}

		public function testInstantiated():void {
			assertTrue("result is Result", testResult is Result);
		}

		public function testRunCountWithSingleSuccess():void {
            testResult.onRunStarted();
            testResult.onTestStarted(test);
            testResult.onTestSuccess(success);
            testResult.onTestCompleted(test);
            testResult.onRunCompleted(testResult);
			assertEquals(1, testResult.runCount);
		}

        public function testRunCountWithSingleError():void {
            testResult.onRunStarted();
            testResult.onTestStarted(test);
            testResult.onTestFailure(failure);
            testResult.onTestCompleted(test);
            testResult.onRunCompleted(testResult);
			assertEquals(1, testResult.runCount);
        }

        public function testRunCountWithSingleIgnore():void {
            testResult.onRunStarted();
            testResult.onTestStarted(test);
            testResult.onTestIgnored(null);
            testResult.onTestCompleted(test);
            testResult.onRunCompleted(testResult);
			assertEquals(0, testResult.runCount);
        }
	}
}
