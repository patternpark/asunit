package asunit.support {

    import asunit.asserts.*;
    import asunit.framework.Async;
    import asunit.framework.IAsync;

    import flash.display.Sprite;

    public class InjectionFailure {

        [Inject(unknownValue="foo")]
        public var custom:CustomParameters;

        [Test]
        public function unknownValueShouldExplode():void {
        }
    }
}
