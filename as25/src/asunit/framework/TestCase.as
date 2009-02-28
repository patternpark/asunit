import asunit.flash.utils.Timer;
import asunit.errors.ClassNameUndefinedError;
import asunit.util.ArrayUtil;import asunit.framework.AsyncOperation;import asunit.framework.TestResult;import asunit.framework.TestListener;import asunit.framework.Test;import asunit.framework.Assert;
import asunit.flash.errors.IllegalOperationError;import asunit.flash.events.Event;import asunit.errors.AssertionFailedError;import asunit.util.ArrayIterator;import asunit.util.Iterator;	
/**
 * A test case defines the fixture to run multiple tests. To define a test case<br>
 * 1) implement a subclass of TestCase<br>
 * 2) define instance variables that store the state of the fixture<br>
 * 3) initialize the fixture state by overriding <code>setUp</code><br>
 * 4) clean-up after a test by overriding <code>tearDown</code>.<br>
 * Each test runs in its own fixture so there
 * can be no side effects among test runs.
 * Here is an example:
 * <pre>
 * public class MathTest extends TestCase {
 *     protected double fValue1;
 *     protected double fValue2;
 *
 *    protected void setUp() {
 *         fValue1= 2.0;
 *         fValue2= 3.0;
 *     }
 * }
 * </pre>
 *
 * For each test implement a method which interacts
 * with the fixture. Verify the expected results with assertions specified
 * by calling <code>assertTrue</code> with a boolean.
 * <pre>
 *    public void testAdd() {
 *        double result= fValue1 + fValue2;
 *        assertTrue(result == 5.0);
 *    }
 * </pre>
 * Once the methods are defined you can run them. The framework supports
 * both a static type safe and more dynamic way to run a test.
 * In the static way you override the runTest method and define the method to
 * be invoked. A convenient way to do so is with an anonymous inner class.
 * <pre>
 * TestCase test= new MathTest("add") {
 *        public void runTest() {
 *            testAdd();
 *        }
 * };
 * test.run();
 * </pre>
 * The dynamic way uses reflection to implement <code>runTest</code>. It dynamically finds
 * and invokes a method.
 * In this case the name of the test case has to correspond to the test method
 * to be run.
 * <pre>
 * TestCase= new MathTest("testAdd");
 * test.run();
 * </pre>
 * The tests to be run can be collected into a TestSuite. JUnit provides
 * different <i>test runners</i> which can run a test suite and collect the results.
 * A test runner either expects a static method <code>suite</code> as the entry
 * point to get a test to run or it will extract the suite automatically.
 * <pre>
 * public static Test suite() {
 *      suite.addTest(new MathTest("testAdd"));
 *      suite.addTest(new MathTest("testDivideByZero"));
 *      return suite;
 *  }
 * </pre>
 * @see TestResult
 * @see TestSuite
 */
class asunit.framework.TestCase extends Assert implements Test {
	private static var PRE_SET_UP:Number		= 0;
	private static var SET_UP:Number 			= 1;
	private static var RUN_METHOD:Number 		= 2;
	private static var TEAR_DOWN:Number			= 3;
	private static var DEFAULT_TIMEOUT:Number 	= 1000;
	private var className:String;	private var fName:String;
	private var result : TestListener;
	private var testMethods:Array;
	private var isComplete:Boolean;
	private var context : MovieClip;
	private var asyncQueue:Array;
	private var currentMethod:String;
	private var runSingle:Boolean;
	private var methodIterator:Iterator;
	private var layoutManager:Object;
	private var currentState:Number;

	private static var lastDepth:Number = 10;

	/**
	 * Constructs a test case with the given name.
	 */
	public function TestCase(testMethod:String) {		if(testMethod==undefined) testMethod=null;
		if(testMethod != null) {
			testMethods = testMethod.split(", ").join(",").split(",");
			if(testMethods.length == 1) {
				runSingle = true;
			}
		} else {
			setTestMethods(this);
		}
		setName(this.className);		// I don't think this is necessary for as2
//		resolveLayoutManager();
		asyncQueue = [];
	}

/*	private function resolveLayoutManager():Void {
		// Avoid creating import dependencies on flex framework
		// If you have the framework.swc in your classpath,
		// the layout manager will be found, if not, a mcok
		// will be used.
		try {
			var manager:Class = getDefinitionByName("mx.managers.LayoutManager") as Class;
			layoutManager = manager["getInstance"]();
			if(!layoutManager.hasOwnProperty("resetAll")) {
				throw new Error("TestCase :: mx.managers.LayoutManager missing resetAll method");
			}
		}
		catch(e:Error) {
			layoutManager = new Object();
			layoutManager.resetAll = function():Void {
			};
		}
	}
*/
	/**
	 * Sets the name of a TestCase
	 * @param name The name to set
	 */
	public function setName(name:String):Void {		if(name==undefined || name==null){			throw new ClassNameUndefinedError("You must assign a ClassName for your TestCase subclass.")		}
		fName = name;
	}

