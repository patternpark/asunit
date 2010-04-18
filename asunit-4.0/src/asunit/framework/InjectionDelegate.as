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
		
		public static const THROW_ERROR_ON_MISSING_INJECTION_POINT:Boolean = true;
		public static const INJECT_ANNOTATION:String = "Inject";
		
		private var entities:Dictionary;
		
		public function InjectionDelegate()
		{
			entities = new Dictionary();
		}
		
		/**
		 * @param addict * an entity with at least one [Inject] annotation
		*/
		public function updateInjectionPoints(addict:*, throwErrorOnMissingInjection:Boolean=false):void {
			var reflection:Reflection = Reflection.create(addict);
			var members:Array = reflection.getMembersByMetaData(INJECT_ANNOTATION);
			var addictName:String = reflection.name
			if (throwErrorOnMissingInjection)
			{
				validateMembers(members, addictName);
			}			
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
			
			if (!injectionPointFound && throwErrorOnMissingInjection)
			{
				throw new UsageError("InjectionDelegate expected at least one [Inject] annotation on a variable or accessor on" + addictName);
			}
			
		}
		
		/**
		 * For each inject annotation we call this method
		 * @private
		 * @return 
		*/
		private function updateInjectionPoint(addict:*, member:ReflectionVariable):void {
			//FIXME: This actually could be a getter. If someone has their head up their booty.
			var instance:* = getInstanceFromTypeName(member.type);
			addict[member.name] = instance;
		}
		
		private function getInstanceFromTypeName(name:String):* {
			var clazz:Class = getDefinitionByName(name) as Class;
			 return getOrCacheInstanceFromClass(clazz);
		}
		
		private function getOrCacheInstanceFromClass(clazz:Class):* {
			if (!entities[clazz])
			{
				//FIXME: This will choke if given a class with constructor arguments!
				entities[clazz] = new clazz();
				updateInjectionPoints(entities[clazz]);
			}

			return entities[clazz];
		}
		
		/**
		 * @private
		 */
		private function validateMembers(members:Array, name:String):void
		{
			if (!members || members.length == 0)
			{
				throw new UsageError("InjectionDelegate expects at least one [Inject] annotation on " + name);
			}
			
		}
		
	}
}