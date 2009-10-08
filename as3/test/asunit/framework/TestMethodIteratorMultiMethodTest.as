package asunit.framework {
	import asunit.framework.TestCase;
	import asunit.framework.support.SpriteMetadataTest;

	public class TestMethodIteratorMultiMethodTest extends TestCase {
		private var iterator:TestMethodIterator;
		private var multiTest:SpriteMetadataTest;

		public function TestMethodIteratorMultiMethodTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			multiTest = new SpriteMetadataTest();
		}

		protected override function tearDown():void {
			iterator = null;
			multiTest = null;
		}

		public function test_iterator_next():void {
			iterator = new TestMethodIterator(multiTest);
			
			assertSame('runBefore1', 					iterator.next());
			assertSame('runBefore2', 					iterator.next());
			assertSame('fail_assertEquals',				iterator.next());
			assertSame('runAfter1', 					iterator.next());
			assertSame('runAfter2', 					iterator.next());

			assertSame('runBefore1', 					iterator.next());
			assertSame('runBefore2', 					iterator.next());
			assertSame('numChildren_is_0_by_default',	iterator.next());
			assertSame('runAfter1', 					iterator.next());
			assertSame('runAfter2', 					iterator.next());
			
			assertSame('runBefore1', 					iterator.next());
			assertSame('runBefore2', 					iterator.next());
			assertSame('stage_is_null_by_default', 		iterator.next());
			assertSame('runAfter1', 					iterator.next());
			assertSame('runAfter2', 					iterator.next());
			
			assertFalse('no methods left in iterator', iterator.hasNext());
		}
		
		public function test_iterator_exhausted_with_while_loop_then_reset_should_hasNext():void {
			iterator = new TestMethodIterator(multiTest);
			while (iterator.hasNext()) { iterator.next(); }
			iterator.reset();
			
			assertTrue(iterator.hasNext());
		}
		
	}
}
