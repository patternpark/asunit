package asunit4.runners {

    import asunit.framework.TestCase;

    import asunit4.framework.IResult;
    import asunit4.framework.Result;
    import asunit4.framework.LegacyTestIterator;
    import asunit4.support.LegacyTestCase;

    public class LegacyRunnerTest extends TestCase {

        private var testResult:IResult;
        private var testRunner:LegacyRunner;

        public function LegacyRunnerTest(methodName:String=null) {
            super(methodName)
        }

        override protected function setUp():void {
            super.setUp();
            LegacyTestCase.callCount = 0;
            testResult = new Result();
            testRunner = new LegacyRunner();
        }

        override protected function tearDown():void {
            super.tearDown();
            testResult = null;
            testRunner = null;
        }

        public function testSimpleSubclass():void {
            testRunner.run(LegacyTestCase, testResult);
            assertEquals(0, testResult.failureCount);
            assertEquals(2, testResult.runCount);
        }
    }
}

