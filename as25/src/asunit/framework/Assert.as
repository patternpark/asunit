import asunit.errors.AssertionFailedError;

import asunit.flash.errors.IllegalOperationError;
import asunit.flash.events.EventDispatcher;

/**
 * A set of assert methods.  Messages are only displayed when an assert fails.
 */

class asunit.framework.Assert extends EventDispatcher {
	/**
	 * Protect constructor since it is a static only class
	 */
	public function Assert() {
	}

	/**
	 * Asserts that a condition is true. If it isn't it throws
	 * an AssertionFailedError with the given message.
	 */
	static public function assertTrue():Void {
		var message:String;
		var condition:Boolean;

		if(arguments.length == 1) {
			message = "";
			condition = Boolean(arguments[0]);
		}
		else if(arguments.length == 2) {
			message = arguments[0];
			condition = Boolean(arguments[1]);
		}
		else {
			throw new IllegalOperationError("Invalid argument count");
		}

		if(!condition) {
			fail(message);
		}
	}
	/**
	 * Asserts that a condition is false. If it isn't it throws
	 * an AssertionFailedError with the given message.
	 */
	static public function assertFalse():Void {
		var message:String;
		var condition:Boolean;

		if(arguments.length == 1) {
			message = "";
			condition = Boolean(arguments[0]);
		}
		else if(arguments.length == 2) {
			message = arguments[0];
			condition = Boolean(arguments[1]);
		}
		else {
			throw new IllegalOperationError("Invalid argument count");
		}

		assertTrue(message, !condition);
	}
	/**
	 * Fails a test with the given message.
	 */
	static public function fail(message:String):Void {
		throw new AssertionFailedError(message);
	}
	/**
	 * Asserts that two objects are equal. If they are not
	 * an AssertionFailedError is thrown with the given message.
	 */
	static public function assertEquals():Void {
		var message:String;
		var expected:Object;
		var actual:Object;

		if(arguments.length == 2) {
			message = "";
			expected = arguments[0];
			actual = arguments[1];
		}
		else if(arguments.length == 3) {
			message = arguments[0];
			expected = arguments[1];
			actual = arguments[2];
		}
		else {
			throw new IllegalOperationError("Invalid argument count");
		}

		if(expected == null && actual == null) {
			return;
		}

		if(expected.equals instanceof Function && expected.equals(actual)){
			return;
		}else if(actual.equals instanceof Function && actual.equals(expected)){
			return;
		}else if(expected==actual){
			return;
		}

		failNotEquals(message, expected, actual);
	}
	/**
	 * Asserts that an object isn't null. If it is
	 * an AssertionFailedError is thrown with the given message.
	 */
	static public function assertNotNull():Void {
		var message:String;
		var object:Object;

		if(arguments.length == 1) {
			message = "";
			object = arguments[0];
		}
		else if(arguments.length == 2) {
			message = arguments[0];
			object = arguments[1];
		}
		else {
			throw new IllegalOperationError("Invalid argument count");
		}

		assertTrue(message, object != null);
	}
	/**
	 * Asserts that an object is null.  If it is not
	 * an AssertionFailedError is thrown with the given message.
	 */
	static public function assertNull():Void {
		var message:String;
		var object:Object;

		if(arguments.length == 1) {
			message = "";
			object = arguments[0];
		}
		else if(arguments.length == 2) {
			message = arguments[0];
			object = arguments[1];
		}
		else {
			throw new IllegalOperationError("Invalid argument count");
		}

		assertTrue(message, object == null);
	}
	/**
	 * Asserts that two objects refer to the same object. If they are not
	 * an AssertionFailedError is thrown with the given message.
	 */
	static public function assertSame():Void {
		var message:String;
		var expected:Object;
		var actual:Object;

		if(arguments.length == 2) {
			message = "";
			expected = arguments[0];
			actual = arguments[1];
		}
		else if(arguments.length == 3) {
			message = arguments[0];
			expected = arguments[1];
			actual = arguments[2];
		}
		else {
			throw new IllegalOperationError("Invalid argument count");
		}

		if(expected === actual) {
			return;
		}
		failNotSame(message, expected, actual);
	}
 	/**
 	 * Asserts that two objects do not refer to the same object. If they do,
 	 * an AssertionFailedError is thrown with the given message.
 	 */
	static public function assertNotSame():Void {
		var message:String;
		var expected:Object;
		var actual:Object;

		if(arguments.length == 2) {
			message = "";
			expected = arguments[0];
			actual = arguments[1];
		}
		else if(arguments.length == 3) {
			message = arguments[0];
			expected = arguments[1];
			actual = arguments[2];
		}
		else {
			throw new IllegalOperationError("Invalid argument count");
		}

		if(expected === actual) {
			failSame(message);
		}
	}

	/**
	 * Asserts that two numerical values are equal within a tolerance range.
	 * If they are not an AssertionFailedError is thrown with the given message.
	 */
	static public function assertEqualsFloat():Void {
		var message:String;
		var expected:Number;
		var actual:Number;
		var tolerance:Number = 0;

		if(arguments.length == 3) {
			message = "";
			expected = arguments[0];
			actual = arguments[1];
			tolerance = arguments[2];
		}
		else if(arguments.length == 4) {
			message = arguments[0];
			expected = arguments[1];
			actual = arguments[2];
			tolerance = arguments[3];
		}
		else {
			throw new IllegalOperationError("Invalid argument count");
		}
		if (isNaN(tolerance)) tolerance = 0;
		if(Math.abs(expected - actual) <= tolerance) {
			   return;
		}
		failNotEquals(message, expected, actual);
	}


	static private function failSame(message:String):Void {
		var formatted:String = "";
 		if(message != null) {
 			formatted = message + " ";
 		}
 		fail(formatted + "expected not same");
	}

	static private function failNotSame(message:String, expected:Object, actual:Object):Void {
		var formatted:String = "";
		if(message != null) {
			formatted = message + " ";
		}
		fail(formatted + "expected same:<" + expected + "> was not:<" + actual + ">");
	}

	static private function failNotEquals(message:String, expected:Object, actual:Object):Void {
		fail(format(message, expected, actual));
	}

	static private function format(message:String, expected:Object, actual:Object):String {
		var formatted:String = "";
		if(message != null) {
			formatted = message + " ";
		}
		return formatted + "expected:<" + expected + "> but was:<" + actual + ">";
	}
}
