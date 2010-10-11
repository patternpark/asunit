package asunit.support {

    [Suite]
    [RunWith("asunit.support.CustomSuiteRunner")]
    public class SuiteWithCustomRunner {

        public var succeedAssertTrue:SucceedAssertTrue;
		public var singleSuccessSuite:SingleSuccessSuite;
        public var multiMethod:MultiMethod;
    }
}

