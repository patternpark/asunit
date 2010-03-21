import asunit.framework.TestSuite;
import asunit.textui.TestRunnerTest;

class asunit.textui.AllTests extends TestSuite {

	public function AllTests() {
		addTest(new asunit.textui.TestRunnerTest());
	}
}
