package asunit.support {

    import asunit.asserts.*;

    public class AnnotatedSubClass extends AnnotatedSuperClass {

        [Test]
        public function verifyDictionary():void {
            assertNotNull(dictionary);
        }

        [Test]
        public function verifyAsync():void {
            assertNotNull(async);
        }
    }
}

