package asunit.framework {
	
	import p2.reflect.ReflectionMetaData;
	import p2.reflect.Reflection;
		
	import flash.utils.Dictionary;
	import asunit.errors.UsageError;

	public class InjectionDelegate {
		//---------------------------------------
		// CLASS CONSTANTS
		//---------------------------------------

		public static const INJECT_ANNOTATION:String = "Inject";
		
		protected var entities:Dictionary;
		
		public function InjectionDelegate() {
		} 
				
		/**
		 * @param addict * an entity with at least one [Inject] annotation
		*/
		public function updateInjectionPoints(addict:*):void {
			var reflection:Reflection = Reflection.create(addict);
			var members:Array = reflection.getMembersByMetaData(INJECT_ANNOTATION);
			validateMembers(members, reflection.name);
		}
		
		/**
		 * For each inject annotation we call this method
		 * @private
		 * @return 
		*/
		protected function updateInjectionPoint(addict:*, metadata:ReflectionMetaData):* {
			
		}
		
		/**
		 * @private
		 */
		protected function validateMembers(members:Array,name:String):void
		{
			if (!members || members.length == 0)
			{
				throw new UsageError("InjectionDelegate expects at least one [Inject] annotation on " + name);
			}
			
		}
	}
}