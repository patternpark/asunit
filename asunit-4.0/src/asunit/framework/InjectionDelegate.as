package asunit.framework {
	
	import p2.reflect.ReflectionMetaData;
	import p2.reflect.Reflection;
		
	import flash.utils.Dictionary;
	import asunit.errors.UsageError;
	import p2.reflect.ReflectionVariable;
	import p2.reflect.ReflectionMember;
	import flash.utils.getDefinitionByName;

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
			var addictName:String = reflection.name
			validateMembers(members, addictName);
			
			var reflectionVariable:ReflectionVariable;
			var injectionPointFound:Boolean;
			members.forEach(function(member:ReflectionMember, index:int, items:Array):void {
				reflectionVariable = member as ReflectionVariable;
				if (reflectionVariable)
				{
					updateInjectionPoint(addict, reflectionVariable);
					injectionPointFound = true;
				}
			});
			
			if (!injectionPointFound)
			{
				throw new UsageError("InjectionDelegate expected at least one [Inject] annotation on a variable or accessor on" + addictName);
			}
			
		}
		
		/**
		 * For each inject annotation we call this method
		 * @private
		 * @return 
		*/
		protected function updateInjectionPoint(addict:*, member:ReflectionVariable):void {
			var instance:* = getInstanceFromTypeName(member.type);
			//FIXME: This actually could be a getter. If someone has their head up their booty.
			addict[member.name] = instance;
		}
		
		private function getInstanceFromTypeName(name:String):* {
			var clazz:Class = getDefinitionByName(name) as Class;
			//FIXME: This will choke if given a class with constructor arguments!
			return new clazz();
		}
		
		/**
		 * @private
		 */
		protected function validateMembers(members:Array, name:String):void
		{
			if (!members || members.length == 0)
			{
				throw new UsageError("InjectionDelegate expects at least one [Inject] annotation on " + name);
			}
			
		}
		
	}
}