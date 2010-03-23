package asunit.framework {

	import asunit.framework.TestCase;
    import asunit.util.Iterator;

	import asunit.support.IgnoredMethod;

	public class TestIteratorIgnoredMethodTest extends TestCase {

		private var ignoredTest:IgnoredMethod;
		private var iterator:Iterator;

		public function TestIteratorIgnoredMethodTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
            super.setUp();
			ignoredTest = new IgnoredMethod();
		}

		protected override function tearDown():void {
            super.tearDown();
			iterator = null;
		}

		public function test_iterator_for_test_with_one_ignored_test_method_hasNext_true():void {
			iterator = new TestIterator(ignoredTest);
			assertTrue(iterator.hasNext());
		}

        public function test_getTestMethods_should_not_include_ignored_test():void {
            var iterator:Iterator = new TestIterator(ignoredTest);
            assertEquals(3, iterator.length);
        }
		
		public function test_getTestMethods_should_return_ignored_test():void {
			var iterator:Iterator = new TestIterator(ignoredTest).ignoredIterator;
			
			assertEquals(1, iterator.length);
            var method:Method = iterator.next();
			assertEquals('should_be_ignored', method.name);
			assertTrue('method.ignore', method.ignore);
		}
	}
}

/*
<factory type="asunit.support::IgnoredMethod">
  <extendsClass type="Object"/>
  <method name="runAfter" declaredBy="asunit.support::IgnoredMethod" returnType="void">
    <metadata name="After"/>
  </method>
  <method name="should_be_ignored" declaredBy="asunit.support::IgnoredMethod" returnType="void">
    <metadata name="Test"/>
    <metadata name="Ignore"/>
  </method>
  <method name="runBefore" declaredBy="asunit.support::IgnoredMethod" returnType="void">
    <metadata name="Before"/>
  </method>
</factory>
*/
