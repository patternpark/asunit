import asunit.framework.TestCase;
import asunit.framework.Assert;

class asunit.framework.AssertTest extends TestCase {

	public var className:String = "asunit.framework.AssertTest";

	public function AssertTest(testMethod:String) {
		super(testMethod);
	}

	public function testAssertTrue():Void {
		assertTrue(true);
	}
	
	public function testAssertFalse():Void {
		assertFalse(false);
	}
	
	public function testAssertFalseWithMessage():Void {
		assertFalse("message", false);
	}
	
	public function testAssertTrueWithMessage():Void {
		assertTrue("message", true);
	}

	public function testAssertTrueFailure():Void {
		try {
			assertTrue(false);
		}
		catch(e:Error) {
			return;
		}
		assertTrue("assertTrue(false) should have failed but didn't", false);
	}

	public function testAssertTrueMessage():Void {
		assertTrue("asertTrue with message", true);
	}

	public function testAssertTrueMessageFailure():Void {
		try {
			assertTrue("trueMessage", false);
		}
		catch(e:Error) {
			return;
		}
		assertTrue("assertTrue('message', false) should have failed but didn't", false);
	}

	public function testFail():Void {
		try {
			Assert.fail("this shouldn't be caught");
		}
		catch(e:Error) {
			assertTrue("passed", true);
			return;
		}
		fail("failure should be thrown");
	}
	
	public function testAssertEqualsSimple():Void {
		var obj1:Object = new Object();
		assertEquals(obj1, obj1);
	}
	
	public function testEqualsMethod():Void {
		var obj1:Object = new Object();
		obj1.equals = function():Boolean {
			return true;
		};
		
		var obj2:Object = new Object();
		obj2.equals = function():Boolean {
			return true;
		};
		assertEquals(obj1, obj2);
	}
	
	public function testEqualsSimpleMessage():Void {
		var obj1:Object = new Object();
		assertEquals("message", obj1, obj1);
	}
	
	public function testEqualsFailure():Void {
		var obj1:Object = new Object();
		var obj2:Object = new Object();
		try {
			assertEquals(obj1, obj2);
		}
		catch(e:Error) {
			return;
		}
		fail("obj1 does not equal obj2");
	}

	public function testEqualsSimpleMessageFailure():Void {
		try {
			var obj1:Object = new Object();
			var obj2:Object = new Object();
			assertEquals("message", obj1, obj2);
		}
		catch(e:Error) {
			return;
		}
		fail("obj1 does not equal obj2 with message");
	}
	
	public function testNull():Void {
		assertNull(null);
	}
	
	public function testNullMessage():Void {
		assertNull("message", null);
	}
	
	public function testNullFailure():Void {
		var obj:Object = new Object();
		try {
			assertNull("message", obj);
		}
		catch(e:Error) {
			return;
		}
		fail("null failure");
	}
	
	public function testNotNull():Void {
		var obj:Object = new Object();
		assertNotNull(obj);
	}
	
	public function testNotNullFailure():Void {
		try {
			assertNotNull(null);
		}
		catch(e:Error) {
			return;
		}
		fail("not null failed");
	}
	
	public function testNotNullMessage():Void {
		var obj:Object = new Object();
		assertNotNull("not null", obj);
	}
	
	public function testSame():Void {
		var obj:Object = new Object();
		assertSame(obj, obj);
	}
	
	public function testSameFailure():Void {
		try {
			assertSame(new Object(), new Object());
		}
		catch(e:Error) {
			return;
		}
		fail("same failure");
	}
	
	public function testNotSame():Void {
		var obj1:Object = new Object();
		var obj2:Object = new Object();
		assertNotSame(obj1, obj2);
	}
	
	public function testNotSameFailure():Void {
		var obj1:Object = new Object();
		try {
			assertNotSame(obj1, obj1);
		}
		catch(e:Error) {
			return;
		}
		fail("not same failure");
	}
	
	public function testNotSameMessage():Void {
		var obj1:Object = new Object();
		var obj2:Object = new Object();
		assertNotSame("not same message", obj1, obj2);
	}
}
