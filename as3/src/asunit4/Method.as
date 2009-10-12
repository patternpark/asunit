package asunit4 {
	
	public class Method {
		public var scope:Object;
		public var name:String;
		public var value:Function;
		public var metadata:XMLList;
		public var async:Boolean;
		public var timeout:Number = 0;
		public var expects:String;
		
		public function Method(scope:Object, name:String, metadata:XMLList = null) {
			this.scope = scope;
			this.name = name;
			this.value = scope[name];
			this.metadata = metadata;

			var testArgs:XMLList = metadata.(@name == 'Test').arg;
			this.async = testArgs.(@value == 'async').length() > 0;

			var timeoutXML:XMLList = testArgs.(@key == 'timeout');
			if (timeoutXML.length() == 1)
				this.timeout = Number(timeoutXML[0].@value);
				
			var expectsXML:XMLList = testArgs.(@key == 'expects');
			if (expectsXML.length() == 1)
				this.expects = String(expectsXML[0].@value);
		}
				
		public function toString():String {
			return name;
		}
	}
}
