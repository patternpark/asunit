package asunit.framework {

    import asunit.asserts.*;

    import flash.display.Sprite;
    
    public class VisualTestCaseTest {

        [Inject]
        public var context:Sprite;

        [Test]
        public function instantiated():void {
            assertTrue(context is Sprite);
        }

    }
}

