package asunit.runners {
    
    import asunit.asserts.*;

    import asunit.support.SucceedAssertTrue;
    import asunit.printers.TextPrinter;

    import flash.display.Sprite;

	public class AsUnitCoreTest {

        [Inject]
		public var core:AsUnitCore;

        [Inject]
        public var context:Sprite;

        [Test]
		public function shouldBeInstantiated():void {
			assertTrue("core is AsUnitCore", core is AsUnitCore);
		}

        [Test]
        public function startShouldWork():void {
            core.start(SucceedAssertTrue);
        }

        [Test]
        public function setVisualContextShouldWork():void {
            core.visualContext = context;
            assertEquals(context, core.visualContext);
        }

        [Ignore]
        [Test]
        public function textPrinterShouldWork():void {
            var printer:TextPrinter = new TextPrinter();
            context.addChild(printer);
            core.addObserver(printer);

            core.start(SucceedAssertTrue);
        }
	}
}

