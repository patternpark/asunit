import asunit.flash.events.Event;
import asunit.flash.events.IEventDispatcher;
import asunit.flash.events.EventDispatcher;
import asunit.flash.utils.Timer;
import asunit.framework.TestCase;

class asunit.framework.AsyncMethodTest extends TestCase {
	
	public var className:String = "asunit.framework.AsyncMethodTest";
	
	private var instance:MovieClip;

	public function AsyncMethodTest(testMethod:String) {
		super(testMethod);
	}

	private function setUp():Void {
		instance = context.createEmptyMovieClip("test", context.getNextHighestDepth());
	}

	private function tearDown():Void {
		instance.removeMovieClip();
		instance = null;
	}

	public function testInstantiated():Void {
		assertTrue("MovieClip instantiated", instance instanceof MovieClip);
	}

	public function testAsyncMethod():Void {
		var handler:Function = addAsync(asyncHandler);
		Timer.setTimeout(this, handler, 100);
	}
	
	private function asyncHandler():Void {
		assertTrue(instance instanceof MovieClip);
	}
	
	public function testAsyncVisualEntity():Void {
		var handler:Function = addAsync(spriteHandler);
		Timer.setTimeout(this, handler, 100);
	}
	
	private function spriteHandler():Void {
		assertTrue(instance instanceof MovieClip);
	}
	
	public function testAsyncVisualEntity2():Void {
		var handler:Function = addAsync(spriteHandler);
		Timer.setTimeout(this, handler, 100);
	}
	
	// This is an asynchronous test method
	public function testAsyncFeature():Void {
		// create a new object that dispatches events...
		var dispatcher : IEventDispatcher = new EventDispatcher();
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
