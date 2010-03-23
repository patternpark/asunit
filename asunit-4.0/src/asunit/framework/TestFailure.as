package asunit.framework {
    import asunit.errors.AssertionFailedError;
	import flash.utils.getQualifiedClassName;
	import asunit.framework.ITestFailure;

    /**
     * A <code>TestFailure</code> collects a failed test together with
     * the caught exception.
     * @see Result
     */
    public class TestFailure implements ITestFailure {
        protected var _failedTest:Object;
        protected var _failedMethod:String;
        protected var _thrownException:Error;

        /**
         * Constructs a TestFailure with the given test and exception.
         */
        public function TestFailure(failedTest:Object, methodName:String, thrownException:Error) {
            _failedTest = failedTest;
            _failedMethod = methodName;
            _thrownException = thrownException;
        }

        public function get failedFeature():String {
            return getQualifiedClassName(_failedTest) + '.' + _failedMethod;
        }

        public function get failedMethod():String {
            return _failedMethod;
        }
		
		public function set failedMethod(value:String):void {
			_failedMethod = value;
		}

        /**
         * Gets the failed test case.
         */
        public function get failedTest():Object {
            return _failedTest;
        }
        /**
         * Gets the thrown exception.
         */
        public function get thrownException():Error {
            return _thrownException;
        }
        /**
         * Returns a short description of the failure.
         */
        public function toString():String {
            return '[TestFailure ' + failedMethod + ']';
        }

        public function get exceptionMessage():String {
            return thrownException.message;
        }

        public function get isFailure():Boolean {
            return thrownException is AssertionFailedError;
        }
		
    }
}
