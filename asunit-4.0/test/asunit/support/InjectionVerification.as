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

        [Inject(someString="stringValue", someBoolean=false, someNumber=23.4, someInt=-23, someUInt=25)]
        public var custom:CustomParameters;

        [Test]
        public function injectedShouldReceiveUIntValue():void {
            assertSame(25, custom.someUInt);
        }

        [Test]
        public function injectedShouldReceiveIntegerValue():void {
            assertSame(-23, custom.someInt);
        }

        [Test]
        public function injectedShouldReceiveNumberValue():void {
            assertSame(23.4, custom.someNumber);
        }

        [Test]
        public function injectedShouldReceiveBooleanValue():void {
            assertSame(false, custom.someBoolean);
        }

        [Test]
        public function injectedShouldReceiveStringValue():void {
            assertEquals("stringValue", custom.someString);
        }

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

