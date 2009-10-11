package asunit.framework {
	import asunit.framework.TestCase;
	import asunit.framework.support.DoubleFailSuite;
	import asunit.framework.support.FailAssertEqualsTest;
	import asunit.framework.support.FailAssertTrueTest;

	public class TestIteratorTest extends TestCase {
		private var iterator:TestIterator;
		//private var suite:DoubleFailSuite;

		public function TestIteratorTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
		}

		protected override function tearDown():void {
			iterator = null;
		}

		public function test_countTestClasses_of_free_suite_class():void {
			assertEquals(2, TestIterator.countTestClasses(DoubleFailSuite));
		}
		
		public function test_countTestClasses_of_free_suite_instance():void {
			var suiteInstance:Object = new DoubleFailSuite();
			assertEquals(2, TestIterator.countTestClasses(suiteInstance));
		}
		
		public function test_getTestClasses_of_free_suite_class():void {
			var testClasses:Array = TestIterator.getTestClasses(DoubleFailSuite);
			
			assertEquals(2, testClasses.length);
			// In case the ordering is random, check that the array contains the class somewhere.
			assertTrue(testClasses.indexOf(FailAssertTrueTest) >= 0);
			assertTrue(testClasses.indexOf(FailAssertEqualsTest) >= 0);
		}
		
		public function test_iterator_for_null_yields_hasNext_false():void {
			iterator = new TestIterator(null);
			assertFalse(iterator.hasNext());
		}
		
		public function test_iterator_for_non_suite_yields_hasNext_false():void {
			iterator = new TestIterator(new Date());
			assertFalse(iterator.hasNext());
		}
		
		public function test_iterator_for_suite_class_with_2_tests_hasNext():void {
			iterator = new TestIterator(DoubleFailSuite);
			assertTrue(iterator.hasNext());
		}
		
		public function test_iterator_next():void {
			iterator = new TestIterator(DoubleFailSuite);
			
			assertSame(FailAssertEqualsTest,	iterator.next());
			assertSame(FailAssertTrueTest, 		iterator.next());
			
			assertFalse('no methods left in iterator', iterator.hasNext());
		}
	}
}
