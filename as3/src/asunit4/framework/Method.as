package asunit4.framework {
	
	public class Method {
		public var scope:Object;
		public var name:String;
		public var value:Function;
		public var metadata:XMLList;
		public var async:Boolean;
		public var timeout:Number = -1;
		public var expects:String;
		public var isTest:Boolean;
		
		public function Method(scope:Object, name:String, metadata:XMLList = null) {
			this.scope = scope;
			this.name = name;
			this.value = scope[name];
			this.metadata = metadata;

			var testMetadata:XMLList = metadata.(@name == 'Test');
			this.isTest = (testMetadata.length() == 1);
			
			var testArgs:XMLList = testMetadata.arg;
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
