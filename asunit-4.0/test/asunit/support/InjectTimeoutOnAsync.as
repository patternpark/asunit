package asunit.support {

    import asunit.framework.IAsync;

    public class InjectTimeoutOnAsync {

        [Inject(timeout=5)]
        public var async:IAsync;

        [Test]
        public function verifyNothing():void {
        }
    }
}
