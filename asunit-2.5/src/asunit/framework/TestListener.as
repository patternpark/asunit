import asunit.framework.Test;
import asunit.errors.AssertionFailedError;

interface asunit.framework.TestListener {
	
	/**
	 * Run the provided Test.
	 */
	function run(test : Test) : Void;
	/**
	 * A test started.
	 */
	function startTest(test:Test):Void;
	/**
 	 * A failure occurred.
 	 */
 	function addFailure(test:Test, t:AssertionFailedError):Void;  
	/**
 	 * An error occurred.
 	 */
	function addError(test:Test, t:Error):Void;
	/**
	 * A test method has begun execution.
	 */
	function startTestMethod(test:Test, methodName:String):Void;
	/**
	 * A test method has completed.
	 */
	function endTestMethod(test:Test, methodName:String):Void;
	/**
	 * A test ended.
	 */
 	function endTest(test:Test):Void; 
}