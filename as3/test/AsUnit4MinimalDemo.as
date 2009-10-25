package {
	import flash.display.MovieClip;
	import asunit4.runners.MinimalRunner;
	import asunit4.support.DoubleNestedSuite;
	
	[SWF(backgroundColor=0x333333)]
	public class AsUnit4MinimalDemo extends MovieClip {
		
		private var runner:MinimalRunner;
		
		public function AsUnit4MinimalDemo() {
			runner = new MinimalRunner(this);
			runner.start(DoubleNestedSuite);
		}
	}
}
