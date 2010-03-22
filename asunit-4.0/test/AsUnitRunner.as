package {
	import asunit.textui.TestRunner;

	public class AsUnitRunner extends TestRunner {

        public function AsUnitRunner() {
            start(AllTests, null, TestRunner.SHOW_TRACE);
        }
    }
}
