import asunit.framework.TestCase;
import asunit.framework.Assert;

class asunit.framework.AssertTest extends TestCase {

	public var className:String = "asunit.framework.AssertTest";

	public function AssertTest(testMethod:String) {
		super(testMethod);
	}

	public function testAssertTrue():Void {
		assertTrue("true value", true);
		assertTrue("double negated true value", !(!true));
		assertTrue("negated false value", !false);
		assertTrue("the number 1", 1);
		assertTrue("Math.PI", Math.PI);
		assertTrue("negative Math.PI", -Math.PI);
		assertTrue("not empty quotes", !(""));
		assertTrue("string of space", " ");
		assertTrue("string of true", "true");
		assertTrue("string of false", "false");
		assertTrue("negated undefined", !undefined);
		assertTrue("negated null", !null);
		assertTrue("negated NaN", !NaN);
		assertTrue("new Object()", new Object());
		assertTrue("new Array()", new Array());
	}
	
	public function testAssertFalse():Void {
		assertFalse("false value", false);
		assertFalse("double negated false value", !(!false));
		assertFalse("negated true value", !true);
		assertFalse("the number zero", 0);
		assertFalse("empty quotes", "");
		assertFalse("undefined", undefined);
		assertFalse("null", null);
		assertFalse("negated Math.PI", !Math.PI);
		assertFalse("negated negative Math.PI", !-Math.PI);
		assertFalse("3 > NaN", 3 > NaN);
		assertFalse("3 < NaN", 3 < NaN);
		assertFalse("NaN", NaN);
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
		assertTrue("assertTrue with message", true);
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
		assertEquals("an Object and itself", obj1, obj1);
		
		var array:Array = [];
		assertEquals("an empty Array and itself", array, array);
		
		assertEquals("true and true", true, true);
		assertEquals("false and false", false, false);
		assertEquals("true and !false", true, !false);
		assertEquals("!false and true", !false, true);
		
		assertEquals("positive number and itself", 2, 2);
		assertEquals("negative number and itself", -5, -5);
		assertEquals("Math.PI and itself", Math.PI, Math.PI);
		assertEquals("number and string representation", 99, "99");
		assertEquals("number and string representation in reverse order", "99", 99);
		
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
	
	public function testAssertEqualsFloat():Void {
		assertEqualsFloat(5, 5, 0);
		assertEqualsFloat("5 == 5 with tolerance 0", 5, 5, 0);
		assertEqualsFloat("0 == 0 with tolerance 0", 0, 0, 0);
		
		assertEqualsFloat("positive difference equal to tolerance", 10,  10.1,  0.1);
		assertEqualsFloat("negative difference equal to tolerance", 10,   9.9,  0.1);

		assertEqualsFloat("difference +.05 with tolerance 0.1", 20,  20.05,  0.1);
		assertEqualsFloat("difference -.05 with tolerance 0.1", 20,  19.95,  0.1);
	}

	public function testAssertEqualsFloatFailure():Void {
		try {
			assertEqualsFloat("3 == 3.14 with tolerance .1", 3, 3.14, .1);
		}
		catch(e:Error) {
			return;
		}
		fail("assertEqualsFloat failure");
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
