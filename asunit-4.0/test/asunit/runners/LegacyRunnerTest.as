package asunit.runners {

    import asunit.framework.IResult;
    import asunit.framework.LegacyTestIterator;
    import asunit.framework.Result;
    import asunit.framework.TestCase;
    import asunit.support.LegacyTestCase;

    import flash.events.Event;
    import asunit.framework.CallbackBridge;

    public class LegacyRunnerTest extends TestCase {

        private var testResult:CallbackBridge;
        private var testRunner:LegacyRunner;

        public function LegacyRunnerTest(methodName:String=null) {
            super(methodName)
        }

        override protected function setUp():void {
            super.setUp();
            LegacyTestCase.callCount = 0;
            testResult = new CallbackBridge();
            testRunner = new LegacyRunner();
        }

        override protected function tearDown():void {
            super.tearDown();
            testResult = null;
            testRunner = null;
        }

        public function testSimpleSubclass():void {
            var handler:Function = function(event:Event):void {
                assertEquals(0, testResult.failureCount);
                assertEquals(2, testResult.runCount);
            };
            testRunner.addEventListener(Event.COMPLETE, addAsync(handler));
			testRunner.bridge = testResult;
            testRunner.run(LegacyTestCase);
        }
    }
}