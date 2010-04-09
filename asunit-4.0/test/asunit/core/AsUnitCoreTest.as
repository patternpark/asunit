package asunit.core {
    
    import asunit.asserts.*;
    import asunit.framework.CallbackBridge;
    import asunit.framework.IAsync;
    import asunit.framework.IResult;
    import asunit.framework.Result;
    import asunit.printers.TextPrinter;
    import asunit.support.CustomTestRunner;
    import asunit.support.SuiteWithCustomRunner;
    import asunit.support.SuiteWithOneCustomChildSuite;
    import asunit.support.SucceedAssertTrue;

    import flash.display.Sprite;
    import flash.events.Event;

    public class AsUnitCoreTest {

        [Inject]
        public var async:IAsync;

        [Inject]
        public var core:AsUnitCore;

        [Inject]
        public var context:Sprite;

        [After]
        public function cleanUpStatics():void {
            CustomTestRunner.runCalledCount = 0;
        }

        [Test]
        public function shouldBeInstantiated():void {
            assertTrue("core is AsUnitCore", core is AsUnitCore);
        }

        [Test]
        public function startShouldWork():void {
            core.start(SucceedAssertTrue);
        }

        [Test]
        public function setVisualContextShouldWork():void {
            core.visualContext = context;
            assertEquals(context, core.visualContext);
        }

        [Test]
        public function textPrinterShouldWork():void {
            var printer:TextPrinter = new TextPrinter();
            printer.traceOnComplete = false;
            core.addObserver(printer);

            // Wait for the complete event:
            var handler:Function = function(event:Event):void {
                var output:String = printer.toString();
                assertTrue("should include test summary", output.indexOf('OK (1 test)') > -1);
                assertTrue("should include provided test name", output.indexOf('asunit.support::SucceedAssertTrue') > -1);
            }

            core.addEventListener(Event.COMPLETE, async.add(handler));
            core.start(SucceedAssertTrue);
        }

        private function verifyRunWithOnASuite(Suite:Class, testCaseCount:int, testMethodCount:int):void {
            var result:CallbackBridge = new CallbackBridge();
			core.defaultBridge = result;

            var handler:Function = function(event:Event):void {
                var message:String = "CustomRunner.run was NOT called with correct count";
                // This is the number of Tests that will used the custom Runner:
                assertEquals(message, testCaseCount, CustomTestRunner.runCalledCount);
                // This is the number of test methods:
                assertEquals("Total Test Count", testMethodCount, result.runCount);
            }

            core.addEventListener(Event.COMPLETE, async.add(handler));
            core.start(Suite);
        }

        [Test]
        public function shouldAssignRunWithUsingOuterSuite():void {
            // This will work b/c the RunWith is on the outer Suite:
            var testCaseCount:int = 2;
            var testMethodCount:int = 4;
            verifyRunWithOnASuite(SuiteWithCustomRunner, testCaseCount, testMethodCount);
        }

        [Ignore(description="This doesn't work because we discard the hierarchy of Suites in the SuiteIterator")]
        [Test]
        public function shouldAssignRunWithUsingChildSuite():void {
            // This will work b/c the RunWith is on the outer Suite:
            var testCaseCount:int = 2;
            var testMethodCount:int = 4;
            verifyRunWithOnASuite(SuiteWithOneCustomChildSuite, testCaseCount, testMethodCount);
        }
    }
}
