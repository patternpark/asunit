package asunit4.support {
		
	[Suite]
	[RunWith("asunit4.SuiteRunner")]
	public class SuiteOfTwoSuites {
		public var singleSuccessSuite:SingleSuccessSuite;
		public var doubleFailSuite:DoubleFailSuite;
	}
}
