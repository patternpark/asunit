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

            var metadata:ReflectionMetaData = reflection.getMetaDataByName('Test');

            if(metadata != null) {
                isTest  = true;
                ignore  = (reflection.getMetaDataByName('Ignore') != null);

                timeout = metadata.getValueFor('timeout');
                expects = metadata.getValueFor('expects');
                order   = metadata.getValueFor('order');
            }
        }

		public function toString():String {
			return name;
		}
	}
}

