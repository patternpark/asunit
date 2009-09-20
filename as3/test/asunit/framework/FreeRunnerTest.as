package asunit.framework {
	import asunit.framework.TestCase;

	public class FreeRunnerTest extends TestCase {
		private var instance:FreeRunner;
		private var freeTest:SpriteTest;

		public function FreeRunnerTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			instance = new FreeRunner();
			freeTest = new SpriteTest();
		}

		protected override function tearDown():void {
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("FreeRunner instantiated", instance is FreeRunner);
		}

		public function test_countTestMethods_of_free_test():void {
			assertEquals(2, FreeRunner.countTestMethods(freeTest));
		}
		
		public function test_getTestMethods_of_free_test():void {
			var testMethods:Array = FreeRunner.getTestMethods(freeTest);
			
			assertEquals(2, testMethods.length);
			// In case the ordering is random, check that the array contains the method somewhere.
			assertTrue(testMethods.indexOf('test_stage_is_null_by_default') >= 0);
			assertTrue(testMethods.indexOf('test_numChildren_is_0_by_default') >= 0);
		}
		
		// For now, the test methods are sorted alphabetically to enable precise testing.
		public function test_runTest_calls_setup_before_and_tearDown_after_each_test_method():void {
			instance.runTest(freeTest);
			
			assertEquals(6, freeTest.methodsCalled.length);
			
			assertSame(freeTest.setup, 								freeTest.methodsCalled[0]);
			assertSame(freeTest.test_numChildren_is_0_by_default,	freeTest.methodsCalled[1]);
			assertSame(freeTest.tearDown, 							freeTest.methodsCalled[2]);
			
			assertSame(freeTest.setup,								freeTest.methodsCalled[3]);
			assertSame(freeTest.test_stage_is_null_by_default, 		freeTest.methodsCalled[4]);
			assertSame(freeTest.tearDown, 							freeTest.methodsCalled[5]);
		}
	}
}
/////////////////////////////////////////
import flash.display.Sprite;
import asunit.framework.Assert;

class SpriteTest {
	public var methodsCalled:Array;
	protected var instance:Sprite;
	
	public function SpriteTest()
	{
		methodsCalled = [];
	}
	
	public function setup():void {
		methodsCalled.push(arguments.callee);
		trace('SpriteTest.setup()');
		instance = new Sprite();
	}
	
	public function tearDown():void {
		methodsCalled.push(arguments.callee);
		trace('SpriteTest.tearDown()');
		instance = null;
	}
	
	public function test_numChildren_is_0_by_default():void {
		methodsCalled.push(arguments.callee);
		Assert.assertEquals(0, instance.numChildren);
	}
	
	public function test_stage_is_null_by_default():void {
		methodsCalled.push(arguments.callee);
		Assert.assertNull(instance.stage);
	}
	
}