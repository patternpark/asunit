package asunit.framework {

	import asunit.framework.TestCase;
    import asunit.util.ArrayIterator;
    import asunit.util.Iterator;

	import asunit.support.MultiMethod;

	public class TestIteratorMultiMethodTest extends TestCase {

		private var multiTest:MultiMethod;

		public function TestIteratorMultiMethodTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
            super.setUp();
			multiTest = new MultiMethod();
		}

		protected override function tearDown():void {
            super.setUp();
			multiTest = null;
		}

        private function verifyMethods(actual:Iterator, expectedItems:Array):void {
            var expected:Iterator = new ArrayIterator(expectedItems);
			assertEquals(expected.length, actual.length);
            var actualMethod:Method;
            var expectedMethod:Object;
            for(var i:uint; i < expected.length; i++) {
                actualMethod = actual.next();
                expectedMethod = expected.next();
                assertEquals(expectedMethod.name, actualMethod.name);
                assertSame(expectedMethod.name + " with wrong value", expectedMethod.value, actualMethod.value);
            }
        }

		public function test_get_BeforeClass_methods_of_test_instance():void {
            var iterator:Iterator = new TestIterator(multiTest).beforeClassIterator;
            var methods:Array = [
                { name: 'runBeforeClass1', value: MultiMethod.runBeforeClass1 },
                { name: 'runBeforeClass2', value: MultiMethod.runBeforeClass2 }
            ];

            verifyMethods(iterator, methods);
		}
		
		public function test_get_AfterClass_methods_of_test_instance():void {
			var iterator:Iterator = new TestIterator(multiTest).afterClassIterator;
            var methods:Array = [
                { name: 'runAfterClass1', value: MultiMethod.runAfterClass1 },
                { name: 'runAfterClass2', value: MultiMethod.runAfterClass2 }
            ];

            verifyMethods(iterator, methods);
		}

		public function test_get_before_methods_of_test_instance():void {
			var iterator:Iterator = new TestIterator(multiTest).beforeIterator;
            var methods:Array = [
                { name: 'runBefore1', value: multiTest.runBefore1 },
                { name: 'runBefore2', value: multiTest.runBefore2 },
            ];

			verifyMethods(iterator, methods);
		}
		
		public function test_get_test_methods_of_test_instance():void {
			//NOTE: Avoid naming variables the same as testMethods property in asunit.framework.TestCase.
			var iterator:Iterator = new TestIterator(multiTest).testMethodsIterator;
            var methods:Array = [
                { name: 'fail_assertEquals', value: multiTest.fail_assertEquals },
                { name: 'numChildren_is_0_by_default', value: multiTest.numChildren_is_0_by_default },
                { name: 'stage_is_null_by_default', value: multiTest.stage_is_null_by_default }
            ];

            verifyMethods(iterator, methods);
		}
		
		public function test_get_after_methods_of_test_instance():void {
			var iterator:Iterator = new TestIterator(multiTest).afterIterator;
            var methods:Array = [
                { name: 'runAfter1', value: multiTest.runAfter1 },
                { name: 'runAfter2', value: multiTest.runAfter2 }
            ];

            verifyMethods(iterator, methods);
        }
				
		public function testIteratorNext():void {
			var iterator:Iterator = new TestIterator(multiTest); // Use this to ensure we use the Iterator interface
            var testIterator:TestIterator = iterator as TestIterator; // Use this to check TestIterator interface

            assertTrue('setup a',                       testIterator.readyToSetUp);
            assertFalse('teardown a',                   testIterator.readyToTearDown);
            assertEquals('runBeforeClass1', 			iterator.next().name);
            assertFalse('setup b',                      testIterator.readyToSetUp);
            assertFalse('teardown b',                   testIterator.readyToTearDown);
			assertEquals('runBeforeClass2', 		    iterator.next().name);

            assertFalse('setup c',                      testIterator.readyToSetUp);
            assertFalse('teardown c',                   testIterator.readyToTearDown);
			
			assertEquals('runBefore1', 					iterator.next().name);
            assertFalse('setup d',                      testIterator.readyToSetUp);
            assertFalse('teardown d',                   testIterator.readyToTearDown);
            assertFalse('setup e',                      testIterator.readyToSetUp);
			assertEquals('runBefore2', 					iterator.next().name);
            assertFalse('setup e',                      testIterator.readyToSetUp);
            assertFalse('teardown e',                   testIterator.readyToTearDown);
			assertEquals('fail_assertEquals',			iterator.next().name);
            assertFalse('setup f',                      testIterator.readyToSetUp);
            assertFalse('teardown f',                   testIterator.readyToTearDown);
			assertEquals('runAfter1', 					iterator.next().name);
            assertFalse('setup g',                      testIterator.readyToSetUp);
            assertFalse('teardown g',                   testIterator.readyToTearDown);
			assertEquals('runAfter2', 					iterator.next().name);

            assertTrue('setup h',                       testIterator.readyToSetUp);
            assertTrue('teardown h',                    testIterator.readyToTearDown);

			assertEquals('runBefore1', 					iterator.next().name);
            assertFalse('setup i',                      testIterator.readyToSetUp);
            assertFalse('teardown i',                   testIterator.readyToTearDown);
			assertEquals('runBefore2', 					iterator.next().name);
            assertFalse('setup j',                      testIterator.readyToSetUp);
            assertFalse('teardown j',                   testIterator.readyToTearDown);
			assertEquals('numChildren_is_0_by_default',	iterator.next().name);
            assertFalse('setup k',                      testIterator.readyToSetUp);
            assertFalse('teardown k',                   testIterator.readyToTearDown);
			assertEquals('runAfter1', 					iterator.next().name);
            assertFalse('setup l',                      testIterator.readyToSetUp);
            assertFalse('teardown l',                   testIterator.readyToTearDown);
			assertEquals('runAfter2', 					iterator.next().name);

            assertTrue('setup m',                       testIterator.readyToSetUp);
            assertTrue('teardown m',                    testIterator.readyToTearDown);
			
			assertEquals('runBefore1', 					iterator.next().name);
            assertFalse('setup n',                      testIterator.readyToSetUp);
            assertFalse('teardown n',                   testIterator.readyToTearDown);
			assertEquals('runBefore2', 					iterator.next().name);
            assertFalse('setup o',                      testIterator.readyToSetUp);
            assertFalse('teardown o',                   testIterator.readyToTearDown);
			assertEquals('stage_is_null_by_default', 	iterator.next().name);
            assertFalse('setup p',                      testIterator.readyToSetUp);
            assertFalse('teardown p',                   testIterator.readyToTearDown);
			assertEquals('runAfter1', 					iterator.next().name);
            assertFalse('setup q',                      testIterator.readyToSetUp);
            assertFalse('teardown q',                   testIterator.readyToTearDown);
			assertEquals('runAfter2', 					iterator.next().name);

            assertFalse('setup r',                      testIterator.readyToSetUp); // No more setUps remaining!
            assertTrue('teardown r',                    testIterator.readyToTearDown);
			
			assertEquals('runAfterClass1', 				iterator.next().name);
            assertFalse('setup s',                      testIterator.readyToSetUp);
            assertFalse('teardown s',                   testIterator.readyToTearDown);
			assertEquals('runAfterClass2', 				iterator.next().name);
            assertFalse('setup t',                      testIterator.readyToSetUp);
            assertFalse('teardown t',                   testIterator.readyToTearDown);
			
			assertFalse('no methods left in iterator',	iterator.hasNext());
		}
		
		public function testIteratorExhaustedWithWhileLoopThenResetShouldHasNext():void {
			var iterator:Iterator = new TestIterator(multiTest);
			while(iterator.hasNext()) {
                iterator.next();
            }
			iterator.reset();
			
			assertTrue(iterator.hasNext());
		}

        public function testIteratorLength():void {
            // TestIterator.length reflects all methods that will be called...
            // not just test methods and not all non-test methods * test methods.
            var iterator:TestIterator = new TestIterator(multiTest);
            assertEquals(19, iterator.length);
        }
	}
}

