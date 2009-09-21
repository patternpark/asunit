package asunit.framework {
	import asunit.framework.async.FreeAsyncOperation;
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
			methodsList = new ArrayIterator(getTestMethods(test));
			
			runNextMethod();
		}
		
		protected function runNextMethod():void {
			if (completed) {
				onCompleted();
				return;
			}
			
			currentMethodName = String(methodsList.next());
				
			if (currentTest.hasOwnProperty('setUp'))
				currentTest.setUp();
			
			runMethodOnly(currentTest, currentMethodName, testResult);
			
			var operations:Array = Async.instance.getOperationsForTest(currentTest);
			if (operations && operations.length) {
				// find the async operations and listen to them
				for each (var operation:FreeAsyncOperation in operations) {
					operation.addEventListener(Event.COMPLETE, onAsyncTestCompleted);
					operation.addEventListener(ErrorEvent.ERROR, onAsyncTestFailed);
				}
				return;
			}
			
			if (currentTest.hasOwnProperty('tearDown'))
				currentTest.tearDown();
			
			setTimeout(runNextMethod, 1); // Avoid escalating callstack.
		}
		
		protected function onAsyncTestFailed(e:ErrorEvent):void {
			// The AsyncOperation doesn't ever know the method name.
			var testFailure:FreeTestFailure = new FreeTestFailure(currentTest, currentMethodName, e.error);
			// Record the test failure.
			testResult.addFailure(testFailure);
			onAsyncTestCompleted(e);
		}
		
		protected function onAsyncTestCompleted(e:Event):void {
			//trace('onAsyncTestCompleted - ' + e);
			//trace('  e.currentTarget: ' + e.currentTarget);
			//trace('    currentTest: ' + currentTest);
			//trace('      currentMethodName: ' + currentMethodName);
			//trace('----------------------');
			var operation:FreeAsyncOperation = FreeAsyncOperation(e.currentTarget);
			operation.removeEventListener(Event.COMPLETE, onAsyncTestCompleted);
			operation.removeEventListener(ErrorEvent.ERROR, onAsyncTestFailed);
			
			//var operations:Array = Async.instance.getOperationsForTest(currentTest);
			//trace('operations: ' + operations);
			
			if (asyncsCompleted) {
				onCompleted();
			}
		}
		
		protected static function runMethodOnly(test:Object, methodName:String, testResult:FreeTestResult):void {
			try {
				//trace('\n**** runMethodOnly - ' + test + ' - ' + methodName);
				test[methodName]();
			}
			catch (error:Error) {
				testResult.addFailure(new FreeTestFailure(test, methodName, error));
			}
		}
		
		protected function onCompleted():void {
			dispatchEvent(new TestResultEvent(TestResultEvent.NAME, testResult));
		}
		
		protected function get asyncsCompleted():Boolean {
			//TODO: maybe have Async send an event instead of checking it
			var operations:Array = Async.instance.getOperationsForTest(currentTest);
			return (!operations || operations.length == 0);
		}
		
	}
}
