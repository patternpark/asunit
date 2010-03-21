package asunit4.ui {
	import asunit4.ui.TextRunnerUI;
	import asunit4.support.DoubleNestedSuite;
	
	public class MinimalExample extends TextRunnerUI {
		
		public function MinimalExample() {
			run(DoubleNestedSuite);
		}
	}
}
