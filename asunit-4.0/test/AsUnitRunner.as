package {

    import asunit.core.TextCore;
    import flash.display.MovieClip;

	public class AsUnitRunner extends MovieClip {
	    
        private var core:TextCore;

        public function AsUnitRunner() {
            core = new TextCore();
            core.start(AllTests, null, this);
        }
    }
}