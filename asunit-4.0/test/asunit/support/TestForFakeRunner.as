package asunit.support {

    // Declare a fully-qualified runner for this test case:
    [RunWith("asunit.support::FakeRunner")]
    public class TestForFakeRunner {

        private var runnerReference:FakeRunner;

        public function customTestMethod():int {
            throw new Error("This method shouldn't really get called");
        }
    }
}

