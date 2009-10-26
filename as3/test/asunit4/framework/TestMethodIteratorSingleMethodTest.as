package asunit4.framework {
	import asunit.framework.TestCase;
	import asunit4.support.FailAssertTrueTest;

	public class TestMethodIteratorSingleMethodTest extends TestCase {
		private var iterator:TestIterator;
		private var singleTest:FailAssertTrueTest;

		public function TestMethodIteratorSingleMethodTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			singleTest = new FailAssertTrueTest();
		}

		protected override function tearDown():void {
			iterator = null;
		}

		public function test_iterator_for_null_yields_hasNext_false():void {
			iterator = new TestIterator(null);
			assertFalse(iterator.hasNext());
		}
		
		public function test_iterator_for_non_test_yields_hasNext_false():void {
			iterator = new TestIterator(new Date());
			assertFalse(iterator.hasNext());
		}
		
		public function test_iterator_for_test_with_one_test_method_hasNext():void {
			iterator = new TestIterator(singleTest);
			assertTrue(iterator.hasNext());
		}
		
		public function test_iterator_next():void {
			iterator = new TestIterator(singleTest);
			
			assertEquals('runBefore', 		String(iterator.next()));
			assertEquals('fail_assertTrue',	String(iterator.next()));
			assertEquals('runAfter',		String(iterator.next()));
			
			assertFalse('no methods left in iterator', iterator.hasNext());
		}
	}
}

class NoBeforeOrAfterTest {
	
}
