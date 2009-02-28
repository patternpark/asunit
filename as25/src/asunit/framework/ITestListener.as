import asunit.errors.AssertionFailedError;
import asunit.framework.Test;

interface asunit.framework.ITestListener {
	// A test started.
	public function startTest(test:Test):Void;
 	// An error occurred.
	public function addError(test:Test, e:Error):Void;
 	// A failure occurred.
 	public function addFailure(test:Test, e:AssertionFailedError):Void;  
	// A test ended.
 	public function endTest(test:Test):Void; 
}
