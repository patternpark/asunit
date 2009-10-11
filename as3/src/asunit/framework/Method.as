package asunit.framework {
	
	public class Method {
		public var scope:Object;
		public var name:String;
		public var value:Function;
		public var metadata:XMLList;
		public var async:Boolean;
		public var timeout:Number = 0;
		
		public function Method(scope:Object, name:String, metadata:XMLList = null) {
			this.scope = scope;
			this.name = name;
			this.value = scope[name];
			this.metadata = metadata;

			var testArgs:XMLList = metadata.(@name == 'Test').arg;
			this.async = testArgs.(@value == 'async').length() > 0;

			var timeout:XMLList = testArgs.(@key == 'timeout');
			if (timeout.length() == 1)
				this.timeout = Number(timeout[0].@value);
		}
				
		public function toString():String {
			return name;
		}
	}
}
