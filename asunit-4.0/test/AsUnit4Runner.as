package {
    import asunit.framework.AssertTest;
	import asunit.ui.TextRunnerUI;
	import asunit.runners.LegacyRunner;

	public class AsUnit4Runner extends TextRunnerUI {
	    
	    private var legacyRunner:LegacyRunner;

        public function AsUnit4Runner() {
            run(AsUnit4AllTests);
        }
    }
}
