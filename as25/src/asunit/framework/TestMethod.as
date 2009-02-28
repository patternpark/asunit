import asunit.framework.Test;

/**
 * A <code>TestFailure</code> collects a failed test together with
 * the caught exception.
 * @see TestResult
 */
class asunit.framework.TestMethod {
	private var test:Test;
	private var method:String;
	
	private var _duration:Number;
	private var start:Number;
	
	/**
	 * Constructs a TestMethod with a given Test and method name.
	 */
	public function TestMethod(test:Test, method:String) {
		this.test = test;
		this.method = method;
		start = getTimer();
	}
	
	public function getName():String {
		return method;
	}
	
	public function endTest(test:Test):Void {
		_duration = (getTimer() - start) * .001;
	}
	
	public function duration():Number {
		return _duration;
	}
}