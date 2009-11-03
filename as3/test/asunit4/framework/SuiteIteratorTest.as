package asunit4.framework {
	import asunit.framework.TestCase;
	import asunit4.support.DoubleFailSuite;
	import asunit4.support.FailAssertEqualsTest;
	import asunit4.support.FailAssertTrueTest;

	public class SuiteIteratorTest extends TestCase {
		private var iterator:SuiteIterator;
		private var suiteClass:Class;

		public function SuiteIteratorTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			suiteClass = DoubleFailSuite;
		}

		protected override function tearDown():void {
			iterator = null;
		}

		public function test_countTestClasses_of_suite_class():void {
			assertEquals(2, SuiteIterator.countTestClasses(suiteClass));
		}
		
		public function test_isSuite_with_suite_class():void {
			assertTrue(SuiteIterator.isSuite(suiteClass));
		}
		
		public function test_isSuite_false_with_non_suite_class():void {
			assertFalse(SuiteIterator.isSuite(Date));
		}
		
		public function test_isSuite_false_with_test_class():void {
			assertFalse(SuiteIterator.isSuite(FailAssertEqualsTest));
		}
		
		public function test_getTestClasses_of_suite_class():void {
			var testClasses:Array = SuiteIterator.getTestClasses(suiteClass);
			
			assertEquals(2, testClasses.length);
			// In case the ordering is random, check that the array contains the class somewhere.
			assertTrue(testClasses.indexOf(FailAssertTrueTest) >= 0);
			assertTrue(testClasses.indexOf(FailAssertEqualsTest) >= 0);
		}
		
		public function test_getTestClasses_on_test_class_to_should_return_array_with_test():void {
			var testClasses:Array = SuiteIterator.getTestClasses(FailAssertTrueTest);
			
			assertEquals(1, testClasses.length);
			assertSame(FailAssertTrueTest, Class(testClasses[0]));
		}
		
		public function test_iterator_for_non_suite_class_yields_hasNext_false():void {
			iterator = new SuiteIterator(Date);
			assertFalse(iterator.hasNext());
		}
		
		public function test_iterator_for_suite_class_with_2_tests_hasNext():void {
			iterator = new SuiteIterator(suiteClass);
			assertTrue(iterator.hasNext());
		}
		
		public function test_iterator_next():void {
			iterator = new SuiteIterator(suiteClass);
			
			assertSame(FailAssertEqualsTest,	iterator.next());
			assertSame(FailAssertTrueTest, 		iterator.next());
			
			assertFalse('no methods left in iterator', iterator.hasNext());
		}
	}
}
