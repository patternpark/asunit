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

		[Test]
		public function shouldHaveDefaultRunCount():void
		{
			assertEquals(0, bridge.runCount);
		}
		
		[Test]
		public function shouldHaveCumulativeRunCount():void
		{
			/*
				function onTestStarted(test:Object):void;
				function onTestCompleted(test:Object):void;
				function onTestFailure(failure:ITestFailure):void;
				function onTestSuccess(success:ITestSuccess):void;
			*/
			bridge.onTestStarted(null);
			bridge.onTestSuccess(null);
			bridge.onTestCompleted(null);
			bridge.onTestStarted(null);
			bridge.onTestSuccess(null);
			bridge.onTestCompleted(null);
			assertEquals(2, bridge.runCount);
		}
		
	}
}

