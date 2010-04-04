package asunit.framework {

    import asunit.errors.UsageError;
	import asunit.framework.ITestFailure;

	import flash.events.EventDispatcher;
    import flash.utils.Dictionary;

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

		protected var _runCount:uint = 0;
		protected var _runTime:Number;
        protected var _errors:Array;
        protected var _failures:Array;
        protected var _ignoredTests:Array;
        protected var _successes:Array;
        protected var _warnings:Array;

		protected var listeners:Array;
        protected var runComplete:Boolean;
        protected var knownTests:Dictionary;

        public function Result() {
			_errors       = [];
			_failures     = [];
			_ignoredTests = [];
			_successes    = [];
            _warnings     = [];
			listeners     = [];
            knownTests    = new Dictionary();
        }
		
        public function get errors():Array { return _errors; }
		
        /**
         * Gets the number of detected errors.
         */
        public function get errorCount():uint { return _errors.length; }
		
        /**
         *
         */
        public function get failures():Array { return _failures; }
		
        /**
         * Gets the number of detected failures.
         */
        public function get failureCount():uint { return _failures.length; }
		
        public function get successes():Array { return _successes; }
		
        public function get successCount():uint { return _successes.length; }

        public function get warnings():Array { return _warnings; }

        public function get ignoredTests():Array { return _ignoredTests; }
		
        public function get ignoredTestCount():uint { return _ignoredTests.length; }
		
		public function get runCount():uint {
			return errorCount + failureCount + successCount;
		}
		
		public function get runTime():Number { return _runTime; }
		public function set runTime(value:Number):void { _runTime = value; }

        public function shouldRunTest(testClass:Class):Boolean {
            if(!knownTests[testClass]) {
                knownTests[testClass] = testClass;
                return true;
            }
            return false;
        }
		
        public function addObserver(observer:TestObserver):void {
            if(!(observer is IRunListener)) {
                throw new UsageError("Result.addObserver called with an instance that wasn't an IRunListener. This should work soon, but doesn't yet...");
            }
            addListener(IRunListener(observer));
        }
		
		public function addListener(listener:IRunListener):void {
			if (listeners.indexOf(listener) >= 0) return;
			listeners.push(listener);
		}
		
		public function removeListener(listener:IRunListener):void {
			listeners.splice(listeners.indexOf(listener), 1);
		}
		
		public function onRunStarted():void {
			for each (var listener:IRunListener in listeners) {
				listener.onRunStarted();
			}
		}
		
		public function onRunCompleted(result:IResult):void {
            runComplete = true;
			for each (var listener:IRunListener in listeners) {
				listener.onRunCompleted(this);
			}
		}
	
		public function onTestStarted(test:Object):void {
			for each (var listener:IRunListener in listeners) {
				listener.onTestStarted(test);
			}
		}
		
		public function onTestCompleted(test:Object):void {
			for each (var listener:IRunListener in listeners) {
				listener.onTestCompleted(test);
			}
		}
		
        /**
         * Adds a failure to the list of failures. The passed in exception
         * caused the failure.
         */
        public function onTestFailure(failure:ITestFailure):void {
			if (failure.isFailure)
				_failures.push(failure);
			else
				_errors.push(failure);
				
			for each (var listener:IRunListener in listeners) {
				listener.onTestFailure(failure);
			}
        }
		
        public function onTestSuccess(success:ITestSuccess):void {
			_successes.push(success);
			
			for each (var listener:IRunListener in listeners) {
				listener.onTestSuccess(success);
			}
		}
		
        public function onTestIgnored(method:Method):void {
			_ignoredTests.push(method);
			
			for each (var listener:IRunListener in listeners) {
				listener.onTestIgnored(method);
			}
		}

        public function onWarning(warning:ITestWarning):void {
            _warnings.push(warning);

            for each (var listener:IRunListener in listeners) {
                listener.onWarning(warning);
            }
        }

        /**
         * Returns whether or not we have yet encountered a failure or error.
         * Will be accurate when checked at any time during test run.
         */
        public function get failureEncountered():Boolean {
            return (failureCount > 0 || errorCount > 0);
        }

        /**
         * Returns whether or not the entire test was successful.
         * Will only return true after +onRunCompleted+ called.
         */
        public function get wasSuccessful():Boolean {
            return (runComplete && !failureEncountered);
        }
		
    }
}
