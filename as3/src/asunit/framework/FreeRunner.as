package asunit.framework {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	import asunit.errors.AssertionFailedError;

	public class FreeRunner extends EventDispatcher {

		public function FreeRunner() {
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
		
		public function runTest(test:Object):void {
			var testResult:FreeTestResult = new FreeTestResult();
			var methodNames:Array = getTestMethods(test);
			
			for each (var methodName:String in methodNames) {
				test.setUp();
				try {
					test[methodName]();
				}
				catch (assertionError:AssertionFailedError) {
					testResult.addFailure(test, methodName, assertionError);
				}
				catch (error:Error) {
					testResult.addError(test, methodName, error);
				}
				test.tearDown();
			}
			
			dispatchEvent(new TestResultEvent(TestResultEvent.NAME, testResult));
		}
	}
}
