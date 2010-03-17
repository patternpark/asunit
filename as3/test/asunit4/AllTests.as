package asunit4 {
	import asunit.framework.TestSuite;
	import asunit4.async.AllTests;
	import asunit4.framework.AllTests;
	import asunit4.runners.AllTests;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new asunit4.async.AllTests());
			addTest(new asunit4.framework.AllTests());
			addTest(new asunit4.runners.AllTests());
		}
	}
}
