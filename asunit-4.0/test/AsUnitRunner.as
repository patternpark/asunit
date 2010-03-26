package {
	import asunit.ui.TextRunnerUI;
	import asunit.runners.LegacyRunner;

	public class AsUnitRunner extends TextRunnerUI {
	    
	    private var legacyRunner:LegacyRunner;

        public function AsUnitRunner() {
            run(AllTests);
        }
    }
}
