package {

    import asunit.textui.TestRunner;
    import asunit4.runners.BaseRunnerTest;
    
    public class AsUnitRunner extends TestRunner {

        public function AsUnitRunner() {
            //start(AllTests, null, TestRunner.SHOW_TRACE);
            start(BaseRunnerTest, 'testRunWith', TestRunner.SHOW_TRACE);
        }
    }
}

