package asunit.framework {
    
    import asunit.asserts.*;
    
    import flash.display.Sprite;
    import flash.utils.setTimeout;

    public class AsyncMethodTest {

        [Inject]
        public var async:IAsync;

        [Inject]
        public var sprite:Sprite;

        [Before]
        protected function setUp():void {
            var handler:Function = async.add(asyncSetupHandler);
            setTimeout(handler, 0);
        }

        public function asyncSetupHandler():void{
        }

        [Test]
        public function testInstantiated():void {
            assertTrue("Sprite instantiated", sprite is Sprite);
        }

        [Test]
        public function testAsyncMethod():void {
            var handler:Function = async.add(asyncHandler);
            setTimeout(handler, 0);
        }
        
        private function asyncHandler():void {
            assertTrue(sprite is Sprite);
        }
        
        [Test]
        public function testAsyncVisualEntity():void {
            var handler:Function = async.add(spriteHandler);
            setTimeout(handler, 0);
        }
        
        private function spriteHandler():void {
            assertTrue(sprite is Sprite);
        }

        [Test]
        public function testAsyncVisualEntity2():void {
            var handler:Function = async.add(spriteHandler);
            setTimeout(handler, 0);
        }
        
        [Test]
        public function testMultipleAsyncMethod():void {
            var handler1:Function = async.add(spriteHandler);
            var handler2:Function = async.add(spriteHandler);
            setTimeout(handler1, 0);
            setTimeout(handler2, 0);
        }
        
        [Test]
        public function testAsyncSetup():void{
            assertTrue(sprite is Sprite);
        }
    }
}
