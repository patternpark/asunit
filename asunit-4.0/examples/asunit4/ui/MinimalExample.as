package asunit.ui {
	import asunit.ui.TextRunnerUI;
	import asunit.support.DoubleNestedSuite;
	
	public class MinimalExample extends TextRunnerUI {
		
		public function MinimalExample() {
			run(DoubleNestedSuite);
		}
	}
}
