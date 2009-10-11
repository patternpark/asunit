package asunit.framework {
	import asunit.util.ArrayIterator;
	import asunit.util.Iterator;
	import flash.utils.describeType;

	public class TestMethodIterator implements Iterator {
		protected var beforeMethods:Iterator;
		protected var testMethods:Iterator;
		protected var afterMethods:Iterator;
		
		protected var testMethodHasRunThisCycle:Boolean;
		
		public function TestMethodIterator(test:Object) {
			beforeMethods = new ArrayIterator(getBeforeMethods(test));
			testMethods   = new ArrayIterator(getTestMethods(test));
			afterMethods  = new ArrayIterator(getAfterMethods(test));
		}
		
		/**
		 *
		 * @param	test	An instance of a class with methods that either have [Before] metadata
		 * or are named with the "tearDown" prefix.
		 * @return	An array of test method names as strings.
		 */
		public static function getBeforeMethods(test:Object):Array {
			return getMethodsWithMetadata(test, "Before");
		}
		
		/**
		 *
		 * @param	test	An instance of a class with methods that either have [Test] metadata
		 * or are named with the "test" prefix.
		 * @return	An array of test method names as strings.
		 */
		public static function getTestMethods(test:Object):Array {
			return getMethodsWithMetadata(test, "Test");
		}
		
		/**
		 *
		 * @param	test	An instance of a class with methods that either have [After] metadata
		 * or are named with the "setUp" prefix.
		 * @return	An array of test method names as strings.
		 */
		public static function getAfterMethods(test:Object):Array {
			return getMethodsWithMetadata(test, "After");
		}
		
		protected static function getMethodsWithMetadata(object:Object, theMetadata:String):Array {
			var typeInfo:XML = describeType(object);
			var methodNodes:XMLList = typeInfo.method.(hasOwnProperty("metadata") && metadata.@name == theMetadata);
			
			var methodNamesList:XMLList = methodNodes.@name;
			var methods:Array = [];
			for each (var methodNameXML:XML in methodNamesList) {
				methods[methods.length] = new Method(object, String(methodNameXML));
			}
			// For now, enforce a consistent order to enable precise testing.
			methods.sortOn('name');
			return methods;
		}
		
		public static function countTestMethods(test:Object):uint {
			return getTestMethods(test).length;
		}
		
		////////////////////////////////////////////////////////////////////////////
		
        public function hasNext():Boolean {
            return testMethods.hasNext() || beforeMethods.hasNext() || afterMethods.hasNext();
        }

        public function next():Object {
			if (beforeMethods.hasNext())
				return beforeMethods.next();
			
			if (!testMethodHasRunThisCycle && testMethods.hasNext()) {
				testMethodHasRunThisCycle = true;
				return testMethods.next();
			}
			
			if (afterMethods.hasNext()) {
				return afterMethods.next();
			}
			
			if (!testMethods.hasNext()) return null;
			
			beforeMethods.reset();
			afterMethods.reset();
			testMethodHasRunThisCycle = false;
			return next();
        }

        public function reset():void {
			beforeMethods.reset();
			testMethods.reset();
			afterMethods.reset();
			testMethodHasRunThisCycle = false;
        }
		
	}
}

