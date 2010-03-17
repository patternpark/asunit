package asunit4.async {
	import asunit.framework.TestSuite;
	import asunit4.async.AsyncTest;
	import asunit4.async.ProceedOnEventTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new asunit4.async.AsyncTest());
			addTest(new asunit4.async.ProceedOnEventTest());
		}
	}
}
