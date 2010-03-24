package asunit.framework {

    import asunit.framework.Assert;
    import asunit.framework.IAsync;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    
    [RunWith("asunit.runners.LegacyRunner")]
    public class TestCase {
        
        public function TestCase(testMethod:String=null) {
        }

        [Inject]
        public var asyncDelegate:IAsync;

        [Inject]
        public var context:Sprite;

        [Before]
        public function callSetUp():void {
            setUp();
        }

        protected function setUp():void {
        }

        [After]
        public function callTearDown():void {
            tearDown();
        }

        protected function tearDown():void {
        }

        protected function addAsync(handler:Function, timeout:int=-1):Function {
            return asyncDelegate.add(handler, timeout);
        }

        protected function getContext():DisplayObjectContainer {
            return context;
        }

        protected function addChild(child:DisplayObject):DisplayObject {
            context.addChild(child);
            return child;
        }

        protected function removeChild(child:DisplayObject):DisplayObject {
            if(child && child.parent === context) {
                context.removeChild(child);
            }
            return child;
        } 

        protected function assertTrue(...args:Array):void {
            Assert.assertTrue.apply(null, args);
        }

        public function assertFalse(...args:Array):void {
            Assert.assertFalse.apply(null, args);
        }

        protected function fail(message:String):void {
            Assert.fail(message);
        }

        protected function assertThrows(errorType:Class, block:Function):void {
            Assert.assertThrows(errorType, block);
        }

        protected function assertEquals(...args:Array):void {
            Assert.assertEquals.apply(null, args);
        }

        protected function assertNotNull(...args:Array):void {
            Assert.assertNotNull.apply(null, args);
        }

        protected function assertNull(...args:Array):void {
            Assert.assertNull.apply(null, args);
        }

        protected function assertSame(...args:Array):void {
            Assert.assertSame.apply(null, args);
        }

        protected function assertNotSame(...args:Array):void {
            Assert.assertNotSame.apply(null, args);
        }

        protected function assertEqualsFloat(...args:Array):void {
            Assert.assertEquals.apply(null, args);
        }

        protected function assertEqualsArrays(...args:Array):void {
            Assert.assertEqualsArrays.apply(null, args);
        }
        
        protected function assertEqualsArraysIgnoringOrder(...args:Array):void {
            Assert.assertEqualsArraysIgnoringOrder.apply(null, args);
        }
    }
}
