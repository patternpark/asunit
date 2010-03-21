package asunit4.ui {
	import asunit4.ui.FlashDevelopRunnerUI;
	import asunit4.support.DoubleNestedSuite;
	
	public class FlashDevelopExample extends FlashDevelopRunnerUI {
		
		public function FlashDevelopExample() {
			run(DoubleNestedSuite);
		}
	}
}
