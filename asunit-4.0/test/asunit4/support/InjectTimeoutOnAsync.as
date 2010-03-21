package asunit4.support {

    import asunit4.async.IAsync;

    public class InjectTimeoutOnAsync {

        [Inject(timeout=5)]
        public var async:IAsync;

        [Test]
        public function verifyNothing():void {
        }
    }
}

