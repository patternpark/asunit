package asunit.runners {

    import asunit.asserts.*;
    import asunit.framework.IAsync;
    import asunit.framework.Result;
    import asunit.framework.TestCase;
    import asunit.support.CustomTestRunner;
    import asunit.support.DoubleFailSuite;
    import asunit.support.InjectionVerification;
    import asunit.support.SuiteWithCustomRunner;

    import flash.events.Event;

    public class SuiteRunnerTest {

        [Inject]
        public var async:IAsync;

        [Inject]
        public var suiteRunner:SuiteRunner;

        [Inject]
        public var runnerResult:Result;

        [After]
        public function cleanUpStatics():void {
            CustomTestRunner.runCalled = false;
        }

        public function testRunTriggersCompleteEvent():void {
            suiteRunner.addEventListener(Event.COMPLETE, async.add(checkResultWasNotSuccessful));
            suiteRunner.run(DoubleFailSuite, runnerResult);
        }
        
        private function checkResultWasNotSuccessful(event:Event):void {
            assertFalse(runnerResult.wasSuccessful);
        }

        [Test]
        public function testCanHandATestToSuiteRunner():void {
            suiteRunner.addEventListener(Event.COMPLETE, async.add());
            suiteRunner.run(InjectionVerification, runnerResult);
            assertFalse(runnerResult.wasSuccessful);
        }

        [Test]
        public function testRunWithOnASuite():void {
            suiteRunner.addEventListener(Event.COMPLETE, async.add(verifyCustomRunnerCalled));
            suiteRunner.run(SuiteWithCustomRunner, runnerResult);
        }

        private function verifyCustomRunnerCalled():void {
            assertTrue("CustomRunner.run was NOT called", CustomTestRunner.runCalled);
        }
    }
}

