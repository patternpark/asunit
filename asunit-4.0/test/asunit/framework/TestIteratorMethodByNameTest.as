package asunit.framework {

	import asunit.framework.TestCase;

	import asunit.support.MultiMethod;

	public class TestIteratorMethodByNameTest extends TestCase {

		private var iterator:TestIterator;
		private var multiTest:MultiMethod;

		public function TestIteratorMethodByNameTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			multiTest = new MultiMethod();
		}

		protected override function tearDown():void {
			iterator = null;
			multiTest = null;
		}
		
		public function test_iterator_next_with_test_method_by_name():void {
			iterator = new TestIterator(multiTest, 'stage_is_null_by_default');
			checkAllNextCalls(iterator);
		}
		
		private function checkAllNextCalls(iterator:TestIterator):void {
			assertSame('runBeforeClass1', 				iterator.next().name);
			assertSame('runBeforeClass2', 				iterator.next().name);
			
			assertSame('runBefore1', 					iterator.next().name);
			assertSame('runBefore2', 					iterator.next().name);
			assertSame('stage_is_null_by_default', 		iterator.next().name);

            // NOTE: When a method name is provided, the teardown should
            // not occur.
			//assertSame('runAfter1', 					iterator.next().name);
			//assertSame('runAfter2', 					iterator.next().name);
			
			//assertSame('runAfterClass1', 				iterator.next().name);
			//assertSame('runAfterClass2', 				iterator.next().name);
			
			assertFalse('no methods left in iterator',	iterator.hasNext());
		}
		
	}
}
