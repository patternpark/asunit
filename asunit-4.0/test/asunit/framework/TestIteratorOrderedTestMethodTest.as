package asunit.framework {

	import asunit.framework.TestCase;
    import asunit.util.Iterator;

	import asunit.support.OrderedTestMethod;

	public class TestIteratorOrderedTestMethodTest extends TestCase {

		private var iterator:Iterator;
		private var orderedTest:OrderedTestMethod;

		public function TestIteratorOrderedTestMethodTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
            super.setUp();
			orderedTest = new OrderedTestMethod();
		}

		protected override function tearDown():void {
            super.tearDown();
			iterator    = null;
			orderedTest = null;
		}

		public function test_countTestMethods_of_test():void {
            iterator = new TestIterator(orderedTest);
			assertEquals(4, iterator.length);
		}
		
		public function test_get_test_methods_of_test_instance():void {
			//NOTE: Avoid naming variables the same as testMethods property in asunit.framework.TestCase.
            var iterator:Iterator = new TestIterator(orderedTest);
			
			assertEquals(4, iterator.length);
            var first:Method = iterator.next();
            var second:Method = iterator.next();
            var third:Method = iterator.next();
            var fourth:Method = iterator.next();

            assertFalse("Should be out of items", iterator.next());

			assertEquals(first.name,  'negativeOrderIsAllowed');
			assertEquals(second.name, 'zeroIsDefaultOrder');
			assertEquals(third.name,  'two');
			assertEquals(fourth.name, 'three');
			
			assertEquals(orderedTest.negativeOrderIsAllowed, 	first.value);
			assertEquals(orderedTest.zeroIsDefaultOrder,		second.value);
			assertEquals(orderedTest.two, 						third.value);
			assertEquals(orderedTest.three, 					fourth.value);
		}
	}
}

