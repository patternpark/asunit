package asunit.framework {
    import flash.display.Sprite;
    import flash.utils.setTimeout;

    public class AsyncMethodTest extends TestCase {

        private var instance:Sprite;
        private var asyncInstance:Sprite;

        public function AsyncMethodTest(testMethod:String = null) {
            super(testMethod);
        }

        protected override function setUp():void {
            instance = new Sprite();
            addChild(instance);
            var handler:Function = addAsync(asyncSetupHandler);
            setTimeout(handler, 0);
        }

        protected override function tearDown():void {
            removeChild(instance);
            removeChild(asyncInstance);
            instance = null;
            asyncInstance = null;
        }

        public function asyncSetupHandler():void{
            asyncInstance = new Sprite();
            addChild(asyncInstance);
        }

        public function testInstantiated():void {
            assertTrue("Sprite instantiated", instance is Sprite);
        }

        public function testAsyncMethod():void {
            var handler:Function = addAsync(asyncHandler);
            setTimeout(handler, 0);
        }
        
        private function asyncHandler():void {
            assertTrue(instance is Sprite);
        }
        
        public function testAsyncVisualEntity():void {
            var handler:Function = addAsync(spriteHandler);
            setTimeout(handler, 0);
        }
        
        private function spriteHandler():void {
            assertTrue(instance is Sprite);
        }
        
        public function testAsyncVisualEntity2():void {
            var handler:Function = addAsync(spriteHandler);
            setTimeout(handler, 0);
        }
        
        public function testMultipleAsyncMethod():void {
            var handler1:Function = addAsync(spriteHandler);
            var handler2:Function = addAsync(spriteHandler);
            setTimeout(handler1, 0);
            setTimeout(handler2, 0);
        }
        
        public function testAsyncSetup():void{
            assertTrue(asyncInstance is Sprite);
        }
    }
}
