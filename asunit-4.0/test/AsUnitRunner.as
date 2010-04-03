package {

    import asunit.core.TextCore;

    import flash.display.Sprite;

	public class AsUnitRunner extends Sprite {
	    
        private var core:TextCore;

        public function AsUnitRunner() {
            core = new TextCore();

            // Uncomment to turn off the perf report:
            //core.displayPerformanceDetails = false;

            core.start(AllTests, null, this);
        }
    }
}

