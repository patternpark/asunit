package asunit4.framework {
	import asunit.framework.TestSuite;
	import asunit4.framework.NestedSuiteIteratorTest;
	import asunit4.framework.SuiteIteratorTest;
	import asunit4.framework.TestIteratorIgnoredMethodTest;
	import asunit4.framework.TestIteratorMethodByNameTest;
	import asunit4.framework.TestIteratorMultiMethodTest;
	import asunit4.framework.TestIteratorOrderedTestMethodTest;
	import asunit4.framework.TestIteratorSingleMethodTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new asunit4.framework.NestedSuiteIteratorTest());
			addTest(new asunit4.framework.SuiteIteratorTest());
			addTest(new asunit4.framework.TestIteratorIgnoredMethodTest());
			addTest(new asunit4.framework.TestIteratorMethodByNameTest());
			addTest(new asunit4.framework.TestIteratorMultiMethodTest());
			addTest(new asunit4.framework.TestIteratorOrderedTestMethodTest());
			addTest(new asunit4.framework.TestIteratorSingleMethodTest());
		}
	}
}
