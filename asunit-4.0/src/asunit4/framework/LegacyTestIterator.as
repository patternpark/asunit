package asunit4.framework {

    import p2.reflect.Reflection;
    import p2.reflect.ReflectionMethod;
	
	public class LegacyTestIterator extends TestIterator {
		
        public function LegacyTestIterator(test:Object, testMethodName:String = "") {
            super(test, testMethodName);
		} 

        override protected function getTestMethods(test:Object):Array {
            var annotatedMethods:Array = super.getTestMethods(test);
            var namedMethods:Array = getTestMethodsByName(test);
            return annotatedMethods.concat(namedMethods);
        }

        protected function getTestMethodsByName(instance:Object):Array {
            var methods:Array = [];
            var reflection:Reflection = Reflection.create(instance);
            reflection.methods.forEach(function(methodReflection:ReflectionMethod, index:int, list:Array):void {
                if(methodReflection.getMetaDataByName('Test') == null) {
                    methods.push( new Method(instance, methodReflection) );
                }
            });

            return methods;
        }
	}
}

