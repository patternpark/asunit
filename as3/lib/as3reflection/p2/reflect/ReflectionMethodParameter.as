package p2.reflect {

	public class ReflectionMethodParameter extends ReflectionVariable {
		protected var _index:int;
		protected var _optional:Boolean;
		
		public function ReflectionMethodParameter(description:XML) {
		    super(description);
		}
		
		public function get index():int {
			return _index ||= description.@index;
		}
		
		public function get optional():Boolean {
			return _optional ||= (description.@optional == "true");
		}
	}
}
