package asunit4.framework {

    import asunit.util.Iterator;

	import flash.utils.getDefinitionByName;

    import p2.reflect.Reflection;
    import p2.reflect.ReflectionVariable;

	public class SuiteIterator implements Iterator {
		
        protected var list:Array;
        protected var index:int;
				
		public function SuiteIterator(testSuite:Class) {
			list = getTestClasses(testSuite);
		}
		
        private function getTestClasses(Suite:Class):Array {
            if(!isSuite(Suite) && isTest(Suite)) {
                return [Suite];
            }

            var reflection:Reflection = Reflection.create(Suite);
            var variable:ReflectionVariable;
            var TestConstructor:Class;
            var result:Array = [];
            for each(variable in reflection.variables) {
                TestConstructor = Class(getDefinitionByName(variable.type));
                if(isSuite(TestConstructor)) {
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

		private function isSuite(Suite:Class):Boolean {
            return (Reflection.create(Suite).getMetaDataByName('Suite') != null);
		}

        private function isTest(Test:Class):Boolean {
            // NOTE: A test is more than just:
            // return (Reflection.create(Test).getMetaDataByName('Test') != null);
            var iterator:Iterator = new TestIterator(new Test());
            return (iterator.length > 0);
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

