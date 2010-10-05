package asunit.framework {
	import asunit.util.Iterator;

	import p2.reflect.Reflection;
	import p2.reflect.ReflectionVariable;

	import flash.utils.getDefinitionByName;

	public class SuiteIterator implements Iterator {
		
        protected var index:int;
        protected var list:Array;
				
		public function SuiteIterator(Suite:Class) {
			list = getTestClasses(Suite);
		}
		
        private function getTestClasses(Suite:Class):Array {
           var reflection:Reflection = Reflection.create(Suite);

            if(!isSuite(reflection) && isTest(reflection)) {
                return [Suite];
            }

            var variable:ReflectionVariable;
            var TestConstructor:Class;
            var response:Array = [];
            for each(variable in reflection.variables) {
                TestConstructor = Class(getDefinitionByName(variable.type));
                if(isSuite(Reflection.create(TestConstructor))) {
					var testClasses:Array = getTestClasses(TestConstructor);
					for each(var testClass:Class in testClasses) {
						pushIfNotInArray(testClass, response);
					}
 				}
				else { 
                    pushIfNotInArray(TestConstructor, response)
                }
            }
            response.sort();
            return response;
        }
        
        private function pushIfNotInArray(item:Object, array:Array):void {
        	if (array.indexOf(item) >= 0) return;
        	array[array.length] = item;
        }

        public function get length():uint {
            return list.length;
        }

		private function isSuite(reflection:Reflection):Boolean {
            return RunnerFactory.isSuite(reflection);
		}

        private function isTest(reflection:Reflection):Boolean {
            return RunnerFactory.isTest(reflection);
        }
        
        public function hasNext():Boolean {
            return list[index] != null;
        }

        /**
         * Returns a test Class.
         */
        public function next():* {
            return list[index++];
        }

        public function reset():void {
            index = 0;
        }
	}
}

