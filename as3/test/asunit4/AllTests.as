package asunit4 {
	import asunit.framework.TestSuite;
	import asunit4.async.AllTests;
	import asunit4.runners.TestRunnerAsyncMethodTest;
	import asunit4.runners.TestRunnerErrorMethodTest;
	import asunit4.runners.TestRunnerExpectsErrorTest;
	import asunit4.runners.TestRunnerTest;
	import asunit4.NestedSuiteIteratorTest;
	import asunit4.SuiteIteratorTest;
	import asunit4.runners.SuiteRunnerTest;
	import asunit4.TestMethodIteratorMultiMethodTest;
	import asunit4.TestMethodIteratorSingleMethodTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new asunit4.async.AllTests());
			addTest(new asunit4.runners.TestRunnerAsyncMethodTest());
			addTest(new asunit4.runners.TestRunnerErrorMethodTest());
			addTest(new asunit4.runners.TestRunnerExpectsErrorTest());
			addTest(new asunit4.runners.TestRunnerTest());
			addTest(new asunit4.NestedSuiteIteratorTest());
			addTest(new asunit4.SuiteIteratorTest());
			addTest(new asunit4.runners.SuiteRunnerTest());
			addTest(new asunit4.TestMethodIteratorMultiMethodTest());
			addTest(new asunit4.TestMethodIteratorSingleMethodTest());
		}
	}
}
