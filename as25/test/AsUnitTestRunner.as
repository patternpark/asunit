import asunit.textui.TestRunner;

class AsUnitTestRunner extends TestRunner {

	public static function main(container:MovieClip) : Void {
		var tR = new AsUnitTestRunner();
	}
	public function AsUnitTestRunner() {
		start(AllTests);
	}
}