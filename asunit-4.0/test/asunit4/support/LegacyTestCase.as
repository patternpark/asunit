package asunit4.support {
    
    import asunit4.framework.TestCase;

    public class LegacyTestCase extends TestCase {

        private var instance:*;

        override protected function setUp():void {
            super.setUp();
            instance = {};
            instance.name = "foo";
        }

        override protected function tearDown():void {
            super.tearDown();
            instance = null;
        }

        public function testSomething():void {
            assertEquals("foo", instance.name);
        }
    }
}

