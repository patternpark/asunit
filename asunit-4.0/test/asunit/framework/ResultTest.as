package asunit.framework {

    import asunit.framework.TestCase;
    import asunit.framework.ITestSuccess;
    import asunit.framework.TestSuccess;
    import asunit.framework.ITestFailure;
    import asunit.framework.TestFailure;
    import asunit.framework.IResult;
    import asunit.framework.Result;

	public class ResultTest extends TestCase {

        private var test:*;
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

        private function runSingleSuccess():void {
            testResult.onRunStarted();
            testResult.onTestStarted(test);
            testResult.onTestSuccess(success);
            testResult.onTestCompleted(test);
            testResult.onRunCompleted(null);
        }

        private function runSingleFailure():void {
            testResult.onRunStarted();
            testResult.onTestStarted(test);
            testResult.onTestFailure(failure);
            testResult.onTestCompleted(test);
            testResult.onRunCompleted(testResult);
        }

        private function runSingleIgnore():void {
            testResult.onRunStarted();
            testResult.onTestStarted(test);
            testResult.onTestIgnored(null);
            testResult.onTestCompleted(test);
            testResult.onRunCompleted(testResult);
        }

		public function testRunWithSingleSuccess():void {
            assertFalse("before test run", testResult.wasSuccessful);
            runSingleSuccess();
            assertFalse("failure encountered", testResult.failureEncountered);
            assertTrue("after test complete", testResult.wasSuccessful);
			assertEquals(1, testResult.runCount);
		}

        public function testRunWithSingleFailure():void {
            runSingleFailure();
            assertTrue("failure encountered", testResult.failureEncountered);
            assertFalse("after test complete", testResult.wasSuccessful);
			assertEquals(1, testResult.runCount);
        }

        public function testRunWithSingleError():void {
            runSingleFailure();
            assertTrue("failure encountered", testResult.failureEncountered);
            assertFalse("after test complete", testResult.wasSuccessful);
			assertEquals(1, testResult.runCount);
        }

        public function testRunCountWithSingleIgnore():void {
            runSingleIgnore();
            assertFalse("failure encountered", testResult.failureEncountered);
            assertTrue("after test complete", testResult.wasSuccessful);
			assertEquals(0, testResult.runCount);
        }
	}
}

