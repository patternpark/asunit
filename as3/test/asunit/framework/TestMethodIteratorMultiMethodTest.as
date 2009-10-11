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
			assertTrue(beforeMethods.indexOf('runBefore1') >= 0);
			assertTrue(beforeMethods.indexOf('runBefore2') >= 0);
		}
		
		public function test_get_test_methods_of_free_test_by_metadata():void {
			var testMethods:Array = TestMethodIterator.getTestMethods(multiTest);
			
			assertEquals(3, testMethods.length);
			// In case the ordering is random, check that the array contains the method somewhere.
			assertTrue(testMethods.indexOf('stage_is_null_by_default') >= 0);
			assertTrue(testMethods.indexOf('numChildren_is_0_by_default') >= 0);
			assertTrue(testMethods.indexOf('fail_assertEquals') >= 0);
		}
		
		public function test_get_after_methods_of_free_test_by_metadata():void {
			var afterMethods:Array = TestMethodIterator.getAfterMethods(multiTest);
			
			assertEquals(2, afterMethods.length);
			// In case the ordering is random, check that the array contains the method somewhere.
			assertTrue(afterMethods.indexOf('runAfter1') >= 0);
			assertTrue(afterMethods.indexOf('runAfter2') >= 0);
		}
		

		public function test_iterator_next():void {
			iterator = new TestMethodIterator(multiTest);
			
			assertSame('runBefore1', 					iterator.next());
			assertSame('runBefore2', 					iterator.next());
			assertSame('fail_assertEquals',				iterator.next());
			assertSame('runAfter1', 					iterator.next());
			assertSame('runAfter2', 					iterator.next());

			assertSame('runBefore1', 					iterator.next());
			assertSame('runBefore2', 					iterator.next());
			assertSame('numChildren_is_0_by_default',	iterator.next());
			assertSame('runAfter1', 					iterator.next());
			assertSame('runAfter2', 					iterator.next());
			
			assertSame('runBefore1', 					iterator.next());
			assertSame('runBefore2', 					iterator.next());
			assertSame('stage_is_null_by_default', 		iterator.next());
			assertSame('runAfter1', 					iterator.next());
			assertSame('runAfter2', 					iterator.next());
			
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
