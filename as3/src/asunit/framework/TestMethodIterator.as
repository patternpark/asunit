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
		
		public static function getBeforeMethods(test:Object):Array {
			return getMethodsWithPrefixOrMetadata(test, "Before", "setUp");
		}
		
		/**
		 *
		 * @param	test	An instance of a class with test methods.
		 * @return	An array of test method names as strings.
		 */
		public static function getTestMethods(test:Object):Array {
			return getMethodsWithPrefixOrMetadata(test, "Test", "test");
		}
		
		public static function getAfterMethods(test:Object):Array {
			return getMethodsWithPrefixOrMetadata(test, "After", "tearDown");
		}
		
		protected static function getMethodsWithPrefixOrMetadata(object:Object, theMetadata:String, thePrefix:String = ''):Array {
			var typeInfo:XML = describeType(object);
			var methodNodes:XMLList = typeInfo.method.( @name.indexOf(thePrefix) == 0
				|| (hasOwnProperty("metadata") && metadata.@name == theMetadata) );
			
			var methodNamesList:XMLList = methodNodes.@name;
			var methodNames:Array = [];
			for each (var methodNameXML:XML in methodNamesList) {
				methodNames[methodNames.length] = String(methodNameXML); // faster than push
			}
			// For now, enforce a consistent order to enable precise testing.
			methodNames.sort();
			return methodNames;
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

