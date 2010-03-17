package asunit4.framework {

    import flash.display.MovieClip
    import asunit4.async.IAsync;
        
    class TestCase {

        [Async]
        public var async:IAsync;

        [Before]
        public function otherBefore():void {
        }
        
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

        // TODO: Implement addAsync correctly:
        protected function addAsync(...):Function {
            return null;
        }

        protected function getContext():MovieClip {
            return null;
        }
    }
}

