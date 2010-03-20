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

        public function test_run_with_ignored_method():void {
            runner.addEventListener(Event.COMPLETE, addAsync(check_Result_has_one_ignored_method, 100));
            runner.run(ignoredTest, runnerResult);
        }
        
        private function check_Result_has_one_ignored_method(e:Event):void {
            assertTrue('runnerResult.wasSuccessful', runnerResult.wasSuccessful);
            assertEquals('one ignored test in result', 1, runnerResult.ignoredTests.length);
        }
    }
}

