package asunit.framework {
	import flash.utils.describeType;

	public class FreeRunner {

		public function FreeRunner() {
		}
		
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
			var methodNames:Array = getTestMethods(test);
			for each (var methodName:String in methodNames) {
				test.setup();
				test[methodName]();
				test.tearDown();
			}
		}
	}
}
