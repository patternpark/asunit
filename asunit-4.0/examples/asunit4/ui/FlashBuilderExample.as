package asunit.ui {
	import asunit.ui.FlashBuilderRunnerUI;
	import asunit.support.DoubleNestedSuite;
	
	public class FlashBuilderExample extends FlashBuilderRunnerUI {
		
		public function FlashBuilderExample() {
			
			// The projectName argument is optional and defaults to empty quotes.
			// Flash Builder will complain if you specify a projectName not in workspace.
			
			run(DoubleNestedSuite /*, "FlashBuilderProjectName" */);
		}
	}
}
