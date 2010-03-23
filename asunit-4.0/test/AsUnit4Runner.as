package {
    import asunit.framework.AssertTest;
	import asunit.ui.TextRunnerUI;

	public class AsUnit4Runner extends TextRunnerUI {

        public function AsUnit4Runner() {

            run(AssertTest);
        }
    }
}
