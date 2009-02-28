
import com.asunit.framework.*;
import com.asunit.util.*;

class com.asunit.framework.TestCase extends Assert implements Test {
	private var methods:Array;
	private var className:String = "[ClassName Unknown]";

	// Abstract Class
	private function TestCase()
	{
		init();
	}

	private function init()
	{
		checkClassName(className);
		run();
	}

	private function checkClassName(name:String)
	{
	}

	private function getClassName():String
	{
		return className;
	}

	private function getHiddenMembers():Object
	{
		var obj:Object = new Object();
		obj.testFailed = true;
		obj.testSucceeded = true;
		obj.testMembers = true;
		return obj;
	}

	private function getMethods():Array
	{
		var arr:Array = new Array();
		var hiddenMembers:Object = getHiddenMembers();

		_global.ASSetPropFlags(this.__proto__, null, 6, true);
		for(var i:String in this) {
			if(i.indexOf("test") == 0 && !hiddenMembers[i] && this[i] instanceof Function) {
				arr.push(i);
			}
		}
		_global.ASSetPropFlags(this.__proto__, null, 1, true);
		arr.reverse();
		return arr;
	}

	private function runMethod(method:String)
	{
		setUp();
		setCurrentMethod(method);
		this[method]();
		tearDown();
	}

	private function createEmptyMovieClip(name:String, depth:Number):MovieClip {
		return _root.createEmptyMovieClip(name, depth);
	}

	private function createTextField(name:String, depth:Number, x:Number, y:Number, width:Number, height:Number):TextField {
	    _root.createTextField(name, depth, x, y, width, height);
	    return TextField(_root[name]);
	}

	private function getNextHighestDepth():Number {
		return _root.getNextHighestDepth();
	}

	// This helper method will support the following method signatures:
	// attachMovie(linkageId:String):MovieClip;
	// attachMovie(linkageId:String, initObject:Object):MovieClip;
	// attachMovie(linkageId:String, name:String, depth:Number):MovieClip;
	// attachMovie(linkageId:String, name:String, depth:Number, initObject:Object):MovieClip;
 	private function attachMovie():MovieClip {
 		var linkageId:String = arguments[0];
 		var name:String;
 		var depth:Number;
 		var initObj:Object = new Object();

		switch(arguments.length) {
			case 1 :
			case 2 :
			name = getValidName(_root, name);
			depth = getValidDepth(_root);
 			initObj = arguments[1];
 			break;
 			case 3 :
 			case 4 :
 			name = arguments[1];
 			depth = arguments[2];
 			initObj = arguments[3];
 			break;
		}
		return _root.attachMovie(linkageId, name, depth, initObj);
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

	private function run():Void
	{
		setCurrentClassName(className);
		var mList:Array = getMethods();
		for(var i:Number=0; i<mList.length; i++) {
			runMethod(mList[i]);
		}
		cleanUp();
	}

	public function cleanUp():Void {
	}

	public function onXmlLoaded(node:XMLNode):Void {
	}

	public function onTextFileLoaded(obj:TextFile):Void {
	}

	private function testFailed():Void
	{
	}

	private function testSucceeded():Void
	{
	}

	public function setUp():Void
	{
	}

	public function tearDown():Void
	{
	}
}
