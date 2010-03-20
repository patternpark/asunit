package p2.reflect {

	public class ReflectionMethod extends ReflectionMember {

		protected var _parameters:Array;
		protected var _returnType:String;
		
		public function ReflectionMethod(description:XML) {
			super(description);
		}
		
		private function buildParameters():Array {
			var parameters:Array = new Array();
			var list:XMLList = description..parameter;
			var param:ReflectionMethodParameter;
			var item:XML;
			for each(item in list) {
				param = new ReflectionMethodParameter(item);
				parameters.push(param);
			}
			return parameters;
		}
		
		public function get returnType():String {
			return _returnType ||= description.@returnType;			
		}
		
		public function get parameters():Array {
			if(_parameters == null) {
				_parameters = buildParameters();
			}
			return _parameters;
		}
	}
}

