package asunit.framework {

    import asunit.asserts.*;
    import asunit.support.FakeObserver;
    import asunit.framework.Result;

	public class ResultObserverTest {

        private var result:Result;

        private var listener:FakeObserver;

        [Before]
        public function createObserver():void {
            listener = new FakeObserver();
			result = new Result();
            result.addListener(listener);
        }

        [After]
        public function destroyObserver():void {
            listener = null;
        }

        [Test]
		public function canInstantiate():void {
			assertTrue("instance is Result", result is Result);
		}

        [Test]
        public function addedListenerReceivesOnRunStarted():void {
            result.onRunStarted();
            assertTrue(listener.onRunStartedCalled);
        }

        [Test]
        public function addedListenerReceivesOnTestStarted():void {
            result.onTestStarted(null);
            assertTrue(listener.onTestStartedCalled);
        }

		[Test]
		public function shouldHaveDefaultRunCount():void
		{
			assertEquals(0, result.runCount);
		}
		
		[Test]
		public function shouldHaveCumulativeRunCount():void
		{
			result.onTestStarted(null);
			result.onTestSuccess(null);
			result.onTestCompleted(null);
			result.onTestStarted(null);
			result.onTestSuccess(null);
			result.onTestCompleted(null);
			assertEquals(2, result.runCount);
		}
		
	}
}