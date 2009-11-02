package asunit4.framework {
    import asunit.errors.AssertionFailedError;
	import asunit4.framework.IResult;
	import asunit.framework.ITestFailure;
	import asunit4.framework.ITestSuccess;
	import asunit.framework.TestListener;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

    /**
     * A <code>Result</code> collects the results of executing
     * a test case. It is an instance of the Collecting Parameter pattern.
     * The test framework distinguishes between <i>failures</i> and <i>errors</i>.
     * A failure is anticipated and checked for with assertions. Errors are
     * unanticipated problems like an <code>ArrayIndexOutOfBoundsException</code>.
     *
     * @see Test
     */
    public class Result extends EventDispatcher implements IResult {
		public var runTime:Number;
		
        protected var _failures:Array;
        protected var _errors:Array;
        protected var _successes:Array;
		protected var _runCount:uint = 0;
		protected var listeners:Array;

        public function Result() {
			_failures	= [];
			_errors		= [];
			_successes	= [];
			listeners	= [];
        }
		
		public function addListener(listener:IRunListener):void {
			if (listeners.indexOf(listener) >= 0) return;
			listeners.push(listener);
		}
		
		public function removeListener(listener:IRunListener):void {
			listeners.splice(listeners.indexOf(listener), 1);
		}
		
		public function startRun():void {
			trace('Result.startRun()');
			for each (var listener:IRunListener in listeners) {
				listener.onRunStarted();
			}
		}
		
		public function endRun():void {
			trace('Result.endRun()');
			for each (var listener:IRunListener in listeners) {
				listener.onRunCompleted(this);
			}
		}
		
        /**
         * Adds a failure to the list of failures. The passed in exception
         * caused the failure.
         */
        public function addFailure(failure:ITestFailure):void {
			trace('Result.addFailure() - ' + failure);
			if (failure.isFailure)
				_failures.push(failure);
			else
				_errors.push(failure);
				
			for each (var listener:IRunListener in listeners) {
				listener.onTestFailure(failure);
			}
        }
		
        public function addSuccess(success:ITestSuccess):void {
			_successes.push(success);
			
			for each (var listener:IRunListener in listeners) {
				listener.onTestSuccess(success);
			}
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
			return NaN;
			//TODO: write test for this
			//return errorCount + failureCount + _successes.length;
		}
		
        /**
         * Returns whether the entire test was successful or not.
         */
        public function get wasSuccessful():Boolean {
            return failureCount == 0 && errorCount == 0;
        }
		
		
    }
}
