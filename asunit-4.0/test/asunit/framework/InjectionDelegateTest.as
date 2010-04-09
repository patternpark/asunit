package asunit.framework {

	import asunit.asserts.*;
	
	public class InjectionDelegateTest  {
		
		[Inject]
		public var injector:InjectionDelegate;
		
		[Test]
		public function testInstantiated():void {
			assertTrue("instance is InjectionDelegate", injector is InjectionDelegate);
		}

		[Ignore]
		[Test]
		public function testUpdateInjectionPoints():void {
			var addict:Object = {};
			injector.updateInjectionPoints(addict);
			assertTrue("Failing test", false);
		}
		
		[Test(expects="asunit.errors.UsageError")]
		public function shouldThrowUsageErrorOnInvalidAddict():void
		{
			var invalidAddict:InvalidAddict = new InvalidAddict();
			injector.updateInjectionPoints(invalidAddict);
		}
		
		
	}
}

//An addict that has no inject annotations
class InvalidAddict {}