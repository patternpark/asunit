package asunit4.runners {

    import asunit.framework.TestCase;

    import asunit4.framework.Result;
    import asunit4.support.IgnoredMethod;

    import flash.events.Event;

    public class TestRunnerIgnoredMethodTest extends TestCase {

        private var ignoredTest:Class;
        private var runner:TestRunner;
        private var runnerResult:Result;
        
        public function TestRunnerIgnoredMethodTest(testMethod:String = null) {
            super(testMethod);
        }

        protected override function setUp():void {
            super.setUp();
            ignoredTest  = IgnoredMethod;
            runner       = new TestRunner();
            runnerResult = new Result();
        }

        protected override function tearDown():void {
            super.tearDown();
            ignoredTest  = null;
            runner       = null;
            runnerResult = null;
        }

        public function testRunWithIgnoredMethod():void {
            runner.addEventListener(Event.COMPLETE, addAsync(checkResultHasOneIgnoredMethod, 100));
            runner.run(ignoredTest, runnerResult);
        }
        
        private function checkResultHasOneIgnoredMethod(e:Event):void {
            assertFalse('runnerResult.failureEncountered', runnerResult.failureEncountered);
            assertEquals('one ignored test in result', 1, runnerResult.ignoredTests.length);
        }
    }
}

