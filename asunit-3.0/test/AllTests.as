package {
	import asunit.framework.TestSuite;
	import asunit.AllTests;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new asunit.AllTests());
		}
	}
}
