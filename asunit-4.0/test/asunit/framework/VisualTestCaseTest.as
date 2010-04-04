package asunit.framework {

    import asunit.asserts.*;

    import flash.display.Sprite;
    
    public class VisualTestCaseTest {

        [Inject]
        public var sprite:Sprite;

        [Test]
        public function instantiated():void {
            assertTrue(sprite is Sprite);
        }
        
        [Test]
        public function testSize():void {
            assertTrue(sprite.width == 0);
            assertTrue(sprite.height == 0);
        }

        [Test]
        public function testDrawnSize():void {
            sprite.x = 110;
            sprite.y = 115;
            sprite.graphics.beginFill(0xFF0000);
            sprite.graphics.drawRect(0, 0, 100, 200);
            
            assertEquals(100, sprite.width);
            assertEquals(200, sprite.height);
            assertEquals(110, sprite.x);
            assertEquals(115, sprite.y);
        }

        [Test]
        public function testSecondSize():void {
            assertTrue(sprite.width == 0);
            assertTrue(sprite.height == 0);
        }
    }
}

