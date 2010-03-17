package p2.reflect {

	public class ReflectionVariable extends ReflectionMember {

		protected var _type:String;

		public function ReflectionVariable(description:XML) {
			super(description);
		}
		
		public function get type():String {
			return _type ||= description.@type;
		}
	}
}
