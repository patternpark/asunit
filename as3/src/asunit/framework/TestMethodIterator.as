package asunit.framework {
	import asunit.util.ArrayIterator;
	import asunit.util.Iterator;
	import flash.utils.describeType;
	import flash.utils.getTimer;

	public class TestMethodIterator implements Iterator {
		public var async:Boolean;
		
		protected var beforeMethods:Iterator;
		protected var testMethods:Iterator;
		protected var afterMethods:Iterator;
		
		protected var testMethodHasRunThisCycle:Boolean;
		
		public function TestMethodIterator(test:Object) {
			beforeMethods = new ArrayIterator(getBeforeMethods(test));
			testMethods   = new ArrayIterator(getTestMethods(test));
			afterMethods  = new ArrayIterator(getAfterMethods(test));
			async = isAsync(test);
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
			//trace('________typeInfo: \n' + typeInfo);
			
			var methodNamesList:XMLList = methodNodes.@name;
			var methods:Array = [];
			for each (var methodNode:XML in methodNodes) {
				methods[methods.length] = new Method(object, methodNode.@name, methodNode.metadata);
			}
			// For now, enforce a consistent order to enable precise testing.
			methods.sortOn('name');
			return methods;
		}
		
		public static function countTestMethods(test:Object):uint {
			return getTestMethods(test).length;
		}
		
		public static function isAsync(test:Object):Boolean {
			var typeInfo:XML = describeType(test);
			if (typeInfo.@base == 'Class') typeInfo = typeInfo.factory[0];

			var asyncs:XMLList = typeInfo.method.(hasOwnProperty("metadata")
				&& metadata.@name == 'Test').metadata.arg.(@value == 'async');

			return asyncs.length() > 0;
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

