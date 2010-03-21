package asunit4.ui {
	import asunit4.ui.FlashBuilderRunnerUI;
	import asunit4.support.DoubleNestedSuite;
	
	public class FlashBuilderExample extends FlashBuilderRunnerUI {
		
		public function FlashBuilderExample() {
			
			// The projectName argument is optional and defaults to empty quotes.
			// Flash Builder will complain if you specify a projectName not in workspace.
			
			run(DoubleNestedSuite /*, "FlashBuilderProjectName" */);
		}
	}
}
