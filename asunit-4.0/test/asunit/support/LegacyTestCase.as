package asunit.support {
    
    import asunit.framework.TestCase;

    public class LegacyTestCase extends TestCase {

        public static var callCount:int;

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

        public function someNonTestMethod():void {
            throw new Error("This should not be called");
        }

        [Test]
        // Ensure this method only gets called once
        // in a given test run...
        public function testSomethingElse():void {
            callCount++;
        }
    }
}

