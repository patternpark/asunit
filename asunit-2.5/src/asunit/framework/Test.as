import asunit.framework.TestListener;

import asunit.flash.events.IEventDispatcher;
	
interface asunit.framework.Test extends IEventDispatcher{
	function countTestCases():Number;
	function getName():String;
	function getTestMethods():Array;
	function toString():String;
	function setResult(result : TestListener) : Void;
	function run():Void;
	function runBare():Void;
	function getCurrentMethod():String;
	function getIsComplete():Boolean;
	function setContext(context:MovieClip):Void;
	function getContext():MovieClip;
}