package asunit4.framework {
	import asunit.framework.TestCase;
	import asunit4.support.IgnoredMethodTest;

	public class TestIteratorAsyncMethodTest extends TestCase {
		private var iterator:TestIterator;
		private var ignoredTest:IgnoredMethodTest;

		public function TestIteratorAsyncMethodTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
		}

		protected override function tearDown():void {
		}
		
		public function test_isAsync_is_true_for_async_test_instance():void {
			assertTrue(TestIterator.isAsync(new AsyncTestMethodTest()));
		}
		
		public function test_isAsync_is_true_for_async_test_class():void {
			assertTrue(TestIterator.isAsync(AsyncTestMethodTest));
		}
		
		public function test_isAsync_is_false_for_non_async_test_instance():void {
			assertFalse(TestIterator.isAsync(new NonAsyncTest()));
		}
		
		public function test_isAsync_is_false_for_non_async_test_class():void {
			assertFalse(TestIterator.isAsync(new NonAsyncTest()));
		}
		
		public function test_isAsync_is_false_for_null():void {
			assertFalse(TestIterator.isAsync(null));
		}
		
		public function test_isAsync_is_true_when_Before_is_async():void {
			assertTrue(TestIterator.isAsync(new AsyncBeforeMethodTest()));
		}
		
		public function test_isAsync_is_true_when_After_is_async():void {
			assertTrue(TestIterator.isAsync(new AsyncAfterMethodTest()));
		}
		
		public function test_isAsync_is_true_when_BeforeClass_is_async():void {
			assertTrue(TestIterator.isAsync(new AsyncBeforeClassMethodTest()));
		}
		
		public function test_isAsync_is_true_when_AfterClass_is_async():void {
			assertTrue(TestIterator.isAsync(new AsyncAfterClassMethodTest()));
		}
	}
}

//////////////////////

class AsyncTestMethodTest {
	
	[Test(async)]
	public function doNothing():void {}
		
}

class AsyncBeforeMethodTest {
	
	[Before(async)]
	public function setup():void {}
	
	[Test]
	public function doNothing():void {}
		
}

class AsyncAfterMethodTest {
	
	[After(async)]
	public function teardown():void {}
	
	[Test]
	public function doNothing():void {}
		
}

class AsyncBeforeClassMethodTest {
	
	[BeforeClass(async)]
	public function setup():void {}
	
	[Test]
	public function doNothing():void {}
		
}

class AsyncAfterClassMethodTest {
	
	[AfterClass(async)]
	public function teardown():void {}
	
	[Test]
	public function doNothing():void {}
		
}

class NonAsyncTest {
	
	[Before]
	public function setup():void { }
	
	[After]
	public function teardown():void {}
	
	[Test]
	public function doNothing():void {}
		
}

