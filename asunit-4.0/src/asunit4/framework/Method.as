package asunit4.framework {

    import p2.reflect.ReflectionMethod;
    import p2.reflect.ReflectionMetaData;
	
	public class Method {
		public var expects:String;
		public var ignore:Boolean;
		public var isTest:Boolean;
		public var metadata:XMLList;
		public var name:String;
		public var order:int      = 0;
		public var scope:Object;
		public var timeout:Number = -1;
		public var value:Function;
		
		public function Method(scope:Object, reflection:ReflectionMethod) {
            this.scope = scope;
            this.name = reflection.name;
            this.value = scope[reflection.name];

            var testReflection:ReflectionMetaData = reflection.getMetaDataByName('Test');

            if(testReflection != null) {
                isTest  = true;
                ignore  = (reflection.getMetaDataByName('Ignore') != null);

                timeout = testReflection.getValueFor('timeout');
                expects = testReflection.getValueFor('expects');
                order   = testReflection.getValueFor('order');
            }
        }

		public function toString():String {
			return name;
		}
	}
}
