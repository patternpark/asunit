package asunit.framework {
	
	public class Method {
		public var scope:Object;
		public var name:String;
		public var value:Function;
		public var metadata:XMLList;
		public var async:Boolean;
		
		public function Method(scope:Object, name:String, metadata:XMLList = null) {
			this.scope = scope;
			this.name = name;
			this.value = scope[name];
			this.metadata = metadata;
			this.async = metadata.(@name == 'Test').arg.(@value == 'async').length() > 0;
		}
				
		public function toString():String {
			return name;
		}
		
	}

}
