package asunit4.framework {
    import asunit.errors.AssertionFailedError;
	import asunit4.framework.ITestResult;
	import asunit.framework.ITestFailure;
	import asunit4.framework.ITestSuccess;
	import asunit.framework.TestListener;

    /**
     * A <code>TestResult</code> collects the results of executing
     * a test case. It is an instance of the Collecting Parameter pattern.
     * The test framework distinguishes between <i>failures</i> and <i>errors</i>.
     * A failure is anticipated and checked for with assertions. Errors are
     * unanticipated problems like an <code>ArrayIndexOutOfBoundsException</code>.
     *
     * @see Test
     */
    public class TestResult implements ITestResult {
		public var runTime:Number;
		
        protected var _failures:Array;
        protected var _errors:Array;
        protected var _successes:Array;
		protected var _listeners:Array;
		protected var _runCount:uint = 0;

        public function TestResult() {
			_failures	= [];
			_errors		= [];
			_successes	= [];
			_listeners  = [];
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
				
			if (_listeners[0])
				_listeners[0].addError(failure);
        }
		
        public function addSuccess(success:ITestSuccess):void {
			_successes.push(success);
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
		
        public function get successes():Array {
            return _successes;
        }
		
		public function get runCount():uint {
			return _runCount;
		}
		
		public function set runCount(value:uint):void {
			_runCount = value;
		}
		
        /**
         * Returns whether the entire test was successful or not.
         */
        public function get wasSuccessful():Boolean {
            return failureCount == 0 && errorCount == 0;
        }
		
        /**
         * Registers a TestListener
         */
		//TODO: use EventDispatcher instead
        public function addListener(listener:TestListener):void {
            _listeners.push(listener);
        }
		
        /**
         * Unregisters a TestListener
         */
        public function removeListener(listener:TestListener):void {
			//TODO: use _listener.indexOf()
            var len:uint = _listeners.length;
            for(var i:uint; i < len; i++) {
                if(_listeners[i] == listener) {
                    _listeners.splice(i, 1);
                    return;
                }
            }
            //throw new InstanceNotFoundError("removeListener called without listener in list");
        }
		
		
    }
}
