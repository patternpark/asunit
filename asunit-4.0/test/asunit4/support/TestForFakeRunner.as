package asunit4.support {

    // Declare a fully-qualified runner for this test case:
    [RunWith("asunit4.support.FakeRunner")]
    public class TestForFakeRunner {

        [Test]
        public function customTestMethod():int {
            return 42;
        }
    }
}

