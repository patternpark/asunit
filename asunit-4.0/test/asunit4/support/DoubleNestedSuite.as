package asunit4.support {
		
	[Suite]
	public class DoubleNestedSuite {
		// contains two suites
		public var suiteOfTwoSuites:SuiteOfTwoSuites;
		
		// contains a single test
		public var singleErrorSuite:SingleErrorSuite;
		
		// a single test not in a suite
		public var ignoredMethodTest:IgnoredMethod;
	}
}
