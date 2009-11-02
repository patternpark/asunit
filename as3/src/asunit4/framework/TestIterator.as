package asunit4.framework {
	import asunit.util.ArrayIterator;
	import asunit.util.Iterator;
	import flash.utils.describeType;
	import flash.utils.getTimer;

	public class TestIterator {
		public var async:Boolean;
		
		protected var beforeClassMethods:Iterator;
		protected var beforeMethods:Iterator;
		protected var testMethods:Iterator;
		protected var afterMethods:Iterator;
		protected var afterClassMethods:Iterator;
		
		protected var testMethodHasRunThisCycle:Boolean;
		
		public function TestIterator(test:Object) {
			if (test is Class) throw new ArgumentError("test argument cannot be a Class");
			
			beforeClassMethods 	= new ArrayIterator(getBeforeClassMethods(test));
			beforeMethods 		= new ArrayIterator(getBeforeMethods(test));
			testMethods   		= new ArrayIterator(getTestMethods(test));
			afterMethods  		= new ArrayIterator(getAfterMethods(test));
			afterClassMethods 	= new ArrayIterator(getAfterClassMethods(test));
			
			async = isAsync(test);
		}
		
		/**
		 *
		 * @param	test	An instance of a class with methods that have [Before] metadata.
		 * @return	An array of Method instances.
		 */
		public static function getBeforeClassMethods(test:Object):Array {
			return getMethodsWithMetadata(test["constructor"], "BeforeClass", true);
		}
		
		/**
		 *
		 * @param	test	An instance of a class with methods that have [Before] metadata.
		 * @return	An array of Method instances.
		 */
		public static function getBeforeMethods(test:Object):Array {
			return getMethodsWithMetadata(test, "Before");
		}
		
		/**
		 *
		 * @param	test	An instance of a class with methods that have [Test] metadata.
		 * @return	An array of Method instances.
		 */
		public static function getTestMethods(test:Object):Array {
			return getMethodsWithMetadata(test, "Test");
		}
		
		/**
		 *
		 * @param	test	An instance of a class with methods that have [After] metadata.
		 * @return	An array of Method instances.
		 */
		public static function getAfterMethods(test:Object):Array {
			return getMethodsWithMetadata(test, "After");
		}
		
		protected static function getMethodsWithMetadata(object:Object, theMetadata:String, useStatic:Boolean = false):Array {
			var typeInfo:XML = describeType(object);
			if (!useStatic && typeInfo.@base == 'Class') typeInfo = typeInfo.factory[0];
			
			var methodNodes:XMLList = typeInfo.method.(hasOwnProperty("metadata") && metadata.@name == theMetadata);
			var methods:Array = [];
			for each (var methodNode:XML in methodNodes) {
				var methodValue:Function = object[methodNode.@name];
				methods[methods.length] = new Method(object, methodNode.@name, methodValue, methodNode.metadata);
			}
			// For now, enforce a consistent order to enable precise testing.
			methods.sortOn('name');
			return methods;
		}
		
		/**
		 *
		 * @param	test	An instance of a class with methods that have [Before] metadata.
		 * @return	An array of Method instances.
		 */
		public static function getAfterClassMethods(test:Object):Array {
			return getMethodsWithMetadata(test["constructor"], "AfterClass", true);
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
            return testMethods.hasNext()
				|| beforeMethods.hasNext()
				|| afterMethods.hasNext()
 				|| beforeClassMethods.hasNext()
 				|| afterClassMethods.hasNext();
       }

        public function next():Method {
			if (beforeClassMethods.hasNext())
				return Method(beforeClassMethods.next());
				
			if (beforeMethods.hasNext())
				return Method(beforeMethods.next());
			
			if (!testMethodHasRunThisCycle && testMethods.hasNext()) {
				testMethodHasRunThisCycle = true;
				return Method(testMethods.next());
			}
			
			if (afterMethods.hasNext()) {
				return Method(afterMethods.next());
			}
			
			
			if (!testMethods.hasNext()) {
				if (afterClassMethods.hasNext()) {
					return Method(afterClassMethods.next());
				}
				return null;
			}
			
			beforeMethods.reset();
			afterMethods.reset();
			testMethodHasRunThisCycle = false;
			return next();
        }

        public function reset():void {
			beforeClassMethods.reset();
			beforeMethods.reset();
			testMethods.reset();
			afterMethods.reset();
			afterClassMethods.reset();
			testMethodHasRunThisCycle = false;
        }
		
	}
}
