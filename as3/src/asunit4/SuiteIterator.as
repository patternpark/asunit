package asunit4 {
	import asunit.util.ArrayIterator;
	import asunit.util.Iterator;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;

	public class SuiteIterator {
		
        protected var list:Array;
        protected var index:Number = 0;
				
		public function SuiteIterator(testSuite:Class) {
			list = getTestClasses(testSuite);
		}
		
		/**
		 *
		 * @param	testSuite	A Class or instance that declares tests as instance variables.
		 * @return	An array of Class references.
		 */
		public static function getTestClasses(testSuite:Class):Array {
			var typeInfo:XML = describeType(testSuite);
			var testClasses:Array = [];
			for each (var variableType:XML in typeInfo.factory[0].variable.@type) {
				testClasses[testClasses.length] = getDefinitionByName(String(variableType)); // faster than push
			}
			testClasses.sort();
			return testClasses;
		}
		
		public static function countTestClasses(testSuite:Class):uint {
			return getTestClasses(testSuite).length;
		}
		
		public static function isSuite(possibleTestSuite:Class):Boolean {
			var typeInfo:XML = describeType(possibleTestSuite);
			var metadataMatchingSuite:XMLList = typeInfo.factory[0].metadata.(@name == 'Suite');
			return metadataMatchingSuite.length() > 0;
		}
			
        public function hasNext():Boolean {
            return list[index] != null;
        }

        public function next():Class {
            return Class(list[index++]);
        }

        public function reset():void {
            index = 0;
        }
		
		
		
	}
}

