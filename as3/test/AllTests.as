package {
	/**
	 * This file has been automatically created using
	 * #!/usr/bin/ruby script/generate suite
	 * If you modify it and run this script, your
	 * modifications will be lost!
	 */

	import asunit.framework.TestSuite;
	import asunit.framework.AssertEqualsArraysIgnoringOrderTest;
	import asunit.framework.AssertEqualsArraysTest;
	import asunit.framework.AssertTest;
	import asunit.framework.AssertThrowsTest;
	import asunit.framework.AsyncFailureTest;
	import asunit.framework.AsyncMethodTest;
	import asunit.framework.TestCaseTest;
	import asunit.framework.TestFailureTest;
	import asunit.framework.VisualTestCaseTest;
	import asunit.textui.TestRunnerTest;
	import asunit.util.ArrayIteratorTest;
	import asunit4.async.AsyncTest;
	import asunit4.async.ProceedOnEventTest;
	import asunit4.framework.NestedSuiteIteratorTest;
	import asunit4.framework.ResultTest;
	import asunit4.framework.SuiteIteratorTest;
	import asunit4.framework.TestIteratorIgnoredMethodTest;
	import asunit4.framework.TestIteratorMethodByNameTest;
	import asunit4.framework.TestIteratorMultiMethodTest;
	import asunit4.framework.TestIteratorOrderedTestMethodTest;
	import asunit4.framework.TestIteratorSingleMethodTest;
	import asunit4.printers.TextPrinterTest;
	import asunit4.runners.SuiteRunnerTest;
	import asunit4.runners.TestRunnerAsyncMethodTest;
	import asunit4.runners.TestRunnerErrorMethodTest;
	import asunit4.runners.TestRunnerExpectsErrorTest;
	import asunit4.runners.TestRunnerIgnoredMethodTest;
	import asunit4.runners.TestRunnerTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new asunit.framework.AssertEqualsArraysIgnoringOrderTest());
			addTest(new asunit.framework.AssertEqualsArraysTest());
			addTest(new asunit.framework.AssertTest());
			addTest(new asunit.framework.AssertThrowsTest());
			addTest(new asunit.framework.AsyncFailureTest());
			addTest(new asunit.framework.AsyncMethodTest());
			addTest(new asunit.framework.TestCaseTest());
			addTest(new asunit.framework.TestFailureTest());
			addTest(new asunit.framework.VisualTestCaseTest());
			addTest(new asunit.textui.TestRunnerTest());
			addTest(new asunit.util.ArrayIteratorTest());
			addTest(new asunit4.async.AsyncTest());
			addTest(new asunit4.async.ProceedOnEventTest());
			addTest(new asunit4.framework.NestedSuiteIteratorTest());
			addTest(new asunit4.framework.ResultTest());
			addTest(new asunit4.framework.SuiteIteratorTest());
			addTest(new asunit4.framework.TestIteratorIgnoredMethodTest());
			addTest(new asunit4.framework.TestIteratorMethodByNameTest());
			addTest(new asunit4.framework.TestIteratorMultiMethodTest());
			addTest(new asunit4.framework.TestIteratorOrderedTestMethodTest());
			addTest(new asunit4.framework.TestIteratorSingleMethodTest());
			addTest(new asunit4.printers.TextPrinterTest());
			addTest(new asunit4.runners.SuiteRunnerTest());
			addTest(new asunit4.runners.TestRunnerAsyncMethodTest());
			addTest(new asunit4.runners.TestRunnerErrorMethodTest());
			addTest(new asunit4.runners.TestRunnerExpectsErrorTest());
			addTest(new asunit4.runners.TestRunnerIgnoredMethodTest());
			addTest(new asunit4.runners.TestRunnerTest());
		}
	}
}
