package asunit.core {
    
    import asunit.asserts.*;
    import asunit.framework.IAsync;
    import asunit.framework.IResult;
    import asunit.framework.Result;
    import asunit.printers.TextPrinter;
    import asunit.support.CustomSuiteRunner;
    import asunit.support.SuiteWithCustomRunner;
    import asunit.support.SuiteWithOneCustomChildSuite;
    import asunit.support.SucceedAssertTrue;

    import flash.display.Sprite;
    import flash.events.Event;

    public class AsUnitCoreTest {

        [Inject]
        public var async:IAsync;

		private var core:AsUnitCore;

		[Before]
		public function setUp():void {
			core = new AsUnitCore();
		}

        [After]
        public function cleanUpStatics():void {
            CustomSuiteRunner.runCalledCount = 0;
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
		public function shouldDispatchSelfAsCurrentTarget():void {
			var handlerCalled:Boolean = false;
			var handler:Function = function(event:Event):void {
				assertSame("currentTarget should be the core", core, event.currentTarget);
				handlerCalled = true;
				core.removeEventListener(event.type, arguments.callee);
			}

			var eventType:String = "foo";
			core.addEventListener(eventType, handler);
			// when
			core.dispatchEvent(new Event(eventType));
			// then
			assertTrue("handler called", handlerCalled);
		}		

        [Test]
        public function setVisualContextShouldWork():void {
			var context:Sprite = new Sprite();
            core.visualContext = context;
            assertSame(context, core.visualContext);
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

            var handler:Function = function(event:Event):void {
                var message:String = "CustomSuiteRunner.run was NOT called with correct count";
                // This is the number of Tests that will used the custom Runner:
                assertEquals(message, testCaseCount, CustomSuiteRunner.runCalledCount);
                // This is the number of test methods:
                assertEquals("Total Test Count", testMethodCount, core.result.runCount);
            }

            core.addEventListener(Event.COMPLETE, async.add(handler, 200));
            core.start(Suite);
        }

        [Test]
        public function shouldUseRunWithOnlyOnItsSuiteNotChildren():void {
            // TheRunWith is on the outer Suite:
            var testCaseCount:int = 1;
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
