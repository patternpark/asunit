import asunit.framework.TestSuite;
import asunit.util.ArrayIteratorTest;

class asunit.util.AllTests extends TestSuite {

	public function AllTests() {
		addTest(new asunit.util.ArrayIteratorTest());
	}
}
