package {

    import asunit.core.TextCore;
    import flash.display.MovieClip;

	[SWF(width="1024", height="640", backgroundColor="#000000", frameRate="61")]
	public class AsUnitRunner extends MovieClip {
	    
        private var core:TextCore;

        public function AsUnitRunner() {
            core = new TextCore();
			core.textPrinter.hideLocalPaths = true;
            core.start(AllTests, null, this);
        }
    }
}