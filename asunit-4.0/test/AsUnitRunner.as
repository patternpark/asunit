package {

    import asunit.runners.AsUnitTextCore;

    import flash.display.Sprite;

	public class AsUnitRunner extends Sprite {
	    
        private var core:AsUnitTextCore;

        public function AsUnitRunner() {
            core = new AsUnitTextCore();

            // Uncomment to turn off the perf report:
            //core.displayPerformanceDetails = false;

            core.start(AllTests, null, this);
        }
    }
}

