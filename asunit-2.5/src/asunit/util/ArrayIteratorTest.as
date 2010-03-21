
import asunit.util.ArrayIterator;
import asunit.framework.TestCase;

class asunit.util.ArrayIteratorTest extends TestCase {
	private var className:String = "asunit.util.ArrayIteratorTest";
	private var instance:ArrayIterator;

	public function ArrayIteratorTest(testMethod:String) {
		super(testMethod);
	}

	public function setUp():Void {
		var arr:Array = new Array("one", "two", "three", "four", "five");
		instance = new ArrayIterator(arr);
	}

	public function tearDown():Void {
		delete instance;
	}

	public function testInstantiated():Void {
		assertTrue("ArrayIterator instantiated", instance instanceof ArrayIterator);
	}

	public function testIterate():Void {
		assertTrue("1", instance.hasNext());
		assertEquals("2", "one", instance.next());
		assertTrue("3", instance.hasNext());
		assertEquals("4", "two", instance.next());
		assertTrue("5", instance.hasNext());
		assertEquals("6", "three", instance.next());
		assertTrue("7", instance.hasNext());
		assertEquals("8", "four", instance.next());
		assertTrue("9", instance.hasNext());
		assertEquals("10", "five", instance.next());
		assertFalse("11", instance.hasNext());
	}
	
	public function testEmpty():Void {
		var itr:ArrayIterator = new ArrayIterator(new Array());
		assertFalse("1", itr.hasNext());
	}
	
	public function testSingleItem():Void {
		var itr:ArrayIterator = new ArrayIterator(new Array("one"));
		assertTrue(itr.hasNext());
		assertEquals("2", "one", itr.next());
		assertFalse("3", itr.hasNext());
		
	}
}