	private function setTestMethods(obj:Object):Void {
		testMethods = [];
		_global.ASSetPropFlags(obj.__proto__, null, 6, true);
		for(var prop:String in obj) {
				// look for functions starting with "test"
			if((prop.indexOf("test")==0)  && (obj[prop] instanceof Function)){
				testMethods.push(prop);			}
		}
		_global.ASSetPropFlags(this.__proto__, null, 1, true);
		testMethods.reverse();		
	}
	
	public function getTestMethods():Array {
		return testMethods;
	}

	/**
	 * Counts the number of test cases executed by run(TestResult result).
	 */
	public function countTestCases():Number {
		return testMethods.length;
	}

	/**
	 * Creates a default TestResult object
	 *
	 * @see TestResult
	 */
	private function createResult():TestResult {
	    return new TestResult();
	}

	/**
	 * A convenience method to run this test, collecting the results with
	 * either the TestResult provided or a default, new TestResult object.
	 * Expects either:
	 * run():Void // will return the newly created TestResult
	 * run(result:TestResult):TestResult // will use the TestResult
	 * that was passed in.
	 *
	 * @see TestResult
	 */
	public function run():Void {
		getResult().run(this);
	}

	public function setResult(result:TestListener):Void {
		this.result = result;
	}

	public function getResult():TestListener {
		return (result == null) ? createResult() : result;
	}

