package asunit4.framework {

	import asunit.framework.TestCase;

	import asunit4.support.FailAssertEqualsTest;
	import asunit4.support.FailAssertTrueTest;
	import asunit4.support.SucceedAssertTrueTest;
	import asunit4.support.SuiteOfTwoSuites;

	public class NestedSuiteIteratorTest extends TestCase {
		private var iterator:SuiteIterator;
		private var suiteClass:Class;

		public function NestedSuiteIteratorTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			suiteClass = SuiteOfTwoSuites;
		}

		protected override function tearDown():void {
			iterator = null;
		}

		public function test_length_from_SuiteIterator():void {
            var iterator:SuiteIterator = new SuiteIterator(suiteClass);
			assertEquals(3, iterator.length);
		}

		public function test_isSuite_false_with_test_class():void {
            var iterator:SuiteIterator = new SuiteIterator(SucceedAssertTrueTest);
			assertEquals(1, iterator.length);
		}
		
		public function test_getTestClasses_of_suite_class():void {
            var iterator:SuiteIterator = new SuiteIterator(suiteClass);
			assertEquals(3, iterator.length);
            assertSame(FailAssertEqualsTest, iterator.next());
            assertSame(FailAssertTrueTest, iterator.next());
            assertSame(SucceedAssertTrueTest, iterator.next());
		}
		
		public function test_iterator_for_suite_class_with_2_nested_suites_hasNext():void {
			iterator = new SuiteIterator(suiteClass);
			assertTrue(iterator.hasNext());
		}
		
		public function test_iterator_next():void {
			iterator = new SuiteIterator(suiteClass);
			
			assertSame(FailAssertEqualsTest,	iterator.next());
			assertSame(FailAssertTrueTest, 		iterator.next());
			assertSame(SucceedAssertTrueTest,	iterator.next());
			
			assertFalse('no methods left in iterator', iterator.hasNext());
		}
	}
}
