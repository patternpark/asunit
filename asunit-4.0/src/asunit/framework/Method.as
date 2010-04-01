package asunit.framework {

    import p2.reflect.ReflectionMethod;
    import p2.reflect.ReflectionMetaData;
	
	public class Method {
		public var expects:String;
		public var ignore:Boolean;
		public var metadata:ReflectionMetaData;
		public var name:String;
		public var order:int      = 0;
		public var scope:Object;
		public var timeout:int = -1;
		public var value:Function;
		
		public function Method(scope:Object, reflection:ReflectionMethod) {
            this.scope = scope;
            this.name = reflection.name;
            this.value = scope[reflection.name];

            metadata = reflection.getMetaDataByName('Test');

            if(metadata != null) {
                ignore  = (reflection.getMetaDataByName('Ignore') != null);

                handleTimeoutMetaData();
                applyMetaData('expects');
                applyMetaData('order');
            }
        }

        private function handleTimeoutMetaData():void {
            var value:* = metadata.getValueFor('timeout');
            if(value != null) {
                var message:String = "It seems you're using [Test(timeout=n)] for " + name + ", but this has been deprecated.\n";
                message += "If you'd like to set a different timeout value, please send it to your Async instance methods like: async.add(null, timeoutInMilliseconds)";
                trace("[DEPRECATION WARNING] " + message);
            }
        }

        // The null response for timeout was updating the
        // int field to zero when it needs to be -1...
        private function applyMetaData(name:String):void {
            var value:* = metadata.getValueFor(name);
            if(value != null) {
                this[name] = value;
            }
        }

        public function execute():void {
            value.call(scope);
        }

        public function get isTest():Boolean {
            return (metadata != null || isLegacyTest);
        }

        public function get isLegacyTest():Boolean {
            return (metadata == null && name.match(/^test/));
        }

		public function toString():String {
			return name;
		}
	}
}

