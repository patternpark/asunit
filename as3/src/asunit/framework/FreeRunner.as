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
	import asunit.framework.Assert;

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
		}
		
		public function run(test:Object):void {
			trace('-------------------- run(): ' + test);
			currentTest = test;
			currentMethod = null;
			
			allMethods = new TestMethodIterator(test);
			
			startTime = getTimer();
			if (_printer)
				_printer.startTest(test);
			
			// If any methods in the test are async, we must use a slower path.

			if (allMethods.async) {
				runNextMethod();
				return;
			}
			
			// Since the test has no async methods, we can run a fast loop.

			while (allMethods.hasNext()) {
				runMethod(allMethods.next() as Method);
			}
			onCompleted();
		}
		
		protected function runMethod(method:Method):void {
			currentMethod = method;
			
			if (currentMethod.expects) {
				var errorClass:Class = getDefinitionByName(currentMethod.expects) as Class;
				try {
					Assert.assertThrows(errorClass, currentMethod.value);
				}
				catch (error:Error) {
					recordFailure(error);
				}
			}
			else {
				try {
					currentMethod.value();
				}
				catch (error:Error) {
					recordFailure(error);
				}
			}
		}

		protected function runNextMethod(e:TimerEvent = null):void {
			if (completed) {
				onCompleted();
				return;
			}
			
			runMethod(allMethods.next() as Method);
			
			if (currentMethod.async) {
				var commands:Array = Async.instance.getCommandsForTest(currentTest);
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
		
		protected function onAsyncMethodCalled(event:Event):void {
			var command:TimeoutCommand = TimeoutCommand(event.currentTarget);
			trace('onAsyncMethodCalled() - command: ' + command);
			
			try {
				command.execute();
			}
			catch (error:Error) {
				recordFailure(error);
			}
			onAsyncMethodCompleted(event);
		}
		
		protected function onAsyncMethodFailed(event:ErrorEvent):void {
			trace('onAsyncMethodFailed() - currentMethod: ' + currentMethod.name + ' - event.error: ' + event.error);
			
			recordFailure(event.error);
			onAsyncMethodCompleted(event);
		}
		
		protected function onAsyncMethodCompleted(event:Event):void {
			var command:TimeoutCommand = TimeoutCommand(event.currentTarget);
			
			trace('onAsyncMethodCompleted() - command: ' + command);
			
			command.removeEventListener(TimeoutCommand.CALLED,	onAsyncMethodCompleted);
			command.removeEventListener(ErrorEvent.ERROR,		onAsyncMethodFailed);
			
			if (asyncsCompleted)
				runNextMethod();
		}
		
		protected function recordFailure(error:Error):void {
			result.addFailure(new FreeTestFailure(currentTest, currentMethod.name, error));
		}
		
		protected function onCompleted():void {
			trace('onCompleted()');
			result.runTime = getTimer() - startTime;
			dispatchEvent(new TestResultEvent(TestResultEvent.NAME, result));
			
			if (!_printer) return;
			//TODO: Move this out to view and use event instead.
			_printer.endTest(currentTest);
			
		}
		
		protected function get asyncsCompleted():Boolean {
			//TODO: maybe have Async send an event instead of checking it
			var commands:Array = Async.instance.getCommandsForTest(currentTest);
			return (!commands || commands.length == 0);
		}
		
	}
}
