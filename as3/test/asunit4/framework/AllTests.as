package asunit4.framework {
	import asunit.framework.TestSuite;
	import asunit4.framework.NestedSuiteIteratorTest;
	import asunit4.framework.SuiteIteratorTest;
	import asunit4.framework.TestMethodIteratorMultiMethodTest;
	import asunit4.framework.TestMethodIteratorSingleMethodTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new asunit4.framework.NestedSuiteIteratorTest());
			addTest(new asunit4.framework.SuiteIteratorTest());
			addTest(new asunit4.framework.TestMethodIteratorMultiMethodTest());
			addTest(new asunit4.framework.TestMethodIteratorSingleMethodTest());
		}
	}
}
