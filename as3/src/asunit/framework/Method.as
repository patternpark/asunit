package asunit.framework {
	
	public class Method {
		public var scope:Object;
		public var name:String;
		public var value:Function;
		public var metadata:XMLList;
		
		public function Method(scope:Object, name:String, metadata:XMLList = null) {
			this.scope = scope;
			this.name = name;
			this.value = scope[name];
			this.metadata = metadata;
		}
				
		public function toString():String {
			return name;
		}
		
	}

}
