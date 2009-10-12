package asunit4.async {
	import asunit.framework.TestSuite;
	import asunit4.async.AsyncTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new asunit4.async.AsyncTest());
		}
	}
}
