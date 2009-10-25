package asunit4.examples {
	import asunit4.ui.FlashDevelopRunnerUI;
	import asunit4.support.DoubleNestedSuite;
	
	public class AsUnit4ToFlashDevelopExample extends FlashDevelopRunnerUI {
		
		public function AsUnit4ToFlashDevelopExample() {
			start(DoubleNestedSuite);
		}
	}
}
