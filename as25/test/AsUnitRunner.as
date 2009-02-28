import asunit.textui.TestRunner;
import AllTests;

class AsUnitRunner extends TestRunner {

	public static function main(container:MovieClip) : Void {
		var tR = new AsUnitRunner();
	}

	public function AsUnitRunner() {
		start(AllTests);
	}
}