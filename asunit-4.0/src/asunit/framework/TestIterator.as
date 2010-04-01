package asunit.framework {

    import asunit.errors.UsageError;
    import asunit.util.ArrayIterator;
    import asunit.util.Iterator;

    import p2.reflect.Reflection;
    import p2.reflect.ReflectionMethod;

    public class TestIterator implements Iterator {
        
        private var _readyToTearDown:Boolean;

        private var afterClassMethods:Iterator;
        private var afterMethods:Iterator;
        private var beforeClassMethods:Iterator;
        private var beforeMethods:Iterator;
        private var beforeMethodRanLastCycle:Boolean;
        private var ignoredMethods:Iterator;
        private var testMethodNameReceived:Boolean;
        private var setUpHasRunThisCycle:Boolean;
        private var testMethodHasRunThisCycle:Boolean;
        private var testMethods:Iterator;
        
        public function TestIterator(test:Object, testMethodName:String = "") {
            if(test is Class) throw new ArgumentError("test argument cannot be a Class");
            
            var testMethodsArray:Array = getTestMethods(test);
            if(!testMethodsArray.length) {
                setUpNullIterators();
                return;
            }
            
            if(testMethodName) {
                testMethodNameReceived = true;
                testMethodsArray = testMethodsArray.filter(
                    function(item:Object, index:int, array:Array):Boolean {
                        return (item.name == testMethodName);
                    }
                );
                if(testMethodsArray.length == 0) {
                    var message:String = "Provided test method name (" + testMethodName + ") not found on provided class (" + Reflection.create(test).name + ")";
                    throw new UsageError(message);
                }
            }
            
            testMethods = new ArrayIterator(testMethodsArray);
            setUpIterators(test);
        }

        public function get readyToSetUp():Boolean {
            return !setUpHasRunThisCycle || (!afterMethods.hasNext() && testMethodHasRunThisCycle && testMethods.hasNext());
        }

        public function get readyToTearDown():Boolean {
            return _readyToTearDown;
        }

        protected function setUpNullIterators():void {
            // Set up null iterators for access to length
            // and other properties...
            testMethods        = new ArrayIterator();
            beforeClassMethods = new ArrayIterator();
            beforeMethods      = new ArrayIterator();
            afterMethods       = new ArrayIterator();
            afterClassMethods  = new ArrayIterator();
            ignoredMethods     = new ArrayIterator();
        }

        protected function setUpIterators(test:Object):void {
            if(!testMethodNameReceived) {
                afterClassMethods   = new ArrayIterator(getAfterClassMethods(test));
                afterMethods        = new ArrayIterator(getAfterMethods(test));
            }
            else {
                afterClassMethods = new ArrayIterator([]);
                afterMethods      = new ArrayIterator([]);
            }
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
        protected function getBeforeClassMethods(test:Object):Array {
            return getMethodsWithMetadata(test["constructor"], "BeforeClass", true);
        }
        
        /**
         *
         * @param   test    An instance of a class with methods that have [Before] metadata.
         * @return  An array of Method instances.
         */
        protected function getBeforeMethods(test:Object):Array {
            return getMethodsWithMetadata(test, "Before");
        }
        
        /**
         *
         * @param   test    An instance of a class with methods that have [Test] metadata,
         *                  or have a methods that begin with 'test'.
         * @return  An array of Method instances.
         */
        protected function getTestMethods(test:Object):Array {
            return getMethodsWithMetadata(test, "Test");
        }
        
        /**
         *
         * @param   test    An instance of a class with methods that have [After] metadata.
         * @return  An array of Method instances.
         */
        protected function getAfterMethods(test:Object):Array {
            return getMethodsWithMetadata(test, "After");
        }
        
        /**
         *
         * @param   test    An instance of a class with methods that have [After] metadata.
         * @return  An array of Method instances.
         */
        protected function getIgnoredMethods(test:Object):Array {
            return getMethodsWithMetadata(test, "Ignore");
        }
        
        /**
         *
         * @param   test    An instance of a class with methods that have [Before] metadata.
         * @return  An array of Method instances.
         */
        protected function getAfterClassMethods(test:Object):Array {
            return getMethodsWithMetadata(test["constructor"], "AfterClass", true);
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
        
        protected function countTestMethods(test:Object):uint {
            return getTestMethods(test).length;
        }
        
        public function hasNext():Boolean {
            if(!testMethods) return false;
            return testMethods.hasNext()
                || beforeMethods.hasNext()
                || afterMethods.hasNext()
                || beforeClassMethods.hasNext()
                || afterClassMethods.hasNext();
       }

        public function get length():uint {
            var testMethodCount:int = testMethods.length - ignoredMethods.length;
            var classHelperCount:int = beforeClassMethods.length + afterClassMethods.length;
            var methodHelperCount:int = beforeMethods.length + afterMethods.length;
                                       
            if(methodHelperCount > 0) {
                return (testMethodCount * methodHelperCount) + testMethodCount + classHelperCount;
            }
            else {
                return testMethodCount + classHelperCount;
            }
        }

        public function next():* {
            if(!testMethods) return null;

            var value:*;

            _readyToTearDown         = false;
            beforeMethodRanLastCycle = false;
            setUpHasRunThisCycle     = true;

            if(beforeClassMethods.hasNext()) {
                value = beforeClassMethods.next();
                //updateReadyToSetUp();
                return value;
            }


            if(beforeMethods.hasNext()) {
                value = beforeMethods.next();
                beforeMethodRanLastCycle = true;
                //updateReadyToSetUp();
                return value;
            }
            
            //updateReadyToSetUp();

            if(!testMethodHasRunThisCycle && testMethods.hasNext()) {
                testMethodHasRunThisCycle = true;
                value = testMethods.next();
                updateReadyToTearDown();
                return value;
            }
            
            if(afterMethods.hasNext()) {
                value = afterMethods.next();
                //updateReadyToSetUp();
                updateReadyToTearDown();
                return value;
            }

            if(!testMethods.hasNext()) {
                if(afterClassMethods.hasNext()) {
                    return afterClassMethods.next();
                }
                return null;
            }
            
            beforeMethods.reset();
            afterMethods.reset();
            testMethodHasRunThisCycle = false;
            setUpHasRunThisCycle = false;
            return next();
        }

        protected function updateReadyToTearDown():void {
            // Used by TestRunner to remove visual
            // entities:
            if(!beforeClassMethods.hasNext() &&
               !beforeMethods.hasNext() &&
               testMethodHasRunThisCycle &&
               !afterMethods.hasNext()) {
                _readyToTearDown = true;
            }
        }

        public function reset():void {
            if(!testMethods) return;
            
            beforeClassMethods.reset();
            beforeMethods.reset();
            testMethods.reset();
            afterMethods.reset();
            afterClassMethods.reset();

            _readyToTearDown          = false;
            setUpHasRunThisCycle      = false;
            testMethodHasRunThisCycle = false;
        }
    }
}

