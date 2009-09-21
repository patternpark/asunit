package asunit.framework {
    import asunit.errors.AssertionFailedError;
    import asunit.errors.InstanceNotFoundError;

    /**
     * A <code>TestResult</code> collects the results of executing
     * a test case. It is an instance of the Collecting Parameter pattern.
     * The test framework distinguishes between <i>failures</i> and <i>errors</i>.
     * A failure is anticipated and checked for with assertions. Errors are
     * unanticipated problems like an <code>ArrayIndexOutOfBoundsException</code>.
     *
     * @see Test
     */
    public class FreeTestResult implements ITestResult {
        protected var _failures:Array;
        protected var _errors:Array;

        public function FreeTestResult() {
			_failures	= new Array();
			_errors		= new Array();
        }
		
        /**
         * Adds an error to the list of errors. The passed in exception
         * caused the error.
         */
        //public function addError(test:Object, methodName:String, error:Error):void {
        //public function addError(errorFailure:FreeTestFailure):void {
            //_errors.push(errorFailure);
        //}
		
        /**
         * Adds a failure to the list of failures. The passed in exception
         * caused the failure.
         */
        //public function addFailure(test:Object, methodName:String, error:AssertionFailedError):void {
        public function addFailure(failure:FreeTestFailure):void {
			if (failure.isFailure)
				_failures.push(failure);
			else
				_errors.push(failure);
        }
		
        /**
         * Gets the number of detected errors.
         */
        public function get errorCount():uint {
            return _errors.length;
        }
		
        /**
         * Returns an Enumeration for the errors
         */
        public function get errors():Array {
            return _errors;
        }
		
        /**
         * Gets the number of detected failures.
         */
        public function get failureCount():uint {
            return _failures.length;
        }
		
        /**
         * Returns an Enumeration for the failures
         */
        public function get failures():Array {
            return _failures;
        }
		
        /**
         * Returns whether the entire test was successful or not.
         */
        public function get wasSuccessful():Boolean {
            return failureCount == 0 && errorCount == 0;
        }
    }
}