package asunit.framework {

    import asunit.asserts.*;
    import asunit.support.FakeObserver;

	public class CallbackBridgeTest {

        [Inject]
        public var bridge:CallbackBridge;

        private var observer:FakeObserver;

        [Before]
        public function createObserver():void {
            observer = new FakeObserver();
            bridge.addListener(observer);
        }

        [After]
        public function destroyObserver():void {
            observer = null;
        }

        [Test]
		public function canInstantiate():void {
			assertTrue("instance is CallbackBridge", bridge is CallbackBridge);
		}

        [Test]
		public function addListenerWorked():void {
            assertEquals(1, bridge.length);
		}

        [Test]
        public function addedListenerReceivesOnRunStarted():void {
            bridge.onRunStarted();
            assertTrue(observer.onRunStartedCalled);
        }

        [Test]
        public function addedListenerReceivesOnTestStarted():void {
            bridge.onTestStarted(null);
            assertTrue(observer.onTestStartedCalled);
        }
	}
}

