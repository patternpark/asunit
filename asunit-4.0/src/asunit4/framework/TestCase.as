package asunit4.framework {

    import asunit.framework.Assert;
    import asunit4.async.IAsync;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
        
    [RunWith("asunit4.runners.LegacyRunner")]
    public class TestCase {

        [Inject]
        public var async:IAsync;

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
            return async.add(handler, timeout);
        }

        protected function getContext():DisplayObjectContainer {
            return context;
        }

        protected function addChild(child:DisplayObject):DisplayObject {
            context.addChild(child);
            return child;
        }

        protected function removeChild(child:DisplayObject):DisplayObject {
            if(child && context.getChildIndex(child) > -1) {
                context.removeChild(child);
            }
            return child;
        } 

        protected function assertTrue(...args:Array):void {
            Assert.assertTrue.apply(args);
        }

        protected function assertFalse(...args:Array):void {
            Assert.assertFalse.apply(args);
        }

        protected function fail(message:String):void {
            Assert.fail(message);
        }

        protected function assertThrows(errorType:Class, block:Function):void {
            Assert.assertThrows(errorType, block);
        }

        protected function assertEquals(...args:Array):void {
            Assert.assertEquals.apply(args);
        }

        protected function assertNotNull(...args:Array):void {
            Assert.assertNotNull.apply(args);
        }

        protected function assertNull(...args:Array):void {
            Assert.assertNull.apply(args);
        }

        protected function assertSame(...args:Array):void {
            Assert.assertSame.apply(args);
        }

        protected function assertNotSame(...args:Array):void {
            Assert.assertNotSame.apply(args);
        }

        protected function assertEqualsFloat(...args:Array):void {
            Assert.assertEquals.apply(args);
        }

        protected function assertEqualsArrays(...args:Array):void {
            Assert.assertEqualsArrays.apply(args);
        }
        
        protected function assertEqualsArraysIgnoringOrder(...args:Array):void {
            Assert.assertEqualsArraysIgnoringOrder.apply(args);
        }
    }
}
