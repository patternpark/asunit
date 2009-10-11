package asunit.framework {
	import asunit.framework.TestCase;
	import asunit.framework.support.FreeTestWithSprite;

	public class TestMethodIteratorMultiMethodTest extends TestCase {
		private var iterator:TestMethodIterator;
		private var multiTest:FreeTestWithSprite;

		public function TestMethodIteratorMultiMethodTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			multiTest = new FreeTestWithSprite();
		}

		protected override function tearDown():void {
			iterator = null;
			multiTest = null;
		}

		public function test_countTestMethods_of_free_test():void {
			assertEquals(3, TestMethodIterator.countTestMethods(multiTest));
		}
		
		public function test_get_before_methods_of_free_test_by_metadata():void {
			var beforeMethods:Array = TestMethodIterator.getBeforeMethods(multiTest);
			
			assertEquals(2, beforeMethods.length);
			// In case the ordering is random, check that the array contains the method somewhere.
			assertEquals(beforeMethods[0].name, 'runBefore1');
			assertEquals(beforeMethods[1].name, 'runBefore2');
		}
		
		public function test_get_test_methods_of_free_test_by_metadata():void {
			var testMethods:Array = TestMethodIterator.getTestMethods(multiTest);
			
			assertEquals(3, testMethods.length);
			// In case the ordering is random, check that the array contains the method somewhere.
			assertEquals(testMethods[0].name, 'fail_assertEquals');
			assertEquals(testMethods[1].name, 'numChildren_is_0_by_default');
			assertEquals(testMethods[2].name, 'stage_is_null_by_default');
		}
		
		public function test_get_after_methods_of_free_test_by_metadata():void {
			var afterMethods:Array = TestMethodIterator.getAfterMethods(multiTest);
			
			assertEquals(2, afterMethods.length);
			// In case the ordering is random, check that the array contains the method somewhere.
			assertEquals(afterMethods[0].name, 'runAfter1');
			assertEquals(afterMethods[1].name, 'runAfter2');
		}
		

		public function test_iterator_next():void {
			iterator = new TestMethodIterator(multiTest);
			
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
			
			assertFalse('no methods left in iterator', iterator.hasNext());
		}
		
		public function test_iterator_exhausted_with_while_loop_then_reset_should_hasNext():void {
			iterator = new TestMethodIterator(multiTest);
			while (iterator.hasNext()) { iterator.next(); }
			iterator.reset();
			
			assertTrue(iterator.hasNext());
		}
		
	}
}
