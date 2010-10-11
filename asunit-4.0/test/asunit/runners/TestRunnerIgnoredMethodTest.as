package asunit.runners {

    import asunit.framework.TestCase;

    import asunit.support.IgnoredMethod;

    import flash.events.Event;

    public class TestRunnerIgnoredMethodTest extends TestCase {

        private var ignoredTest:Class;
        private var runner:TestRunner;
        
        public function TestRunnerIgnoredMethodTest(testMethod:String = null) {
            super(testMethod);
        }

        protected override function setUp():void {
            super.setUp();
            ignoredTest  = IgnoredMethod;
            runner       = new TestRunner();
        }

        protected override function tearDown():void {
            super.tearDown();
            ignoredTest  = null;
            runner       = null;
        }

        public function testRunWithIgnoredMethod():void {
            runner.addEventListener(Event.COMPLETE, addAsync(checkResultHasOneIgnoredMethod, 100));
            runner.run(ignoredTest);
        }
        
        private function checkResultHasOneIgnoredMethod(e:Event):void {
            assertFalse('runnerResult.failureEncountered', runner.result.failureEncountered);
            assertEquals('one ignored test in result', 1, runner.result.ignoredTests.length);
        }
    }
}

