package asunit4.examples {
	import asunit4.ui.MinimalRunnerUI;
	import asunit4.support.DoubleNestedSuite;
	
	public class AsUnit4MinimalExample extends MinimalRunnerUI {
		
		public function AsUnit4MinimalExample() {
			start(DoubleNestedSuite);
		}
	}
}
