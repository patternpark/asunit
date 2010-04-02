package asunit.framework {
    
    public class CallbackBridge implements MessageBridge, IRunListener {

        private var listeners:Array;

        public function CallbackBridge() {
            listeners = [];
        }

        public function get length():int {
            return listeners.length;
        }

        public function addListener(listener:IRunListener):void {
            listeners.push(listener);
        }

		public function onRunStarted():void {
            listeners.forEach(function(listener:IRunListener, index:int, items:Array):void {
                listener.onRunStarted();
            });
        }

		public function onRunCompleted(result:IResult):void {
            listeners.forEach(function(listener:IRunListener, index:int, items:Array):void {
                listener.onRunCompleted(result);
            });
        }

		public function onTestStarted(test:Object):void {
            listeners.forEach(function(listener:IRunListener, index:int, items:Array):void {
                listener.onTestStarted(test);
            });
        }

		public function onTestCompleted(test:Object):void {
            listeners.forEach(function(listener:IRunListener, index:int, items:Array):void {
                listener.onTestCompleted(test);
            });
        }

		public function onTestFailure(failure:ITestFailure):void {
            listeners.forEach(function(listener:IRunListener, index:int, items:Array):void {
                listener.onTestFailure(failure);
            });
        }

		public function onTestSuccess(success:ITestSuccess):void {
            listeners.forEach(function(listener:IRunListener, index:int, items:Array):void {
                listener.onTestSuccess(success);
            });
        }

		public function onTestIgnored(method:Method):void {
            listeners.forEach(function(listener:IRunListener, index:int, items:Array):void {
                listener.onTestIgnored(method);
            });
        }

        public function onWarning(warning:ITestWarning):void {
            listeners.forEach(function(listener:IRunListener, index:int, items:Array):void {
                listener.onWarning(warning);
            });
        }
    }
}

