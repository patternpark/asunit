package asunit.framework {
	import asunit.util.ArrayIterator;
	import asunit.util.Iterator;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;

	public class TestIterator extends ArrayIterator implements Iterator {
		protected var testClasses:ArrayIterator;
				
		public function TestIterator(testSuite:Object) {
			//testClasses = new ArrayIterator(getTestClasses(testSuite));
			super(getTestClasses(testSuite));
		}
		
		/**
		 *
		 * @param	testSuite	A Class or instance that declares tests as instance variables.
		 * @return	An array of Class references.
		 */
		public static function getTestClasses(testSuite:Object):Array {
			var typeInfo:XML = describeType(testSuite);
			if (typeInfo.@base == 'Class') typeInfo = typeInfo.factory[0];
			var testClasses:Array = [];
			for each (var variableType:XML in typeInfo.variable.@type) {
				testClasses[testClasses.length] = getDefinitionByName(String(variableType)); // faster than push
			}
			testClasses.sort();
			return testClasses;
		}
		
		public static function countTestClasses(testSuite:Object):uint {
			return getTestClasses(testSuite).length;
		}
		
	}
}

