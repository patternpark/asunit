package asunit.framework {
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import asunit.framework.async.Async;
	import asunit.framework.async.TimeoutCommand;
	import asunit.runner.ITestRunner;
	import asunit.textui.ResultPrinter;
	import asunit.util.ArrayIterator;
	import asunit.util.Iterator;

	public class FreeRunner extends EventDispatcher implements ITestRunner {
		protected var beforeMethodsList:Iterator;
		protected var testMethodsList:Iterator;
		protected var afterMethodsList:Iterator;
		
		protected var currentTest:Object;
		protected var currentMethod:Method;
		protected var container:DisplayObjectContainer;
		protected var _printer:ResultPrinter;
		protected var startTime:Number;
		protected var timer:Timer;
		protected var result:FreeTestResult;
		private var allMethods:TestMethodIterator;

		public function FreeRunner(container:DisplayObjectContainer = null, printer:ResultPrinter = null) {
			this.container = container;
			result = new FreeTestResult();
			this.printer = printer;
			timer = new Timer(1, 1);
			timer.addEventListener(TimerEvent.TIMER, runNextMethod);
		}
		
		public function get printer():ResultPrinter { return _printer; }
		
        public function set printer(printer:ResultPrinter):void {
			if (_printer && result)
				result.removeListener(_printer);
				
			_printer = printer;
			
			if (result)
				result.addListener(_printer);
        }

		protected function get completed():Boolean {
			return (!allMethods.hasNext() && asyncsCompleted);
			
			//return (!testMethodsList || !testMethodsList.hasNext()) && asyncsCompleted;
		}
		
		public function run(test:Object):void {
			trace('-------------------- run(): ' + test);
			currentTest = test;
			currentMethod = null;
			
			allMethods = new TestMethodIterator(test);
			
			startTime = getTimer();
			if (_printer)
				_printer.startTest(test);
			
			runNextMethod();
		}
		
		protected function runNextMethod(e:TimerEvent = null):void {
			if (completed) {
				onCompleted();
				return;
			}
			
			currentMethod = Method(allMethods.next());
			
			try {
				currentMethod.value();
			}
			catch (error:Error) {
				recordFailure(error);
			}
			
			var commands:Array = Async.instance.getCommandsForTest(currentTest);
			if (commands && commands.length) {
				// find the async commands and listen to them
				for each (var command:TimeoutCommand in commands) {
					command.addEventListener(TimeoutCommand.CALLED, onAsyncMethodCalled);
					command.addEventListener(ErrorEvent.ERROR, onAsyncMethodFailed);
				}
				return;
			}
			
			// Start a new green thread.
			//timer.reset();
			//timer.start();
			
			runNextMethod();
		}
		
		protected function onAsyncMethodCalled(e:Event):void {
			var command:TimeoutCommand = TimeoutCommand(e.currentTarget);
			trace('onAsyncMethodCalled() - command: ' + command);
			
			try {
				command.execute();
			}
			catch (error:Error) {
				recordFailure(error);
			}
			onAsyncMethodCompleted(e);
		}
		
		protected function onAsyncMethodFailed(e:ErrorEvent):void {
			trace('onAsyncMethodFailed() - currentMethod: ' + currentMethod.name + ' - e.error: ' + e.error);
			// The TimeoutCommand doesn't know the method name.
			var testFailure:FreeTestFailure = new FreeTestFailure(currentTest, currentMethod.name, e.error);
			// Record the test failure.
			result.addFailure(testFailure);
				
			onAsyncMethodCompleted(e);
		}
		
		protected function onAsyncMethodCompleted(e:Event):void {
			var command:TimeoutCommand = TimeoutCommand(e.currentTarget);
			
			trace('onAsyncMethodCompleted() - command: ' + command);
			
			command.removeEventListener(TimeoutCommand.CALLED,	onAsyncMethodCompleted);
			command.removeEventListener(ErrorEvent.ERROR,		onAsyncMethodFailed);
			
			runNextMethod();
		}
		
		protected function recordFailure(error:Error):void {
			result.addFailure(new FreeTestFailure(currentTest, currentMethod.name, error));
		}
		
		protected function onCompleted():void {
			trace('onCompleted()');
			dispatchEvent(new TestResultEvent(TestResultEvent.NAME, result));
			
			if (!_printer) return;
			//TODO: Move this out to view and use event instead.
			_printer.endTest(currentTest);
			var runTime:Number = getTimer() - startTime;
			_printer.printResult(result, runTime);
		}
		
		protected function get asyncsCompleted():Boolean {
			//TODO: maybe have Async send an event instead of checking it
			var commands:Array = Async.instance.getCommandsForTest(currentTest);
			return (!commands || commands.length == 0);
		}
		
	}
}
