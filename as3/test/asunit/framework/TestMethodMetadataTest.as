package asunit.framework {
	import asunit.framework.TestCase;
	import flash.events.Event;
	import asunit.framework.support.SpriteMetadataTest

	public class TestMethodMetadataTest extends TestCase {
		private var runner:FreeRunner;
		private var spriteTest:SpriteMetadataTest;

		public function TestMethodMetadataTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			runner = new FreeRunner();
			spriteTest = new SpriteMetadataTest();
		}

		protected override function tearDown():void {
			runner = null;
		}

		public function testInstantiated():void {
			assertTrue("FreeRunner instantiated", runner is FreeRunner);
		}
		
		public function test_free_test_does_not_extend_TestCase():void
		{
			assertFalse(spriteTest is TestCase);
		}

		public function test_get_before_methods_of_free_test_by_metadata():void {
			var beforeMethods:Array = FreeRunner.getBeforeMethods(spriteTest);
			
			assertEquals(2, beforeMethods.length);
			// In case the ordering is random, check that the array contains the method somewhere.
			assertTrue(beforeMethods.indexOf('runBefore1') >= 0);
			assertTrue(beforeMethods.indexOf('runBefore2') >= 0);
		}
		
		public function test_countTestMethods_of_free_test():void {
			assertEquals(3, FreeRunner.countTestMethods(spriteTest));
		}
		
		public function test_get_test_methods_of_free_test_by_metadata():void {
			var testMethods:Array = FreeRunner.getTestMethods(spriteTest);
			
			assertEquals(3, testMethods.length);
			// In case the ordering is random, check that the array contains the method somewhere.
			assertTrue(testMethods.indexOf('stage_is_null_by_default') >= 0);
			assertTrue(testMethods.indexOf('numChildren_is_0_by_default') >= 0);
			assertTrue(testMethods.indexOf('fail_assertEquals') >= 0);
		}
		//////
		// For now, the test methods are sorted alphabetically to enable precise testing.
		public function test_run_calls_setup_before_and_tearDown_after_each_test_method():void {
			runner.addEventListener(TestResultEvent.NAME, addAsync(check_methodsCalled_after_run, 100));
			runner.run(spriteTest);
		}
		
		private function check_methodsCalled_after_run(e:TestResultEvent):void {
			assertEquals(15, spriteTest.methodsCalled.length);
			
			assertSame(spriteTest.runBefore1, 							spriteTest.methodsCalled[0]);
			assertSame(spriteTest.runBefore2, 							spriteTest.methodsCalled[1]);
			assertSame(spriteTest.fail_assertEquals,					spriteTest.methodsCalled[2]);
			assertSame(spriteTest.runAfter1, 							spriteTest.methodsCalled[3]);
			assertSame(spriteTest.runAfter2, 							spriteTest.methodsCalled[4]);

			assertSame(spriteTest.runBefore1, 							spriteTest.methodsCalled[5]);
			assertSame(spriteTest.runBefore2, 							spriteTest.methodsCalled[6]);
			assertSame(spriteTest.numChildren_is_0_by_default,			spriteTest.methodsCalled[7]);
			assertSame(spriteTest.runAfter1, 							spriteTest.methodsCalled[8]);
			assertSame(spriteTest.runAfter2, 							spriteTest.methodsCalled[9]);
			
			assertSame(spriteTest.runBefore1, 							spriteTest.methodsCalled[10]);
			assertSame(spriteTest.runBefore2, 							spriteTest.methodsCalled[11]);
			assertSame(spriteTest.stage_is_null_by_default, 			spriteTest.methodsCalled[12]);
			assertSame(spriteTest.runAfter1, 							spriteTest.methodsCalled[13]);
			assertSame(spriteTest.runAfter2, 							spriteTest.methodsCalled[14]);
		}
		//////
		public function test_run_triggers_TestResultEvent_with_wasSuccessful_false_and_failures():void {
			runner.addEventListener(TestResultEvent.NAME, addAsync(check_TestResult_wasSuccessful_false, 100));
			runner.run(spriteTest);
		}
		
		private function check_TestResult_wasSuccessful_false(e:TestResultEvent):void {
			//trace('failures: ' + e.testResult.failures());
			assertFalse(e.testResult.wasSuccessful);
			
			var failures:Array = e.testResult.failures;
			assertEquals('one failure in testResult', 1, failures.length);
			
			var failure0:ITestFailure = failures[0] as FreeTestFailure;
			assertSame(spriteTest, failure0.failedTest);
		}
		
	}
}
