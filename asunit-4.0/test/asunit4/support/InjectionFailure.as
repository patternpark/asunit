package asunit4.support {

    import asunit.asserts.*;
    import asunit4.async.Async;
    import asunit4.async.IAsync;

    import flash.display.Sprite;

    public class InjectionFailure {

        [Inject(unknownValue="foo")]
        public var custom:CustomParameters;

        [Test]
        public function unknownValueShouldExplode():void {
        }
    }
}
