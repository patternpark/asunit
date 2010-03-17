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
    public class TestResult implements TestListener, ITestResult {
        protected var _failures:Array;
        protected var _errors:Array;
        protected var _listeners:Array;
        protected var _runCount:uint = 0;
        protected var _stop:Boolean;

        public function TestResult() {
            _failures  = new Array();
            _errors    = new Array();
            _listeners = new Array();
            _runCount  = 0;
            _stop      = false;
        }
		
		
        /**
         * Adds a failure to the list of failures. The passed in exception
         * caused the failure.
         */
        public function addFailure(failure:ITestFailure):void {
			if (failure.isFailure)
				_failures.push(failure);
			else
				_errors.push(failure);
				
            var len:uint = _listeners.length;
            var item:TestListener;
            for(var i:uint; i < len; i++) {
                item = TestListener(_listeners[i]);
                item.addFailure(failure);
            }
        }
        /**
         * Registers a TestListener
         */
        public function addListener(listener:TestListener):void {
            _listeners.push(listener);
        }
        /**
         * Unregisters a TestListener
         */
        public function removeListener(listener:TestListener):void {
            var len:uint = _listeners.length;
            for(var i:uint; i < len; i++) {
                if(_listeners[i] == listener) {
                    _listeners.splice(i, 1);
                    return;
                }
            }
            throw new InstanceNotFoundError("removeListener called without listener in list");
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
         * Runs a TestCase.
         */
        public function run(test:Object):void {
            startTest(test);
            test.runBare();
        }
        /**
         * Gets the number of run tests.
         */
        public function get runCount():uint {
            return _runCount;
        }
		
        public function set runCount(value:uint):void {
            _runCount = value;
        }
		
        /**
         * Checks whether the test run should stop
         */
        public function shouldStop():Boolean {
            return _stop;
        }
        /**
         * Informs the result that a test will be started.
         */
        public function startTest(test:Object):void {
            var count:int = test.countTestCases();
            _runCount += count;

            var len:uint = _listeners.length;
            var item:TestListener;
            for(var i:uint; i < len; i++) {
                item = TestListener(_listeners[i]);
                item.startTest(test);
            }
        }

        public function startTestMethod(test:Object, method:String):void {
            var len:uint = _listeners.length;
            var item:TestListener;
            for(var i:uint; i < len; i++) {
                item = TestListener(_listeners[i]);
                item.startTestMethod(test, method);
            }
        }

        public function endTestMethod(test:Object, method:String):void {
            var len:uint = _listeners.length;
            var item:TestListener;
            for(var i:uint; i < len; i++) {
                item = TestListener(_listeners[i]);
                item.endTestMethod(test, method);
            }
        }

        /**
         * Informs the result that a test was completed.
         */
        public function endTest(test:Object):void {
            var len:uint = _listeners.length;
            var item:TestListener;
            for(var i:uint; i < len; i++) {
                item = TestListener(_listeners[i]);
                item.endTest(test);
            }
        }
        /**
         * Marks that the test run should stop.
         */
        public function stop():void {
            _stop = true;
        }
        /**
         * Returns whether the entire test was successful or not.
         */
        public function get wasSuccessful():Boolean {
            return failureCount == 0 && errorCount == 0;
        }
    }
}
