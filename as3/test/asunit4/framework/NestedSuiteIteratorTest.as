package asunit4.framework {
	import asunit.framework.TestCase;
	import asunit4.support.FailAssertEqualsTest;
	import asunit4.support.FailAssertTrueTest;
	import asunit4.support.SuiteOfTwoSuites;
	import asunit4.support.SucceedAssertTrueTest;

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

		public function test_countTestClasses_of_suite_class():void {
			assertEquals(3, SuiteIterator.countTestClasses(suiteClass));
		}
		
		public function test_isSuite_with_suite_class():void {
			assertTrue(SuiteIterator.isSuite(suiteClass));
		}
		
		public function test_isSuite_false_with_test_class():void {
			assertFalse(SuiteIterator.isSuite(SucceedAssertTrueTest));
		}
		
		public function test_getTestClasses_of_suite_class():void {
			var testClasses:Array = SuiteIterator.getTestClasses(suiteClass);
			
			assertEquals(3, testClasses.length);
			// In case the ordering is random, check that the array contains the class somewhere.
			assertTrue(testClasses.indexOf(FailAssertTrueTest) >= 0);
			assertTrue(testClasses.indexOf(FailAssertEqualsTest) >= 0);
			assertTrue(testClasses.indexOf(SucceedAssertTrueTest) >= 0);
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
