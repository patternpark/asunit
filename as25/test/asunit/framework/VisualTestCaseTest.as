import asunit.framework.TestCase;

class asunit.framework.VisualTestCaseTest extends TestCase {
	
	public var className:String = "asunit.framework.VisualTestCaseTest";
	
	private var instance:MovieClip;

	public function VisualTestCaseTest(testMethod:String) {
		super(testMethod);
	}

	private function setUp():Void {
		instance = context.createEmptyMovieClip("instance", context.getNextHighestDepth());
	}

	private function tearDown():Void {
		instance.removeMovieClip();
	}
	
	public function testInstance():Void {
		assertTrue(instance instanceof MovieClip);
	}
	
	public function testSize():Void {
		assertTrue(instance._width == 0);
		assertTrue(instance._height == 0);
	}

	public function testDrawnSize():Void {
		instance.beginFill(0xFF0000);
		instance.moveTo(0,0);
		instance.lineTo(10, 0);
		instance.lineTo(10, 20);
		instance.lineTo(0, 20);
		instance.lineTo(0, 0);
		
		assertTrue(instance._width == 10);
		assertTrue(instance._height == 20);
	}

	public function testSecondSize():Void {
		assertTrue(instance._width == 0);
		assertTrue(instance._height == 0);
	}

}