package asunit4 {
	import asunit.framework.TestCase;
	import asunit4.support.FreeTestWithSprite;

	public class TestMethodIteratorMultiMethodTest extends TestCase {
		private var iterator:TestIterator;
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
			assertEquals(3, TestIterator.countTestMethods(multiTest));
		}
		
		public function test_get_before_methods_of_test_instance():void {
			var beforeMethods:Array = TestIterator.getBeforeMethods(multiTest);
			
			assertEquals(2, beforeMethods.length);
			assertEquals(beforeMethods[0].name, 'runBefore1');
			assertEquals(beforeMethods[1].name, 'runBefore2');
		}
		
		public function test_get_before_methods_of_test_class():void {
			var beforeMethods:Array = TestIterator.getBeforeMethods(FreeTestWithSprite);
			
			assertEquals(2, beforeMethods.length);
			assertEquals(beforeMethods[0].name, 'runBefore1');
			assertEquals(beforeMethods[1].name, 'runBefore2');
		}
		
		public function test_get_test_methods_of_test_instance():void {
			var testMethods:Array = TestIterator.getTestMethods(multiTest);
			
			assertEquals(3, testMethods.length);
			assertEquals(testMethods[0].name, 'fail_assertEquals');
			assertEquals(testMethods[1].name, 'numChildren_is_0_by_default');
			assertEquals(testMethods[2].name, 'stage_is_null_by_default');
		}
		
		public function test_get_test_methods_of_test_class():void {
			var testMethods:Array = TestIterator.getTestMethods(FreeTestWithSprite);
			
			assertEquals(3, testMethods.length);
			assertEquals(testMethods[0].name, 'fail_assertEquals');
			assertEquals(testMethods[1].name, 'numChildren_is_0_by_default');
			assertEquals(testMethods[2].name, 'stage_is_null_by_default');
		}
		
		public function test_get_after_methods_of_test_instance():void {
			var afterMethods:Array = TestIterator.getAfterMethods(multiTest);
			
			assertEquals(2, afterMethods.length);
			assertEquals(afterMethods[0].name, 'runAfter1');
			assertEquals(afterMethods[1].name, 'runAfter2');
		}
		
		public function test_get_after_methods_of_test_class():void {
			var afterMethods:Array = TestIterator.getAfterMethods(FreeTestWithSprite);
			
			assertEquals(2, afterMethods.length);
			assertEquals(afterMethods[0].name, 'runAfter1');
			assertEquals(afterMethods[1].name, 'runAfter2');
		}

		public function test_iterator_next_with_test_instance():void {
			iterator = new TestIterator(multiTest);
			checkAllNextCalls(iterator);
		}
		
		public function test_iterator_next_with_test_class():void {
			iterator = new TestIterator(FreeTestWithSprite);
			checkAllNextCalls(iterator);
		}
		
		private function checkAllNextCalls(iterator:TestIterator):void {
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
			
			assertFalse('no methods left in iterator',	iterator.hasNext());
		}
		
		public function test_iterator_exhausted_with_while_loop_then_reset_should_hasNext():void {
			iterator = new TestIterator(multiTest);
			while (iterator.hasNext()) { iterator.next(); }
			iterator.reset();
			
			assertTrue(iterator.hasNext());
		}
		
		public function test_multiTest_iterator_is_not_async():void {
			iterator  = new TestIterator(multiTest);
			assertFalse(iterator.async);
		}
		
	}
}
