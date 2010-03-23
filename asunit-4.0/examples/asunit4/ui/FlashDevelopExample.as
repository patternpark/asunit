package asunit.ui {
	import asunit.ui.FlashDevelopRunnerUI;
	import asunit.support.DoubleNestedSuite;
	
	public class FlashDevelopExample extends FlashDevelopRunnerUI {
		
		public function FlashDevelopExample() {
			run(DoubleNestedSuite);
		}
	}
}
