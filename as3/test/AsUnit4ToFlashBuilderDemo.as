package {
	import flash.display.MovieClip;
	import asunit4.runners.FlashBuilderRunner;
	import asunit4.support.DoubleNestedSuite;
	
	[SWF(backgroundColor=0x333333)]
	public class AsUnit4ToFlashBuilderDemo extends MovieClip {
		
		private var runner:FlashBuilderRunner;
		
		public function AsUnit4ToFlashBuilderDemo() {
			runner = new FlashBuilderRunner();
			runner.start(DoubleNestedSuite);
		}
	}
}
