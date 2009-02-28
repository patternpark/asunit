import asunit.framework.TestCase;
import asunit.flash.events.Event;
import asunit.flash.events.IEventDispatcher;
import asunit.flash.events.EventDispatcher;
import asunit.flash.utils.Timer;

// TestCase subclasses should always end with 'Test', the example
// doesn't because we don't want TestSuites in this directory.
class asunit.framework.TestCaseExample extends TestCase {
	private var date:Date;

	// TestCase constructors must be implemented as follows
	// so that we can execute a single method on them from
	// the TestRunner
	public function TestCaseExample(testMethod:String) {
		if(testMethod==undefined) testMethod=null;
		super(testMethod);
	}

	// This method will be called before every test method
	private function setUp():Void {
		date = new Date();
//			sprite = new Sprite();
//			addChild(sprite);
	}

	// This method will be called after every test method
	// but only if we're executing the entire TestCase,
	// the tearDown method won't be called if we're
	// calling start(MyTestCase, "someMethod");
	private function tearDown():Void {
//			removeChild(sprite);
//			sprite = null;
		date = null;
	}

	// This is auto-created by the XULUI and ensures that
	// our objects are actually created as we expect.
	public function testInstantiated():Void {
		assertTrue("Date instantiated", date instanceof Date);
//			assertTrue("Sprite instantiated", sprite is Sprite);
	}

	// This is an example of a typical test method
	public function testMonthGetterSetter():Void {
		date.setMonth(1);
		assertEquals(1, date.getMonth());
	}

	// This is an asynchronous test method
	public function testAsyncFeature():Void {
		// create a new object that dispatches events...
		var dispatcher:IEventDispatcher = new EventDispatcher();
		// get a TestCase async event handler reference
		// the 2nd arg is an optional timeout in ms. (default=1000ms )
		var handler:Function = addAsync(changeHandler, 2000);
		// subscribe to your event dispatcher using the returned handler
		dispatcher.addEventListener(Event.CHANGE, handler, this);
		// cause the event to be dispatched.
		// either immediately:
		//dispatcher.dispatchEvent(new Event(Event.CHANGE));
		// or in the future < your assigned timeout
		Timer.setTimeout( dispatcher, dispatchEvent, 200, new Event(Event.CHANGE));
	}

	private function changeHandler(event:Event):Void {
		// perform assertions in your handler
		assertEquals(Event.CHANGE, event.type);
	}
}