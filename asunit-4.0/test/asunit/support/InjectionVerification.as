package asunit.support {

    import asunit.asserts.*;
    import asunit.framework.Async;
    import asunit.framework.IAsync;

    import flash.display.Sprite;

    public class InjectionVerification {

        [Inject]
        public var iAsync:IAsync;

        [Inject]
        public var async:Async;

        [Inject]
        public var context:Sprite;

        [Test]
        public function verifyDisplayObjectInjection():void {
            assertNotNull("DisplayObject should exist", context);
        }

        [Test]
        public function verifyDisplayObjectAttachedToStage():void {
            assertNotNull("DisplayObjects should be attached to stage", context.stage);
        }

        [Test]
        public function verifyAsyncInjection():void {
            assertNotNull(async);
        }

        [Test]
        public function verifyIAsyncInjection():void {
            assertNotNull(iAsync);
        }
    }
}

