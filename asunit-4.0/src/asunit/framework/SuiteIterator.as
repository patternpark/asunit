package asunit.framework {

    import asunit.util.Iterator;

	import flash.utils.getDefinitionByName;

    import p2.reflect.Reflection;
    import p2.reflect.ReflectionVariable;
    import p2.reflect.ReflectionMetaData;

	public class SuiteIterator implements Iterator {
		
        protected var list:Array;
        protected var index:int;
				
		public function SuiteIterator(testSuite:Class) {
			list = getTestClasses(testSuite);
		}
		
        private function getTestClasses(Suite:Class):Array {
            var reflection:Reflection = Reflection.create(Suite);

            if(!isSuite(reflection) && isTest(reflection)) {
                return [Suite];
            }

            var variable:ReflectionVariable;
            var TestConstructor:Class;
            var result:Array = [];
            for each(variable in reflection.variables) {
                TestConstructor = Class(getDefinitionByName(variable.type));
                if(isSuite(Reflection.create(TestConstructor))) {
                    result = result.concat( getTestClasses(TestConstructor) );
                }
                else {
                    result.push(TestConstructor);
                }
            }
            result.sort();
            return result;
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

        // Returns a Class reference:
        public function next():* {
            return list[index++];
        }

        public function reset():void {
            index = 0;
        }
	}
}

