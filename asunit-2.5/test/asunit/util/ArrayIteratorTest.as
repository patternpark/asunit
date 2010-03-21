import asunit.util.ArrayIterator;	
import asunit.framework.TestCase;

class asunit.util.ArrayIteratorTest extends TestCase {
	
	public var className:String = "asunit.util.ArrayIteratorTest";
	
	private var itr : ArrayIterator;

	public function ArrayIteratorTest(testMethod:String) {
		super(testMethod);
	}

	private function setUp():Void {
		itr = new ArrayIterator(getSimpleArray(5));
	}
	
	private function getSimpleArray(count:Number):Array {
		var arr:Array = new Array();
		for(var i:Number = 0; i < count; i++) {
			arr.push("item-" + i);
		}
		return arr;
	}

	private function tearDown():Void {
		itr = null;
	}

	public function testInstantiated():Void {
		assertTrue("ArrayIterator instantiated", itr instanceof ArrayIterator);
	}

	public function testHasNext():Void {
		assertTrue(itr.hasNext());
	}
	
	public function testNext():Void {
		assertEquals("item-0", itr.next());
	}
	
	public function testNextTwice():Void {
		assertEquals("item-0", itr.next());
		assertEquals("item-1", itr.next());
	}
	
	public function testLast():Void {
		assertTrue(itr.hasNext());
		assertEquals("item-0", itr.next());
		assertTrue(itr.hasNext());
		assertEquals("item-1", itr.next());
		assertTrue(itr.hasNext());
		assertEquals("item-2", itr.next());
		assertTrue(itr.hasNext());
		assertEquals("item-3", itr.next());
		assertTrue(itr.hasNext());
		assertEquals("item-4", itr.next());
		assertFalse(itr.hasNext());
	}
	
	public function testReset():Void {
		testLast();
		itr.reset();
		assertTrue(itr.hasNext());
		assertEquals("item-0", itr.next());
	}
}
