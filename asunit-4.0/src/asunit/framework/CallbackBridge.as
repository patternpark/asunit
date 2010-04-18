package asunit.framework {
    
    public class CallbackBridge implements IResult {
	
        private var listeners:Array;
		
		[Inject]
	 	public var model:Result;

        public function CallbackBridge() {
			initialize();
        }
		
		protected function initialize():void
		{
			listeners = [];
			model = new Result();
		}
		
        public function get length():int {
            return listeners.length;
        }

		public function onRunStarted():void {
			model.onRunStarted();
            listeners.forEach(function(listener:IRunListener, index:int, items:Array):void {
                listener.onRunStarted();
            });
        }

		public function onRunCompleted(result:IResult):void {
			model.onRunCompleted(result);
            listeners.forEach(function(listener:IRunListener, index:int, items:Array):void {
                listener.onRunCompleted(result);
            });
        }

		public function onTestStarted(test:Object):void {
			model.onTestStarted(test);
            listeners.forEach(function(listener:IRunListener, index:int, items:Array):void {
                listener.onTestStarted(test);
            });
        }

		public function onTestCompleted(test:Object):void {
			model.onTestCompleted(test);
            listeners.forEach(function(listener:IRunListener, index:int, items:Array):void {
                listener.onTestCompleted(test);
            });
        }

		public function onTestFailure(failure:ITestFailure):void {
			model.onTestFailure(failure);
            listeners.forEach(function(listener:IRunListener, index:int, items:Array):void {
                listener.onTestFailure(failure);
            });
        }

		public function onTestSuccess(success:ITestSuccess):void {
			model.onTestSuccess(success);
            listeners.forEach(function(listener:IRunListener, index:int, items:Array):void {
                listener.onTestSuccess(success);
            });
        }

		public function onTestIgnored(method:Method):void {
			model.onTestIgnored(method);
            listeners.forEach(function(listener:IRunListener, index:int, items:Array):void {
                listener.onTestIgnored(method);
            });
        }

        public function onWarning(warning:ITestWarning):void {
			model.onWarning(warning);
            listeners.forEach(function(listener:IRunListener, index:int, items:Array):void {
                listener.onWarning(warning);
            });
        }

		//---------------------------------------
		// IResult Implementation
		//---------------------------------------

		public function get errors():Array
		{
			return model.errors;
		}

		public function get errorCount():uint
		{
			return model.errorCount;
		}

		public function get failures():Array
		{
			return model.failures;
		}

		public function get failureCount():uint
		{
			return model.failureCount;
		}

		public function get successes():Array
		{
			return model.successes;
		}

		public function get successCount():uint
		{
			return model.successCount;
		}

		public function get warnings():Array
		{
			return model.warnings;
		}

		public function get ignoredTests():Array
		{
			return model.ignoredTests;
		}

		public function get ignoredTestCount():uint
		{
			return model.ignoredTestCount;
		}

		public function get runCount():uint
		{
			return model.runCount;
		}

		public function get failureEncountered():Boolean
		{
			return model.failureEncountered;
		}

		public function get wasSuccessful():Boolean
		{
			return model.wasSuccessful;
		}

		public function get runTime():Number
		{
			return model.runTime;
		}

		public function set runTime(value:Number):void
		{
			model.runTime = value;
		}

		public function addListener(listener:IRunListener):void
		{
			model.addListener(listener);
			listeners.push(listener);
		}

		public function removeListener(listener:IRunListener):void
		{
			model.removeListener(listener);
		}

		public function addObserver(observer:TestObserver):void
		{
			model.addObserver(observer);
		}

		public function shouldRunTest(testClass:Class):Boolean
		{
			return model.shouldRunTest(testClass);
		}
    }
}