package asunit.framework.async {
	import asunit.framework.TestSuite;
	import asunit.framework.async.AsyncTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new asunit.framework.async.AsyncTest());
		}
	}
}
