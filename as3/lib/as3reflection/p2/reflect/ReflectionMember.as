package p2.reflect {

	public class ReflectionMember extends ReflectionBase {

		protected var _declaredBy:String;

		public function ReflectionMember(description:XML) {
            super(description);
		}
		
		public function get declaredBy():String {
			return _declaredBy ||= description.@declaredBy;
		}

	}
}
