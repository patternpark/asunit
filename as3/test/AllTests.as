package {
	import asunit.framework.TestSuite;
	import asunit.AllTests;
	import asunit4.AllTests;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new asunit.AllTests());
			addTest(new asunit4.AllTests());
		}
	}
}