	/**
	 * Runs the bare test sequence.
	 * @exception Error if any exception is thrown
	 *  throws Error
	 */
	public function runBare():Void {
		if(isComplete) {
			return;
		}
		var name:String;
		var itr:Iterator = getMethodIterator();
		if(itr.hasNext()) {
			name = String(itr.next());
			currentState = PRE_SET_UP;
			runMethod(name);
		}
		else {
			cleanUp();
			getResult().endTest(this);
			isComplete = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
	
	private function getMethodIterator():Iterator {
		if(methodIterator == null) {
			methodIterator = new ArrayIterator(testMethods);
		}
		return methodIterator;
	}

	// Override this method in Asynchronous test cases
	// or any other time you want to perform additional
	// member cleanup after all test methods have run
	private function cleanUp():Void {
	}
	
	private function runMethod(methodName:String):Void {
		try {
			if(currentState == PRE_SET_UP) {
				currentState = SET_UP;
				getResult().startTestMethod(this, methodName);
				setUp(); // setUp may be async and change the state of methodIsAsynchronous
			}
			currentMethod = methodName;
			if(!waitForAsync()) {
				currentState = RUN_METHOD;
				this[methodName]();
			}
		}
		catch(assertionFailedError:AssertionFailedError) {
			getResult().addFailure(this, assertionFailedError);
		}
		catch(unknownError:Error) {
			getResult().addError(this, unknownError);
		}
		finally {
			if(!waitForAsync()) {
				runTearDown();
			}
		}
	}

	/**
	 * Sets up the fixture, for example, instantiate a mock object.
	 * This method is called before each test is executed.
	 * throws Exception on error
	 */
	private function setUp():Void {
	}
	/**
	 * Tears down the fixture, for example, delete mock object.
	 * This method is called after a test is executed.
	 *  throws Exception on error
	 */
	private function tearDown():Void {
	}
	/**
	 * Returns a string representation of the test case
	 */
	public function toString():String {
		if(getCurrentMethod()) {
			return getName() + "." + getCurrentMethod() + "()";
		}
		else {
			return getName();
		}
	}
	/**
	 * Gets the name of a TestCase
	 * @return returns a String
	 */
	public function getName():String {
		return fName;
	}

	public function getCurrentMethod():String {
		return currentMethod;
	}

	public function getIsComplete():Boolean {
		return isComplete;
	}

	public function setContext(context:MovieClip):Void {
		this.context = context;
	}

	public function getContext():MovieClip {
		return context;
	}

	private function addAsync(handler:Function, duration:Number):Function {
		if(handler == undefined) {
			handler = function():Void{};
		}		if(duration == undefined) {			duration = DEFAULT_TIMEOUT;		}
		var async:AsyncOperation = new AsyncOperation(this, handler, duration);
		asyncQueue.push(async);
		return async.getCallback();
	}

	public function asyncOperationTimeout(async:AsyncOperation, duration:Number):Void{
		getResult().addError(this, new IllegalOperationError("TestCase.timeout (" + duration + "ms) exceeded on an asynchronous operation."));
		asyncOperationComplete(async);
	}

	public function asyncOperationComplete(async:AsyncOperation):Void{
		// remove operation from queue
		var i:Number = ArrayUtil.indexOf(asyncQueue, async);
		asyncQueue.splice(i,1);
		// if we still need to wait, return
		if(waitForAsync()) return;
		if(currentState == SET_UP) {
			runMethod(currentMethod);
		}
		else if(currentState == RUN_METHOD) {
			runTearDown();
		}
	}

	private function waitForAsync():Boolean{
		return asyncQueue.length > 0;
	}

	private function runTearDown():Void {
		currentState = TEAR_DOWN;
		if(isComplete) {
			return;
		}
		if(!runSingle) {
			getResult().endTestMethod(this, currentMethod);
			tearDown();
		}
		Timer.setTimeout(this, runBare, 5);
	}
	
	/**
	 * begin asunit25 specific methods
	 */
	
	private function createEmptyMovieClip(name:String, depth:Number):MovieClip {
		if(depth==undefined || depth===null) depth = getNextHighestDepth();
		return getContext().createEmptyMovieClip(name, depth);
	}

	private function createTextField(name:String, depth:Number, x:Number, y:Number, width:Number, height:Number):TextField {
	    getContext().createTextField(name, depth, x, y, width, height);
	    return TextField(getContext()[name]);
	}

	private function getNextHighestDepth():Number {
		return getContext().getNextHighestDepth();
	}

	/*
	 * This helper method will support the following method signatures:
	 *
	 * attachMovie(linkageId:String):MovieClip;
	 * attachMovie(linkageId:String, initObject:Object):MovieClip;
	 * attachMovie(linkageId:String, name:String, depth:Number):MovieClip;
	 * attachMovie(linkageId:String, name:String, depth:Number, initObject:Object):MovieClip;
	 *
	 * @return
	 * 	MovieClip
	 */
 	private function attachMovie():MovieClip {
 		var linkageId:String = arguments[0];
 		var name:String;
 		var depth:Number;
 		var initObj:Object = new Object();

		switch(arguments.length) {
			case 1 :
			case 2 :
				name = getValidName(getContext(), name);
				depth = getValidDepth(getContext());
 				initObj = arguments[1];
 				break;
 			case 3 :
 			case 4 :
 				name = arguments[1];
 				depth = arguments[2];
 				initObj = arguments[3];
 				break;
		}
		return getContext().attachMovie(linkageId, name, depth, initObj);
 	}

	public function getUpperEmptyDepth(parent:MovieClip, depth:Number):Number {
		if(depth == undefined || !isValidDepth(parent, depth)) {
			var high:Number = (depth == undefined) ? 1 : depth;
			for(var i:String in parent) {
				if(parent[i] instanceof MovieClip && parent[i].getDepth() != undefined) {
					high = Math.max(parent[i].getDepth()+1, high);
				}
			}
			return high;
		}
		return depth;
	}

	private function getValidName(parent:MovieClip, nm:Object):String {
		var incr:Number = 1;

		var name:String = (nm == undefined || nm instanceof Object) ? "item" : nm.toString();
		var ref:MovieClip = parent[name];

		var name2:String = name;
		while(ref != undefined && incr < 100) {
			name2 = name + "-" + (incr++);
			ref = parent[name2];
		}
		return name2;
	}

	private function isValidDepth(parent:MovieClip, depth:Number):Boolean {
		var item:MovieClip = getItemByDepth(parent, depth);
		return (item == null) ? true : false;
	}

	private function getItemByDepth(parent:MovieClip, depth:Number):MovieClip {
		for(var i:String in parent) {
			if(parent[i].getDepth() == depth) {
				return parent[i];
			}
		}
		return null;
	}

	/**
	 * Returns the next available depth for attaching a MovieClip.
	 *
	 * @return
	 *         Number of next available depth.
	 */
	public static function nextDepth():Number {
		return lastDepth++;
	}

	private function getValidDepth(mc:MovieClip):Number {
		var mcDepth:Number;
		var dp:Number = nextDepth();
		for(var i:String in mc) {
			mcDepth = mc[i].getDepth();
			if(mc[i] instanceof MovieClip && mcDepth < 10000) {
				dp = Math.max(mcDepth, dp);
			}
		}
		return ++dp;
	}

}
