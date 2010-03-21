
import com.asunit.controls.*;
import com.asunit.controls.shapes.*;
import com.asunit.util.*;

class com.asunit.controls.TextScroller extends Rectangle implements Observable {
	public static var linkageId:String = "__Packages.com.asunit.controls.TextScroller";
	public static var classRef:Function = TextScroller;
	private var eventSrc:EventSource;
	private var upArrow:ScrollArrow;
	private var downArrow:ScrollArrow;
	private var handle:ScrollHandle;
	private var textSrc:TextField;
	private var intervalId:Number;
	private var controller:ScrollListener;
	private var useHandCursor:Boolean = false;
	private var handleMinHeight:Number = 20;

	public function TextScroller() {
		init();
	}
	
	public function init():Void {
		eventSrc = new EventSource();
		createAssets();
	}
	
	public function createAssets():Void {
		var initObj:Object = new Object();
		initObj.controller = this;
		initObj.width = width;
		initObj.height = width;
		initObj._rotation = 180;
		initObj._y = width;
		initObj._x = width;
		upArrow = ScrollArrow(attachMovie(ScrollArrow.linkageId, "upArrow", 3, initObj));

		initObj._x = 0;
		initObj._y = height-width;
		initObj._rotation = 0;
		downArrow = ScrollArrow(attachMovie(ScrollArrow.linkageId, "downArrow", 4, initObj));
		
		initObj = new Object();
		initObj.controller = this;
		initObj._x = 0;
		initObj._y = downArrow._y - downArrow._height;
		initObj.height = width;
		initObj.width = width;
		handle = ScrollHandle(attachMovie(ScrollHandle.linkageId, "handle", 2, initObj));
	}
	
	public function onLoad():Void {
		textSrc = controller.getTextField();
		textSrc.addListener(this);
		refreshLayout();
	}
	
	public function onUnLoad():Void {
		controller.removeListener(this);
	}

	public function onScroller():Void {
		refreshHandle();
	}
		
	public function doScrollUp():Void {
		textSrc.scroll -= 1;
	}
	
	public function doScrollDown():Void {
		textSrc.scroll += 1;
	}
	
	public function scrollTo():Void {
	}

	public function onArrowPressed(ref:ScrollArrow):Void {
		onArrowClicked(ref._name);
		clearInterval(intervalId);
		intervalId = setInterval(this, "onArrowClicked", 300, ref._name);
	}
	
	public function onArrowClicked(arrowName:String):Void {
		if(intervalId != undefined) {
			clearInterval(intervalId);
			intervalId = setInterval(this, "onArrowClicked", 5, arrowName);
		}

		if(arrowName == "upArrow") {
			doScrollUp();
		} else if(arrowName == "downArrow") {
			doScrollDown();
		}
		refreshHandle();
	}
	
	public function onArrowReleased(ref:ScrollArrow):Void {
		clearInterval(intervalId);
		delete intervalId;
	}
	
	public function onScrollHandlePressed():Void {
		textSrc.removeListener(this);
	}
	
	public function onScrollHandleReleased():Void {
		textSrc.addListener(this);
	}
	
	public function onScrollHandleMoved():Void {
		var amt:Number = handle._y - upArrow._y;
		var total:Number = getHandleTravel() - upArrow._y;
		var perc:Number = amt/total;
		var scr:Number = (textSrc.maxscroll)*perc;
		textSrc.scroll = scr;
	}
	
	public function addEventListener(event:String, observer:Object, scope:Object):Void {
		eventSrc.addEventListener(event, observer, scope);
	}
	
	public function addListener(observer:Object, scope:Object):Void {
		eventSrc.addListener(observer, scope);
	}
	
	public function removeEventListener(event:String, observer:Object):Boolean {
		return eventSrc.removeEventListener(event, observer);
	}
	
	public function removeListener(observer:Object):Boolean {
		return eventSrc.removeListener(observer);
	}
	
	public function refreshLayout():Void {
		super.refreshLayout();
		downArrow._y = height - width;
		refreshHandle();
	}
	
	public function getHandleTravel():Number {
 		return height - (upArrow._height + handle._height);
	}
	
	public function refreshHandle():Void {
		var scroll:Number = textSrc.scroll;
		var bottomScroll:Number = textSrc.bottomScroll;
		var tMaxscroll:Number = textSrc.maxscroll;

		var amt:Number = bottomScroll-scroll;
		var total:Number = tMaxscroll + amt;
		var perc:Number = amt / total;

		var availHeight = height - (upArrow.height*2);
		handle._height = Math.min(availHeight, Math.max(handleMinHeight, Math.floor(availHeight*perc)));
			
		var travel:Number = getHandleTravel();
 		perc = scroll / tMaxscroll;
 		var y:Number = Math.round((travel*perc));
		handle._y = Math.max(upArrow._y, y);
	}

	public function setHeight(num:Number):Number {
		height = Math.round(num);
		refreshLayout();
		return height;
	}
	
	public static var serializable:Boolean = Object.registerClass(linkageId, classRef);
}