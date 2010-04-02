package asunit.framework {
    
    import asunit.asserts.*;
    import asunit.support.SucceedAssertTrue;

    import flash.display.Sprite;

	public class AsUnitCoreTest {

        [Inject]
		public var core:AsUnitCore;

        [Inject]
        public var sprite:Sprite;

        [Test]
		public function shouldBeInstantiated():void {
			assertTrue("core is AsUnitCore", core is AsUnitCore);
		}

        [Test]
        public function startShouldWork():void {
            core.start(SucceedAssertTrue);
        }

        [Test]
        public function addObserverWithUnknownObjectShouldNotThrow():void {
            core.addObserver({});
        }
	}
}

