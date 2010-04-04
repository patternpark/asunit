package asunit.framework {

    import asunit.asserts.*;
    import asunit.errors.AssertionFailedError;
    import asunit.framework.Assert;
    import asunit.framework.TestCase;
    
    /**
     * Tests assertEqualsArrays
     * 
     * @author Bastian Krol
     */
    public class AssertEqualsArraysTest {

        [Test]
        public function testNullEqualsNull():void {
            assertEqualsArrays(null, null);
        }

        [Test]
        public function testNullDoesNotEqualNotNull():void {
            assertAssertionFailed(Assert.assertEqualsArrays, null, []);
        }

        [Test]
        public function testNotNullDoesNotEqualNull():void {
            assertAssertionFailed(Assert.assertEqualsArrays, [], null);
        }
    
        [Test]
        public function testEmptyArrayEqualsEmptyArray():void {
            assertEqualsArrays([], []);
        }

        [Test]
        public function testArrayWithOneStringEquals():void {
            assertEqualsArrays(["abcdefg"], ["abcdefg"]);
        }
        
        [Test]
        public function testArrayWithOneStringNotEquals():void {
            assertAssertionFailed(Assert.assertEqualsArrays, ["abcdefg"], ["12345"]);
        }

        [Test]
        public function testArrayWithOneFunctionEquals():void {
            assertEqualsArrays([functionReference2], [functionReference2]);
        }
        
        [Test]
        public function testArrayWithOneFunctionNotEquals():void {
            assertAssertionFailed(Assert.assertEqualsArrays, [functionReference1], [functionReference2]);
        }
        
        [Test]
        public function testArrayWithOneNullMemberEquals():void {
            assertEqualsArrays([null], [null]);
        }

        [Test]
        public function testArrayWithOneNullMemberNotEquals1():void {
            assertAssertionFailed(Assert.assertEqualsArrays, ["..."], [null]);
        }

        [Test]
        public function testArrayWithOneNullMemberNotEquals2():void {
            assertAssertionFailed(Assert.assertEqualsArrays, [null], ["..."]);
        }

        [Test]
        public function testArrayEquals():void {
            assertEqualsArrays(["abc", "def", "ghi"], ["abc", "def", "ghi"]);
        }

        [Test]
        public function testArrayNotEquals():void {
            assertAssertionFailed(Assert.assertEqualsArrays, ["abc", "def", "ghi"], ["abc", "xyz", "ghi"]);
        }
        
        [Test]
        public function testArrayDifferentLength1():void {
            assertAssertionFailed(Assert.assertEqualsArrays, ["abc", "def", "ghi"], ["abc", "def"]);
        }

        [Test]
        public function testArrayDifferentLength2():void {
            assertAssertionFailed(Assert.assertEqualsArrays, ["abc", "def"], ["abc", "def", "ghi"]);
        }

        [Test]
        public function testArrayEqualsWhatever():void {
            assertAssertionFailed(Assert.assertEqualsArrays, ["abc", "def", "", "jkl"], ["abc", "def", null, "jkl"]);
        }

        private function functionReference1():void {
        }

        private function functionReference2():void {
        }
    }
}

