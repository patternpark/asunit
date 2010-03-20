package asunit4.framework {

	import asunit.framework.TestCase;
    import asunit.util.ArrayIterator;
    import asunit.util.Iterator;

	import asunit4.support.MultiMethod;

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
				
		public function test_iterator_next_with_test_instance():void {
			var iterator:Iterator = new TestIterator(multiTest);

			assertSame('runBeforeClass1', 				iterator.next().name);
			assertSame('runBeforeClass2', 				iterator.next().name);
			
			assertSame('runBefore1', 					iterator.next().name);
			assertSame('runBefore2', 					iterator.next().name);
			assertSame('fail_assertEquals',				iterator.next().name);
			assertSame('runAfter1', 					iterator.next().name);
			assertSame('runAfter2', 					iterator.next().name);

			assertSame('runBefore1', 					iterator.next().name);
			assertSame('runBefore2', 					iterator.next().name);
			assertSame('numChildren_is_0_by_default',	iterator.next().name);
			assertSame('runAfter1', 					iterator.next().name);
			assertSame('runAfter2', 					iterator.next().name);
			
			assertSame('runBefore1', 					iterator.next().name);
			assertSame('runBefore2', 					iterator.next().name);
			assertSame('stage_is_null_by_default', 		iterator.next().name);
			assertSame('runAfter1', 					iterator.next().name);
			assertSame('runAfter2', 					iterator.next().name);
			
			assertSame('runAfterClass1', 				iterator.next().name);
			assertSame('runAfterClass2', 				iterator.next().name);
			
			assertFalse('no methods left in iterator',	iterator.hasNext());
		}
		
		public function test_iterator_exhausted_with_while_loop_then_reset_should_hasNext():void {
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

