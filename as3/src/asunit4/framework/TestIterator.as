package asunit4.framework
{
	import asunit.util.ArrayIterator;
	import asunit.util.Iterator;

	import flash.utils.describeType;

	public class TestIterator {
		public var async:Boolean;
		
		protected var beforeClassMethods:Iterator;
		protected var beforeMethods:Iterator;
		protected var testMethods:Iterator;
		protected var afterMethods:Iterator;
		protected var afterClassMethods:Iterator;
		
		protected var testMethodHasRunThisCycle:Boolean;
		
		public function TestIterator(test:Object, testMethodName:String = "") {
			if (test is Class) throw new ArgumentError("test argument cannot be a Class");
			
			var testMethodsArray:Array = getTestMethods(test);
			if (!testMethodsArray.length) return;
			
			if (testMethodName)
			{
				testMethodsArray = testMethodsArray.filter(
					function(item:Object, index:int, array:Array):Boolean {
						return (item.name == testMethodName);
					}
				);
			}
			
			testMethods   		= new ArrayIterator(testMethodsArray);
			beforeClassMethods 	= new ArrayIterator(getBeforeClassMethods(test));
			beforeMethods 		= new ArrayIterator(getBeforeMethods(test));
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
		
		/**
		 *
		 * @param	test	An instance of a class with methods that have [After] metadata.
		 * @return	An array of Method instances.
		 */
		public static function getIgnoredMethods(test:Object):Array {
			return getMethodsWithMetadata(test, "Ignore");
		}
		
		protected static function getMethodsWithMetadata(object:Object, metadataName:String, useStatic:Boolean = false):Array {
			//trace('========== ' + metadataName);
			var typeInfo:XML = describeType(object);
			if (!useStatic && typeInfo.@base == 'Class') typeInfo = typeInfo.factory[0];
			//trace('typeInfo: ' + typeInfo);
			
			var methodNodes:XMLList = typeInfo.method.(hasOwnProperty("metadata")
				&& metadata.(@name == metadataName).length() > 0);
				
			//trace('methodNodes: ' + methodNodes.toXMLString());
			
			var methods:Array = [];
			for each (var methodNode:XML in methodNodes) {
				var methodValue:Function = object[methodNode.@name];
				methods[methods.length] = new Method(object, methodNode.@name, methodValue, methodNode.metadata);
			}
			// For now, enforce a consistent order to enable precise testing.
			methods.sortOn('name');
			methods.sortOn('order');
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
		
		public static function isTest(test:Object):Boolean {
			return getTestMethods(test).length > 0;
		}
		
		public static function isAsync(test:Object):Boolean {
			var typeInfo:XML = describeType(test);
			if (typeInfo.@base == 'Class') typeInfo = typeInfo.factory[0];

			var asyncs:XMLList = typeInfo.method.(hasOwnProperty("metadata")
				&&
				(  metadata.@name == 'Test'
				|| metadata.@name == 'Before'
				|| metadata.@name == 'After'
				|| metadata.@name == 'BeforeClass'
				|| metadata.@name == 'AfterClass')
				).metadata.arg.(@value == 'async');

			return asyncs.length() > 0;
		}
		
		////////////////////////////////////////////////////////////////////////////
		
        public function hasNext():Boolean {
			if (!testMethods) return false;
			
            return testMethods.hasNext()
				|| beforeMethods.hasNext()
				|| afterMethods.hasNext()
 				|| beforeClassMethods.hasNext()
 				|| afterClassMethods.hasNext();
       }

        public function next():Method {
			if (!testMethods) return null;

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
			if (!testMethods) return;
			
			beforeClassMethods.reset();
			beforeMethods.reset();
			testMethods.reset();
			afterMethods.reset();
			afterClassMethods.reset();
			testMethodHasRunThisCycle = false;
        }
		
	}
}
