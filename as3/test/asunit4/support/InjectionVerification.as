package asunit4.support {

    import asunit.asserts.*;
    import asunit4.async.Async;
    import asunit4.async.IAsync;

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
            assertNotNull("DisplayObject should exiset", context);
        }

        [Test]
        public function verifyDisplayObjectAttachedToStage():void {
            assertNotNull("DisplayObjects hould be attached", context.stage);
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

