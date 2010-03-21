package asunit4.support {

    // Declare a fully-qualified runner for this test case:
    [RunWith("asunit4.support::FakeRunner")]
    public class TestForFakeRunner {

        private var runnerReference:FakeRunner;

        public function customTestMethod():int {
            throw new Error("This method shouldn't really get called");
        }
    }
}

