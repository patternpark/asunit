package p2.reflect {

	public class ReflectionAccessor extends ReflectionVariable {
		protected var _access:String;
		
		public function ReflectionAccessor(description:XML) {
			super(description);
		}
		
		public function get access():String {
			return _access ||= description.@access;
		}
	}
}
