package asunit4.ui {
	import asunit4.ui.MinimalRunnerUI;
	import asunit4.support.DoubleNestedSuite;
	
	public class MinimalExample extends MinimalRunnerUI {
		
		public function MinimalExample() {
			run(DoubleNestedSuite);
		}
	}
}
