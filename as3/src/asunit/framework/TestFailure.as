package asunit.framework {
    import asunit.errors.AssertionFailedError;

    /**
     * A <code>TestFailure</code> collects a failed test together with
     * the caught exception.
     * @see TestResult
     */
    public class TestFailure implements ITestFailure {
        protected var fFailedTest:Object;
        protected var fFailedTestMethod:String;
        protected var fThrownException:Error;

        /**
         * Constructs a TestFailure with the given test and exception.
         */
        public function TestFailure(failedTest:Object, thrownException:Error) {
            fFailedTest = failedTest;
            fFailedTestMethod = failedTest.getCurrentMethod();
            fThrownException = thrownException;
        }

        public function get failedFeature():String {
            return failedTest.getName() + '.' + fFailedTestMethod;
        }

        public function get failedMethod():String {
            return fFailedTestMethod;
        }

        /**
         * Gets the failed test case.
         */
        public function get failedTest():Object {
            return fFailedTest;
        }
        /**
         * Gets the thrown exception.
         */
        public function get thrownException():Error {
            return fThrownException;
        }
        /**
         * Returns a short description of the failure.
         */
        public function toString():String {
            return "";
        }

        public function get exceptionMessage():String {
            return thrownException.message;
        }

        public function get isFailure():Boolean {
            return thrownException is AssertionFailedError;
        }
    }
}
