package asunit4 {
	import asunit.framework.TestSuite;
	import asunit4.async.AllTests;
	import asunit4.FreeRunnerAsyncMethodTest;
	import asunit4.FreeRunnerErrorMethodTest;
	import asunit4.FreeRunnerExpectsErrorTest;
	import asunit4.FreeRunnerTest;
	import asunit4.FreeSuiteTest;
	import asunit4.SuiteIteratorTest;
	import asunit4.TestMethodIteratorMultiMethodTest;
	import asunit4.TestMethodIteratorSingleMethodTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new asunit4.async.AllTests());
			addTest(new asunit4.FreeRunnerAsyncMethodTest());
			addTest(new asunit4.FreeRunnerErrorMethodTest());
			addTest(new asunit4.FreeRunnerExpectsErrorTest());
			addTest(new asunit4.FreeRunnerTest());
			addTest(new asunit4.FreeSuiteTest());
			addTest(new asunit4.SuiteIteratorTest());
			addTest(new asunit4.TestMethodIteratorMultiMethodTest());
			addTest(new asunit4.TestMethodIteratorSingleMethodTest());
		}
	}
}
