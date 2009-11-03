package asunit4.runners {
	import asunit.framework.TestSuite;
	import asunit4.runners.SuiteRunnerTest;
	import asunit4.runners.TestRunnerAsyncMethodTest;
	import asunit4.runners.TestRunnerErrorMethodTest;
	import asunit4.runners.TestRunnerExpectsErrorTest;
	import asunit4.runners.TestRunnerIgnoredMethodTest;
	import asunit4.runners.TestRunnerTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new asunit4.runners.SuiteRunnerTest());
			addTest(new asunit4.runners.TestRunnerAsyncMethodTest());
			addTest(new asunit4.runners.TestRunnerErrorMethodTest());
			addTest(new asunit4.runners.TestRunnerExpectsErrorTest());
			addTest(new asunit4.runners.TestRunnerIgnoredMethodTest());
			addTest(new asunit4.runners.TestRunnerTest());
		}
	}
}
