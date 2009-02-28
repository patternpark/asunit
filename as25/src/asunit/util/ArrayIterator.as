import asunit.util.Iterator;

class asunit.util.ArrayIterator implements Iterator {
	private var list:Array;
	private var index:Number = 0;

	public function ArrayIterator(list:Array) {
		this.list = list;
	}

	public function hasNext():Boolean {
		return list[index] != null;
	}

	public function next():Object {
		return list[index++];
	}

	public function reset():Void {
		index = 0;
	}
}
