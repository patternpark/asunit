package asunit.runners {

    import asunit.asserts.*;
    import asunit.framework.IAsync;
    import asunit.framework.Result;
    import asunit.support.DoubleFailSuite;
    import asunit.support.InjectionVerification;

    import flash.events.Event;

    public class SuiteRunnerTest {

        [Inject]
        public var async:IAsync;

        [Inject]
        public var suiteRunner:SuiteRunner;

        [Inject]
        public var runnerResult:Result;

        public function testRunTriggersCompleteEvent():void {
            suiteRunner.addEventListener(Event.COMPLETE, async.add(checkResultWasNotSuccessful));
            suiteRunner.run(DoubleFailSuite);
        }
        
        private function checkResultWasNotSuccessful(event:Event):void {
            assertFalse(runnerResult.wasSuccessful);
        }

        [Test]
        public function testCanHandATestToSuiteRunner():void {
            suiteRunner.addEventListener(Event.COMPLETE, async.add());
            suiteRunner.run(InjectionVerification);
            assertFalse(runnerResult.wasSuccessful);
        }
    }
}


