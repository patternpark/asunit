package asunit4.framework {

    import asunit.util.ArrayIterator;
    import asunit.util.Iterator;

    import p2.reflect.Reflection;
    import p2.reflect.ReflectionMethod;

    public class TestIterator implements Iterator {
        
        private var afterClassMethods:Iterator;
        private var afterMethods:Iterator;
        private var beforeClassMethods:Iterator;
        private var beforeMethods:Iterator;
        private var ignoredMethods:Iterator;
        private var testMethodHasRunThisCycle:Boolean;
        private var testMethods:Iterator;
        
        public function TestIterator(test:Object, testMethodName:String = "") {
            if (test is Class) throw new ArgumentError("test argument cannot be a Class");
            
            var testMethodsArray:Array = getTestMethods(test);
            if (!testMethodsArray.length) {
                setUpNullIterators();
                return;
            }
            
            if (testMethodName) {
                testMethodsArray = testMethodsArray.filter(
                    function(item:Object, index:int, array:Array):Boolean {
                        return (item.name == testMethodName);
                    }
                );
            }
            
            testMethods = new ArrayIterator(testMethodsArray);
            setUpIterators(test);
        }

        private function setUpNullIterators():void {
            // Set up null iterators for access to length
            // and other properties...
            testMethods        = new ArrayIterator();
            beforeClassMethods = new ArrayIterator();
            beforeMethods      = new ArrayIterator();
            afterMethods       = new ArrayIterator();
            afterClassMethods  = new ArrayIterator();
            ignoredMethods     = new ArrayIterator();
        }

        private function setUpIterators(test:Object):void {
            afterClassMethods   = new ArrayIterator(getAfterClassMethods(test));
            afterMethods        = new ArrayIterator(getAfterMethods(test));
            beforeClassMethods  = new ArrayIterator(getBeforeClassMethods(test));
            beforeMethods       = new ArrayIterator(getBeforeMethods(test));
            ignoredMethods      = new ArrayIterator(getIgnoredMethods(test));
        }

        public function get beforeClassIterator():Iterator {
            return beforeClassMethods;
        }

        public function get beforeIterator():Iterator {
            return beforeMethods;
        }

        public function get testMethodsIterator():Iterator {
            return testMethods;
        }

        public function get afterIterator():Iterator {
            return afterMethods;
        }

        public function get afterClassIterator():Iterator {
            return afterClassMethods;
        }

        public function get ignoredIterator():Iterator {
            return ignoredMethods;
        }

        /**
         *
         * @param   test    An instance of a class with methods that have [Before] metadata.
         * @return  An array of Method instances.
         */
        private function getBeforeClassMethods(test:Object):Array {
            return getMethodsWithMetadata(test["constructor"], "BeforeClass", true);
        }
        
        /**
         *
         * @param   test    An instance of a class with methods that have [Before] metadata.
         * @return  An array of Method instances.
         */
        private function getBeforeMethods(test:Object):Array {
            return getMethodsWithMetadata(test, "Before");
        }
        
        /**
         *
         * @param   test    An instance of a class with methods that have [Test] metadata.
         * @return  An array of Method instances.
         */
        private function getTestMethods(test:Object):Array {
            return getMethodsWithMetadata(test, "Test");
        }
        
        /**
         *
         * @param   test    An instance of a class with methods that have [After] metadata.
         * @return  An array of Method instances.
         */
        private function getAfterMethods(test:Object):Array {
            return getMethodsWithMetadata(test, "After");
        }
        
        /**
         *
         * @param   test    An instance of a class with methods that have [After] metadata.
         * @return  An array of Method instances.
         */
        private function getIgnoredMethods(test:Object):Array {
            return getMethodsWithMetadata(test, "Ignore");
        }
        
        protected function getMethodsWithMetadata(instance:Object, metaDataName:String, useStatic:Boolean = false):Array {
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
         * @param   test    An instance of a class with methods that have [Before] metadata.
         * @return  An array of Method instances.
         */
        private function getAfterClassMethods(test:Object):Array {
            return getMethodsWithMetadata(test["constructor"], "AfterClass", true);
        }
        
        private function countTestMethods(test:Object):uint {
            return getTestMethods(test).length;
        }
        
        // Let's move this out of static - it's only used by SuiteIterator...
        // maybe we can defer the check until after we already create
        // a test iterator.
        public static function isTest(TestClass:Class):Boolean {
            var instance:* = new TestClass();
            var iterator:Iterator = new TestIterator(instance);
            return (iterator.length > 0);
        }
        
        public function hasNext():Boolean {
            if (!testMethods) return false;
            
            return testMethods.hasNext()
                || beforeMethods.hasNext()
                || afterMethods.hasNext()
                || beforeClassMethods.hasNext()
                || afterClassMethods.hasNext();
       }

        public function get length():uint {
            return (beforeClassMethods.length + 
                    beforeMethods.length + 
                    testMethods.length + 
                    afterMethods.length +
                    afterClassMethods.length);
        }

        public function next():* {
            if (!testMethods) return null;

            if (beforeClassMethods.hasNext())
                return beforeClassMethods.next();
                
            if (beforeMethods.hasNext())
                return beforeMethods.next();
            
            if (!testMethodHasRunThisCycle && testMethods.hasNext()) {
                testMethodHasRunThisCycle = true;
                return testMethods.next();
            }
            
            if (afterMethods.hasNext()) {
                return afterMethods.next();
            }
            
            if (!testMethods.hasNext()) {
                if (afterClassMethods.hasNext()) {
                    return afterClassMethods.next();
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

