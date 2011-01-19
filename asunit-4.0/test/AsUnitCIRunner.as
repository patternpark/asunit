package {

	import asunit.core.FlexUnitCICore;
	import asunit.core.TextCore;

	import flash.display.MovieClip;

	[SWF(width="1024", height="640", backgroundColor="#000000", frameRate="61")]
	public class AsUnitCIRunner extends MovieClip {
	    
        private var core:TextCore;

        public function AsUnitCIRunner() {
            core = new FlexUnitCICore();
            core.start(AllTests, null, this);
        }
    }
}