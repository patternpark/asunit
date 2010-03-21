import asunit.framework.TestCaseStub;
import asunit.framework.TestCase;
import asunit.flash.events.EventDispatcher;
import asunit.flash.events.Event;
import asunit.flash.utils.Timer;

class asunit.framework.TestCaseTest extends TestCase {

	public var className:String = "asunit.framework.TestCaseTest";

	public function TestCaseTest(testMethod:String) {
		super(testMethod);
	}
	
	public function testInstantiated():Void {
		assertTrue(this instanceof TestCase);
	}
	
	public function testCustomConstructor():Void {
		var mock : TestCaseStub = new TestCaseStub("testMethod1");
		var handler:Function = addAsync(getCustomConstructorCompleteHandler(mock));
		mock.addEventListener(Event.COMPLETE, handler);
		mock.run();
	}
	
	private function getCustomConstructorCompleteHandler(mock:TestCaseStub):Function {
		return function():Void {
			this.assertTrue("testMethod1Run", mock.testMethod1Run);
			this.assertFalse("testMethod2Run", mock.testMethod2Run);
			this.assertFalse("testMethod3Run", mock.testMethod3Run);
			return;
		};
	}
	
	public function testCustomConstructor2():Void {
		var mock:TestCaseStub = new TestCaseStub("testMethod1, testMethod3");
		var handler:Function = addAsync(getCustomConstructor2CompleteHandler(mock));
		mock.addEventListener(Event.COMPLETE, handler);
		mock.run();
	}
	
	private function getCustomConstructor2CompleteHandler(mock:TestCaseStub):Function {
		return function():Void {
			this.assertTrue("testMethod1Run", mock.testMethod1Run);
			this.assertFalse("testMethod2Run", mock.testMethod2Run);
			this.assertTrue("testMethod3Run", mock.testMethod3Run);
			return;
		};
	}

	public function testCustomConstructor3():Void {
		var mock:TestCaseStub = new TestCaseStub("testMethod1,testMethod3");
		var handler:Function = addAsync(getCustomConstructor3CompleteHandler(mock));
		mock.addEventListener(Event.COMPLETE, handler);
		mock.run();
	}
	
	private function getCustomConstructor3CompleteHandler(mock:TestCaseStub):Function {
		return function():Void {
			this.assertTrue("testMethod1Run", mock.testMethod1Run);
			this.assertFalse("testMethod2Run", mock.testMethod2Run);
			this.assertTrue("testMethod3Run", mock.testMethod3Run);
			return;
		};
	}

	public function testCustomConstructor4():Void {
		var mock:TestCaseStub = new TestCaseStub("testMethod1, testMethod2,testMethod3");
		var handler:Function = addAsync(getCustomConstructor4CompleteHandler(mock));
		mock.addEventListener(Event.COMPLETE, handler);
		mock.run();
	}

	private function getCustomConstructor4CompleteHandler(mock:TestCaseStub):Function {
		return function():Void {
			this.assertTrue("testMethod1Run", mock.testMethod1Run);
			this.assertTrue("testMethod2Run", mock.testMethod2Run);
			this.assertTrue("testMethod3Run", mock.testMethod3Run);
			return;
		};
	}

	public function testAsync():Void {
		var dispatcher:EventDispatcher = new EventDispatcher();
		var handler:Function = addAsync(asyncHandler, 400);
		dispatcher.addEventListener(Event.COMPLETE, handler);
		Timer.setTimeout(dispatcher, dispatchEvent, 200, new Event(Event.COMPLETE));
	}
	
	private function asyncHandler(event:Event):Void {
		assertEquals(event.type, Event.COMPLETE);
	}
}