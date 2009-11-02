package asunit4.examples {
	import asunit4.ui.FlashBuilderRunnerUI;
	import asunit4.support.DoubleNestedSuite;
	
	public class AsUnit4ToFlashBuilderExample extends FlashBuilderRunnerUI {
		
		public function AsUnit4ToFlashBuilderExample() {
			run(DoubleNestedSuite);
		}
	}
}
