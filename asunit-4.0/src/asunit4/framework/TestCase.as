package asunit4.framework {

    import asunit4.async.IAsync;
    import flash.display.Sprite;
    import flash.display.MovieClip
        
    public class TestCase {

        [Inject]
        public var async:IAsync;

        [Before]
        public function otherBefore():void {
        }
        
        [Before]
        public function callSetUp():void {
            setUp();
        }

        [Inject]
        public var context:Sprite;

        protected function setUp():void {
        }

        [After]
        public function callTearDown():void {
            tearDown();
        }

        protected function tearDown():void {
        }

        // TODO: Implement addAsync correctly:
        protected function addAsync(handler:Function, timeout:int=-1):Function {
            return async.add(handler, timeout);
        }

        protected function getContext():Sprite {
            return context;
        }
    }
}

