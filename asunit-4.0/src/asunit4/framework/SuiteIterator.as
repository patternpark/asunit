package asunit4.framework {

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

        private function isTest(ProvidedTest:Class):Boolean {
            var reflection:Reflection = Reflection.create(ProvidedTest);
            var testMethods:Array = reflection.getMethodsByMetaData('Test');
            var runWith:ReflectionMetaData = reflection.getMetaDataByName('RunWith');
            return (runWith != null || testMethods.length > 0);
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

