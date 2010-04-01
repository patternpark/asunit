package asunit.runners {

    import asunit.asserts.*;
    import asunit.framework.Async;
    import asunit.framework.IAsync;
    import asunit.framework.IRunner;
    import asunit.framework.ITestFailure;
    import asunit.framework.Result;
    import asunit.framework.TestCase;
    import asunit.framework.TestFailure;
    import asunit.support.AnnotatedSubClass;
    import asunit.support.InjectTimeoutOnAsync;
    import asunit.support.InjectionFailure;
    import asunit.support.InjectionVerification;
    import asunit.support.MultiMethod;

    import flash.events.Event;
    import flash.display.Sprite;

    public class TestRunnerTest {

        [Inject]
        public var async:IAsync;

        [Inject]
        public var context:Sprite;

        private var runner:TestRunner;
        private var runnerResult:Result;
        private var test:Class;

        [Before]
        public function setUp():void {
            runner = new TestRunner();
            runnerResult = new Result();

            // Yes, statics are ugly, but we're testing 
            // that static methods are called, e.g. [BeforeClass].
            MultiMethod.methodsCalled = [];
            test = MultiMethod;
        }

        [After]
        public function tearDown():void {
            runner = null;
            MultiMethod.methodsCalled = null;
        }

        [Test]
        public function runnerInstantiated():void {
            assertTrue("TestRunner instantiated", runner is IRunner);
        }
        
        [Test]
        public function testShouldNotExtendTestCase():void {
            assertFalse(test is TestCase);
        }

        [Test]
        public function shouldRunMethodsAlphabetically():void {
            runner.addEventListener(Event.COMPLETE, async.add(checkMethodsCalledAfterRunningTestInstance, 500));
            runner.run(test, runnerResult);
        }
        
        private function checkMethodsCalledAfterRunningTestInstance(e:Event):void {
            var i:uint = 0;
            
            assertSame(MultiMethod.runBeforeClass1,         MultiMethod.methodsCalled[i++]);
            assertSame(MultiMethod.runBeforeClass2,         MultiMethod.methodsCalled[i++]);
            
            assertSame(runner.currentTest.runBefore1,                       MultiMethod.methodsCalled[i++]);
            assertSame(runner.currentTest.runBefore2,                       MultiMethod.methodsCalled[i++]);
            assertSame(runner.currentTest.fail_assertEquals,                MultiMethod.methodsCalled[i++]);
            assertSame(runner.currentTest.runAfter1,                        MultiMethod.methodsCalled[i++]);
            assertSame(runner.currentTest.runAfter2,                        MultiMethod.methodsCalled[i++]);

            assertSame(runner.currentTest.runBefore1,                       MultiMethod.methodsCalled[i++]);
            assertSame(runner.currentTest.runBefore2,                       MultiMethod.methodsCalled[i++]);
            assertSame(runner.currentTest.numChildren_is_0_by_default,      MultiMethod.methodsCalled[i++]);
            assertSame(runner.currentTest.runAfter1,                        MultiMethod.methodsCalled[i++]);
            assertSame(runner.currentTest.runAfter2,                        MultiMethod.methodsCalled[i++]);
            
            assertSame(runner.currentTest.runBefore1,                       MultiMethod.methodsCalled[i++]);
            assertSame(runner.currentTest.runBefore2,                       MultiMethod.methodsCalled[i++]);
            assertSame(runner.currentTest.stage_is_null_by_default,         MultiMethod.methodsCalled[i++]);
            assertSame(runner.currentTest.runAfter1,                        MultiMethod.methodsCalled[i++]);
            assertSame(runner.currentTest.runAfter2,                        MultiMethod.methodsCalled[i++]);
            
            assertSame(MultiMethod.runAfterClass1,          MultiMethod.methodsCalled[i++]);
            assertSame(MultiMethod.runAfterClass2,          MultiMethod.methodsCalled[i++]);
            
            assertEquals('checked all methodsCalled', MultiMethod.methodsCalled.length, i);
        }

        [Test]
        public function runShouldTriggerResultEvent():void {
            runner.addEventListener(Event.COMPLETE, async.add(checkResultWasNotSuccessful, 500));
            runner.run(test, runnerResult);
        }
        
        private function checkResultWasNotSuccessful(e:Event):void {
            assertTrue(runnerResult.failureEncountered);
            assertFalse(runnerResult.wasSuccessful);
            
            var failures:Array = runnerResult.failures;
            assertEquals('one failure in testResult', 1, failures.length);
            
            var failure0:ITestFailure = failures[0] as TestFailure;
            assertTrue("failedTest is instance of test class", failure0.failedTest is test);
        }

        [Test]
        public function runMethodByNameShouldExecuteExpectedSequence():void {
            var delegate:Function = async.add(checkMethodsCalledAfterRunningTestMethodByName, 500);
            runner.addEventListener(Event.COMPLETE, delegate);
            
            var testMethodName:String = 'stage_is_null_by_default';
            runner.runMethodByName(test, runnerResult, testMethodName);
        }

        private function checkMethodsCalledAfterRunningTestMethodByName(e:Event):void {
            var i:uint = 0;
            
            assertSame(MultiMethod.runBeforeClass1,                 MultiMethod.methodsCalled[i++]);
            assertSame(MultiMethod.runBeforeClass2,                 MultiMethod.methodsCalled[i++]);
            
            assertSame(runner.currentTest.runBefore1,               MultiMethod.methodsCalled[i++]);
            assertSame(runner.currentTest.runBefore2,               MultiMethod.methodsCalled[i++]);
            assertSame(runner.currentTest.stage_is_null_by_default, MultiMethod.methodsCalled[i++]);

            // NOTE: The following assertions are no longer applicable.
            // if the testMethod is provided, tearDown does not occur...
            //assertSame(runner.currentTest.runAfter1,              MultiMethod.methodsCalled[i++]);
            //assertSame(runner.currentTest.runAfter2,              MultiMethod.methodsCalled[i++]);
            
            //assertSame(MultiMethod.runAfterClass1,                    MultiMethod.methodsCalled[i++]);
            //assertSame(MultiMethod.runAfterClass2,                    MultiMethod.methodsCalled[i++]);
            
            assertEquals('checked all methodsCalled',               MultiMethod.methodsCalled.length, i);
        }

        // This an interesting hack in that an AsUnit 4 Test Case is being instantiated
        // and executed, but in this environment, we're simply checking to see if it passed,
        // and outputing any failures to the message...
        [Test]
        public function shouldInjectTypes():void {
            runner.run(InjectionVerification, runnerResult, null, context);
            assertFalse("Should not have encountered failures: " + runnerResult.failures.join("\n\n"), runnerResult.failureEncountered);
        }

        [Test]
        public function shouldInjectWithUnknownAttribute():void {
            runner.run(InjectionFailure, runnerResult);
            var warnings:Array = runnerResult.warnings;
            assertEquals(1, warnings.length);
        }

        [Test]
        public function shouldInjectAsyncTimeout():void {
            var async:IAsync = runner.async;
            assertEquals(Async.DEFAULT_TIMEOUT, async.timeout);
            runner.run(InjectTimeoutOnAsync, runnerResult);
            assertEquals(5, async.timeout);
        }

        [Test]
        public function annotationsOnSuperClassShouldBeRespected():void {
            runner.run(AnnotatedSubClass, runnerResult);
            assertFalse("Should not have failures: " + runnerResult.failures.join("\n\n"), runnerResult.failureEncountered);
        }
    }
}

