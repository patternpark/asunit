package asunit.framework {
	import asunit.framework.async.TimeoutCommand;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	import asunit.errors.AssertionFailedError;
	import asunit.util.ArrayIterator;
	import asunit.util.Iterator;
	import flash.utils.setTimeout;
	import asunit.framework.async.Async;
	import flash.events.IEventDispatcher;

	public class FreeRunner extends EventDispatcher {
		protected var testResult:FreeTestResult;
		protected var methodsList:Iterator;
		protected var currentTest:Object;
		protected var currentMethodName:String;

		public function FreeRunner() {
			testResult = new FreeTestResult();
		}
		
		/**
		 *
		 * @param	test	An instance of a class with test methods.
		 * @return	An array of method names as strings.
		 */
		public static function getTestMethods(test:Object):Array {
			var description:XML = describeType(test);
			var methodNodes:XMLList = description..method.(@name.match("^test"));
			var methodNames:XMLList = methodNodes.@name;
			var testMethods:Array = [];
			for each (var item:Object in methodNames) {
				testMethods.push(String(item));
			}
			// For now, enforce a consistent order to enable precise testing.
			testMethods.sort();
			return testMethods;
		}
		
		public static function countTestMethods(test:Object):uint {
			return getTestMethods(test).length;
		}
		
		protected function get completed():Boolean {
			return (!methodsList || !methodsList.hasNext()) && asyncsCompleted;
		}
		
		public function run(test:Object):void {
			currentTest = test;
			currentMethodName = '';
			methodsList = new ArrayIterator(getTestMethods(test));
			
			runNextMethod();
		}
		
		protected function runNextMethod():void {
			if (completed) {
				onCompleted();
				return;
			}
			
			currentMethodName = String(methodsList.next());
			var method:Function = currentTest[currentMethodName] as Function;
			
			if (currentTest.hasOwnProperty('setUp'))
				currentTest.setUp();
			
			runMethodForTest(method, currentTest, currentMethodName, testResult);
			
			var commands:Array = Async.instance.getCommandsForTest(currentTest);
			if (commands && commands.length) {
				// find the async commands and listen to them
				for each (var command:TimeoutCommand in commands) {
					command.addEventListener(TimeoutCommand.CALLED, onAsyncMethodCalled);
					command.addEventListener(ErrorEvent.ERROR, onAsyncMethodFailed);
				}
				return;
			}
			
			if (currentTest.hasOwnProperty('tearDown'))
				currentTest.tearDown();
			
			// If setTimeout() were not used, the synchronous test methods
			// would keep increasing the callstack.
			setTimeout(runNextMethod, 1);
		}
		
		protected function onAsyncMethodCalled(e:Event):void {
			var command:TimeoutCommand = TimeoutCommand(e.currentTarget);
			runMethodForTest(command.execute, currentTest, currentMethodName, testResult);
			onAsyncMethodCompleted(e);
		}
		
		protected function onAsyncMethodFailed(e:ErrorEvent):void {
			// The TimeoutCommand doesn't know the method name.
			var testFailure:FreeTestFailure = new FreeTestFailure(currentTest, currentMethodName, e.error);
			// Record the test failure.
			testResult.addFailure(testFailure);
			onAsyncMethodCompleted(e);
		}
		
		protected function onAsyncMethodCompleted(e:Event):void {
			var command:TimeoutCommand = TimeoutCommand(e.currentTarget);
			command.removeEventListener(TimeoutCommand.CALLED,	onAsyncMethodCompleted);
			command.removeEventListener(ErrorEvent.ERROR,		onAsyncMethodFailed);
			
			if (asyncsCompleted) {
				onCompleted();
			}
		}
		
		protected static function runMethodForTest(method:Function, test:Object, testMethodName:String, testResult:FreeTestResult):void {
			try {
				method();
			}
			catch (error:Error) {
				testResult.addFailure(new FreeTestFailure(test, testMethodName, error));
			}
		}
		
		protected function onCompleted():void {
			dispatchEvent(new TestResultEvent(TestResultEvent.NAME, testResult));
		}
		
		protected function get asyncsCompleted():Boolean {
			//TODO: maybe have Async send an event instead of checking it
			var commands:Array = Async.instance.getCommandsForTest(currentTest);
			return (!commands || commands.length == 0);
		}
		
	}
}
