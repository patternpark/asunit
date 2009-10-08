package asunit.framework {
	import asunit.framework.TestSuite;
	import asunit.framework.AssertEqualsArraysIgnoringOrderTest;
	import asunit.framework.AssertEqualsArraysTest;
	import asunit.framework.AssertTest;
	import asunit.framework.async.AllTests;
	import asunit.framework.AsyncFailureTest;
	import asunit.framework.AsyncMethodTest;
	import asunit.framework.FreeRunnerAsyncMethodTest;
	import asunit.framework.FreeRunnerErrorMethodTest;
	import asunit.framework.FreeRunnerTest;
	import asunit.framework.FreeSuiteTest;
	import asunit.framework.TestCaseTest;
	import asunit.framework.TestFailureTest;
	import asunit.framework.TestMethodMetadataTest;
	import asunit.framework.VisualTestCaseTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new asunit.framework.AssertEqualsArraysIgnoringOrderTest());
			addTest(new asunit.framework.AssertEqualsArraysTest());
			addTest(new asunit.framework.AssertTest());
			addTest(new asunit.framework.async.AllTests());
			addTest(new asunit.framework.AsyncFailureTest());
			addTest(new asunit.framework.AsyncMethodTest());
			addTest(new asunit.framework.FreeRunnerAsyncMethodTest());
			addTest(new asunit.framework.FreeRunnerErrorMethodTest());
			addTest(new asunit.framework.FreeRunnerTest());
			addTest(new asunit.framework.FreeSuiteTest());
			addTest(new asunit.framework.TestCaseTest());
			addTest(new asunit.framework.TestFailureTest());
			addTest(new asunit.framework.TestMethodMetadataTest());
			addTest(new asunit.framework.VisualTestCaseTest());
		}
	}
}
