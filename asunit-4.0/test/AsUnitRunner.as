package {

    import p2.reflect.Reflection;
    import asunit.textui.TestRunner;
    import asunit4.runners.BaseRunnerTest;
    import asunit4.framework.SuiteIteratorTest;
    import asunit4.runners.SuiteRunnerTest;
    
    public class AsUnitRunner extends TestRunner {

        public function AsUnitRunner() {
            start(AllTests, null, TestRunner.SHOW_TRACE);
        }
    }
}

