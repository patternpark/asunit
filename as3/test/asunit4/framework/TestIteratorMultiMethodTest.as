package asunit4.framework {
	import asunit.framework.TestCase;
	import asunit4.support.TestWithSprite;

	public class TestIteratorMultiMethodTest extends TestCase {
		private var iterator:TestIterator;
		private var multiTest:TestWithSprite;

		public function TestIteratorMultiMethodTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			multiTest = new TestWithSprite();
		}

		protected override function tearDown():void {
			iterator = null;
			multiTest = null;
		}

		public function test_countTestMethods_of_test():void {
			assertEquals(3, TestIterator.countTestMethods(multiTest));
		}
		
		public function test_get_BeforeClass_methods_of_test_instance():void {
			var beforeClassMethods:Array = TestIterator.getBeforeClassMethods(multiTest);
			
			assertEquals(2, beforeClassMethods.length);
			assertEquals(beforeClassMethods[0].name, 'runBeforeClass1');
			assertEquals(beforeClassMethods[1].name, 'runBeforeClass2');
			
			assertEquals(beforeClassMethods[0].value, TestWithSprite.runBeforeClass1);
			assertEquals(beforeClassMethods[1].value, TestWithSprite.runBeforeClass2);
		}
		
		public function test_get_AfterClass_methods_of_test_instance():void {
			var afterClassMethods:Array = TestIterator.getAfterClassMethods(multiTest);
			
			assertEquals(2, afterClassMethods.length);
			assertEquals(afterClassMethods[0].name, 'runAfterClass1');
			assertEquals(afterClassMethods[1].name, 'runAfterClass2');
			
			assertEquals(afterClassMethods[0].value, TestWithSprite.runAfterClass1);
			assertEquals(afterClassMethods[1].value, TestWithSprite.runAfterClass2);
		}
		
		public function test_get_before_methods_of_test_instance():void {
			var beforeMethods:Array = TestIterator.getBeforeMethods(multiTest);
			
			assertEquals(2, beforeMethods.length);
			assertEquals(beforeMethods[0].name, 'runBefore1');
			assertEquals(beforeMethods[1].name, 'runBefore2');
		}
		
		public function test_get_before_methods_of_test_class():void {
			var beforeMethods:Array = TestIterator.getBeforeMethods(TestWithSprite);
			
			assertEquals(2, beforeMethods.length);
			assertEquals(beforeMethods[0].name, 'runBefore1');
			assertEquals(beforeMethods[1].name, 'runBefore2');
		}
		
		public function test_get_test_methods_of_test_instance():void {
			//NOTE: TestCase has protected testMethods property.
			var theTestMethods:Array = TestIterator.getTestMethods(multiTest);
			
			assertEquals(3, theTestMethods.length);
			assertEquals(theTestMethods[0].name, 'fail_assertEquals');
			assertEquals(theTestMethods[1].name, 'numChildren_is_0_by_default');
			assertEquals(theTestMethods[2].name, 'stage_is_null_by_default');
			
			assertEquals(multiTest.fail_assertEquals, 			theTestMethods[0].value);
			assertEquals(multiTest.numChildren_is_0_by_default,	theTestMethods[1].value);
			assertEquals(multiTest.stage_is_null_by_default, 	theTestMethods[2].value);
		}
		
		public function test_get_test_methods_of_test_class():void {
			var theTestMethods:Array = TestIterator.getTestMethods(TestWithSprite);
			
			assertEquals(3, theTestMethods.length);
			assertEquals(theTestMethods[0].name, 'fail_assertEquals');
			assertEquals(theTestMethods[1].name, 'numChildren_is_0_by_default');
			assertEquals(theTestMethods[2].name, 'stage_is_null_by_default');
			
			// method.value is null when the class is passed of an instance
			//TODO: perhaps throw an Error instead to force not to pass a class
			assertNull(theTestMethods[0].value);
			assertNull(theTestMethods[1].value);
			assertNull(theTestMethods[2].value);
		}
		
		public function test_get_after_methods_of_test_instance():void {
			var afterMethods:Array = TestIterator.getAfterMethods(multiTest);
			
			assertEquals(2, afterMethods.length);
			assertEquals(afterMethods[0].name, 'runAfter1');
			assertEquals(afterMethods[1].name, 'runAfter2');
			
			assertEquals(afterMethods[0].value, multiTest.runAfter1);
			assertEquals(afterMethods[1].value, multiTest.runAfter2);
		}
		
		public function test_get_after_methods_of_test_class():void {
			var afterMethods:Array = TestIterator.getAfterMethods(TestWithSprite);
			
			assertEquals(2, afterMethods.length);
			assertEquals(afterMethods[0].name, 'runAfter1');
			assertEquals(afterMethods[1].name, 'runAfter2');
		}

		public function test_iterator_next_with_test_instance():void {
			iterator = new TestIterator(multiTest);
			checkAllNextCalls(iterator);
		}
		
		public function test_creating_iterator_test_class_throws_Error():void {
			assertThrows(ArgumentError, function():void { new TestIterator(TestWithSprite); } );
		}
		
		private function checkAllNextCalls(iterator:TestIterator):void {
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
