import asunit.framework.TestListener;import asunit.util.ArrayUtil;import asunit.framework.Test;
import asunit.framework.TestCase;
import asunit.util.ArrayIterator;
import asunit.util.Iterator;

import asunit.flash.events.Event;

/**
 * A <code>TestSuite</code> is a <code>Composite</code> of Tests.
 * It runs a collection of test cases. Here is an example using
 * the dynamic test definition.
 * <pre>
 * TestSuite suite = new TestSuite();
 * suite.addTest(new MathTest());
 * suite.addTest(new OtherTest());
 * </pre>
 * @see Test
 * @see TestCase
 */
class asunit.framework.TestSuite extends TestCase implements Test {
	private var fTests:Array = new Array();
	private var testsCompleteCount:Number = 0;
	private var iterator:ArrayIterator;
	private var isRunning:Boolean;

	 public function TestSuite() {
	 	super();
	 	fTests = new Array();
	}
	private function setName(name:String):Void {		fName = name;	}
	function setTestMethods(object:Object):Void {
		testMethods = new Array();
	}
	
	/**
	 * Adds a test to the suite.
	 */
	public function addTest(test:Test):Void {
		fTests.push(test);
	}
	
	/**
	 * Counts the number of tests that will be run by this Suite.
	 */
	public function countTestCases():Number {		var count:Number = 0;
		ArrayUtil.forEach(fTests,			function(test:TestCase):Void{				count = count + test.countTestCases();			}		);
		return count;
	}
	
	/**
	 * Runs the tests and collects their result in a TestResult.
	 */
	public function run():Void {
		var result:TestListener = getResult();
		var test:Test;
		var itr:Iterator = getIterator();
		while(itr.hasNext()) {
			isRunning = true;
			test = Test(itr.next());
			test.setResult(result);
			test.addEventListener(Event.COMPLETE, testCompleteHandler, this);
			test.run();
			if(!test.getIsComplete()) {
				isRunning = false;
				break;
			}
		}
	}

	private function getIterator():ArrayIterator {
		if(iterator == null) {
			iterator = new ArrayIterator(fTests);
		}
		return iterator;
	}
	
	private function testCompleteHandler(event:Event):Void {
		if(!isRunning) {
			run();
		}
		if(++testsCompleteCount >= testCount()) {
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
	
	/**
	 * Returns the number of tests in this suite
	 */
	public function testCount():Number {
		return fTests.length;
	}
	
	public function toString():String {
		return getName();
	}
	
	public function getIsComplete():Boolean {		return ArrayUtil.every(fTests,			function(test:TestCase):Boolean{				return test.getIsComplete();			}		);
	}
	
	public function setContext(context:MovieClip):Void {
		super.setContext(context);		ArrayUtil.forEach(fTests,			function(test:Test):Void{				test.setContext(context);			}		);
	}
}