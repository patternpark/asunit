package asunit4.framework 
{
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
		
        private function getTestClasses(suite:Class):Array {
            if(!SuiteIterator.isSuite(suite) && TestIterator.isTest(suite)) {
                return [suite];
            }
            var reflection:Reflection = Reflection.create(suite);
            var variable:ReflectionVariable;
            var TestConstructor:Class;
            var result:Array = [];
            for each(variable in reflection.variables) {
                TestConstructor = Class(getDefinitionByName(variable.type));
                if(SuiteIterator.isSuite(TestConstructor)) {
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

		public static function isSuite(possibleTestSuite:Class):Boolean {
            return Reflection.create(possibleTestSuite).getMetaDataByName('Suite') != null;
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
