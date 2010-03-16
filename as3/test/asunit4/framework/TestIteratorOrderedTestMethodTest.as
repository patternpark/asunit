package asunit4.framework {

	import asunit.framework.TestCase;

	import asunit4.support.OrderedTestMethodTest;

	public class TestIteratorOrderedTestMethodTest extends TestCase {

		private var iterator:TestIterator;
		private var orderedTest:OrderedTestMethodTest;

		public function TestIteratorOrderedTestMethodTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			orderedTest = new OrderedTestMethodTest();
		}

		protected override function tearDown():void {
			iterator = null;
			orderedTest = null;
		}

		public function test_countTestMethods_of_test():void {
			assertEquals(4, TestIterator.countTestMethods(orderedTest));
		}
		
		public function test_get_test_methods_of_test_instance():void {
			//NOTE: Avoid naming variables the same as testMethods property in asunit.framework.TestCase.
			var theTestMethods:Array = TestIterator.getTestMethods(orderedTest);
			
			assertEquals(4, theTestMethods.length);
			assertEquals(theTestMethods[0].name, 'negativeOrderIsAllowed');
			assertEquals(theTestMethods[1].name, 'zeroIsDefaultOrder');
			assertEquals(theTestMethods[2].name, 'two');
			assertEquals(theTestMethods[3].name, 'three');
			
			assertEquals(orderedTest.negativeOrderIsAllowed, 	theTestMethods[0].value);
			assertEquals(orderedTest.zeroIsDefaultOrder,		theTestMethods[1].value);
			assertEquals(orderedTest.two, 						theTestMethods[2].value);
			assertEquals(orderedTest.three, 					theTestMethods[3].value);
		}
		
		public function test_iterator_next_with_test_instance():void {
			iterator = new TestIterator(orderedTest);
			checkAllNextCalls(iterator);
		}
		
		private function checkAllNextCalls(iterator:TestIterator):void {
			assertSame('negativeOrderIsAllowed',	iterator.next().name);
			assertSame('zeroIsDefaultOrder', 		iterator.next().name);
			assertSame('two', 						iterator.next().name);
			assertSame('three', 					iterator.next().name);
			
			assertFalse('no methods left in iterator',	iterator.hasNext());
		}
	}
}

