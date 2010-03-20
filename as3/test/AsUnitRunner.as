package {
    import asunit.textui.TestRunner;
    
    import asunit4.runners.TestRunnerTest;

    public class AsUnitRunner extends TestRunner {

        public function AsUnitRunner() {
            start(AllTests, null, TestRunner.SHOW_TRACE);
            //start(TestRunnerTest, 'testInjectTypes', TestRunner.SHOW_TRACE);
        }
    }
}
