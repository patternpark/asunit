package asunit.framework {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	import asunit.errors.AssertionFailedError;
	import asunit.util.ArrayIterator;
	import asunit.util.Iterator;
	import flash.utils.setTimeout;

	public class FreeRunner extends EventDispatcher {
		protected var testResult:FreeTestResult;
		protected var methodsList:Iterator;
		protected var currentTest:Object;

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
			//TODO: check for async also
			return !methodsList || !methodsList.hasNext();
		}
		
		public function run(test:Object):void {
			currentTest = test;
			methodsList = new ArrayIterator(getTestMethods(test));
			
			runNextMethod();
		}
		
		protected function runNextMethod():void {
			if (completed) {
				dispatchEvent(new TestResultEvent(TestResultEvent.NAME, testResult));
				return;
			}
				
			if (currentTest.hasOwnProperty('setUp'))
				currentTest.setUp();
			
			runMethodOnly(currentTest, String(methodsList.next()), testResult);
			
			if (currentTest.hasOwnProperty('tearDown'))
				currentTest.tearDown();
			
			setTimeout(runNextMethod, 1); // Avoid escalating callstack.
		}
		
		protected static function runMethodOnly(test:Object, methodName:String, testResult:FreeTestResult):void {
			try {
				test[methodName]();
			}
			catch (assertionError:AssertionFailedError) {
				testResult.addFailure(test, methodName, assertionError);
			}
			catch (error:Error) {
				testResult.addError(test, methodName, error);
			}
		}
		
		
	}
}
