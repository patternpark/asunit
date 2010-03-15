package asunit4.framework {

	import asunit.util.ArrayIterator;
	import asunit.util.Iterator;

    import p2.reflect.Reflection;
    import p2.reflect.ReflectionMethod;


	public class TestIterator implements Iterator {
		
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
		
		protected static function getMethodsWithMetadata(instance:Object, metaDataName:String, useStatic:Boolean = false):Array {
            var reflection:Reflection = Reflection.create(instance);
            var methodReflections:Array = reflection.getMembersByMetaData(metaDataName);

            var methods:Array = [];
            var methodReflection:ReflectionMethod;
            for each(methodReflection in methodReflections) {
                methods.push( new Method(instance, methodReflection) );
            }
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
		
		////////////////////////////////////////////////////////////////////////////
		
        public function hasNext():Boolean {
			if (!testMethods) return false;
			
            return testMethods.hasNext()
				|| beforeMethods.hasNext()
				|| afterMethods.hasNext()
 				|| beforeClassMethods.hasNext()
 				|| afterClassMethods.hasNext();
       }

        public function next():* {
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
