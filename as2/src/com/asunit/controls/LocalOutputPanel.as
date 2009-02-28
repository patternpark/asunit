
import com.asunit.controls.*;
import com.asunit.util.*;

class com.asunit.controls.LocalOutputPanel extends MovieClip implements ScrollListener {
	public static var linkageId:String = "__Packages.com.asunit.controls.LocalOutputPanel";
	public static var classRef:Function = LocalOutputPanel;
	private var version:String = "2.0.0";
	private var isVisible:Boolean;
	private var broker:LocalMessageBroker;
	private var message:LocalOutputPanelTextArea;
	private var scroller:TextScroller;
	private var resize:ResizeHandle;
	private var title:LocalOutputPanelTitleBar;
	private var titleHeight:Number = 15;
	private var scrollerWidth:Number = 15;
	private var width:Number = 400;
	private var height:Number = 300;
	private var minWidth:Number = 100;
	private var minHeight:Number = 100;
	private var eventSrc:EventSource;
	
	public function LocalOutputPanel() {
		eventSrc = new EventSource();
		createAssets();
		init();
		Sys.println("---------------------");
		Sys.println(">> LocalOutput Panel Instantiated");
	}
	
	public function onConstruct():Void {
		Sys.println(">> whatup onConstruct? at :" + this);
	}
	
	public static function getInstance(parent:MovieClip, depth:Number):LocalOutputPanel {
		Sys.println(">> lcop getting instance with : " + parent + " depth : " + depth);
		if(parent.localOutputPanelInstance == undefined) {
			Sys.println(">> there is not another instance yet");
// 			Sys.println("--------------");
// 			for(var i in parent) {
// 				Sys.println(">> " + i + " : " + parent[i]);
// 			}
// 			Sys.println("--------------");
			if(parent.createChild != undefined) {
				Sys.println(">> creating child now with : " + LocalOutputPanel.linkageId);
				return LocalOutputPanel(parent.createChild(LocalOutputPanel, "localOutputPanelInstance"));
			} else {
				return LocalOutputPanel(parent.attachMovie(LocalOutputPanel.linkageId, "localOutputPanelInstance", depth));
			}
		} else {
			Sys.println(">> there is already another instance");
			trace(">> A Script has attempted to instantiate the com.asunit.controls.LocalOutputPanel after one instance already exists.");
		}
	}

	public function init():Void {
		isVisible = true;
		broker = LocalMessageBroker.getInstance();
 		broker.addListener(this);
 		Sys.useExternalOutput(false);
	}
	
	public function onUnLoad():Void {
		broker.removeListener(this);
	}
	
	public function createAssets():Void {
		var initObj:Object = new Object();
		initObj.width = width;
		initObj.height = titleHeight;
		initObj.controller = this;
		initObj._y = 0;
		title = LocalOutputPanelTitleBar(attachMovie(LocalOutputPanelTitleBar.linkageId, "title", 3, initObj));

		initObj = new Object();
		initObj.width = width;
		initObj.height = height - titleHeight;
		initObj._y = titleHeight;
		message = LocalOutputPanelTextArea(attachMovie(LocalOutputPanelTextArea.linkageId, "message", 1, initObj));
		
		initObj = new Object();
		initObj.controller = this;
		initObj.width = scrollerWidth;
		initObj.height = message._height - scrollerWidth;
		initObj._y = titleHeight;
		initObj._x = width - scrollerWidth;
		scroller = TextScroller(attachMovie(TextScroller.linkageId, "scroller", 2, initObj));
		scroller.addListener(this);
		
		initObj = new Object();
		initObj.controller = this;
		initObj.width = scrollerWidth;
		initObj.height = scrollerWidth;
		initObj._x = width - scrollerWidth;
		initObj._y = height - scrollerWidth;
		resize = ResizeHandle(attachMovie(ResizeHandle.linkageId, "resize", 4, initObj));
	}
	
	public function getVersion():String {
		return version;
	}
	
	public function getScrolledTextField():TextField {
		return message.getTextField();
	}
	
	public function onResizeHandleMoved():Void {
		setWidth(_xmouse+5);
		setHeight(_ymouse+5);
	}

	public function onMessageSent(evnt:Object):Void {
		println(evnt.message);
	}

	public function beginDrag():Void {
		startDrag(this);
	}
	
	public function endDrag():Void {
		stopDrag();
	}
	
	public function toggleVisible():Void {
		isVisible = !isVisible;
		_visible = isVisible;
	}
	
	public function onScrollUp(event:Object):Void {
		message.scroll -= 1;
		eventSrc.broadcastMessage("onScrollChanged", {event:"onScrollChanged", source:this});
	}
	
	public function onScrollDown(event:Object):Void {
		message.scroll += 1;
		eventSrc.broadcastMessage("onScrollChanged", {event:"onScrollChanged", source:this});
	}
	
	public function println(str:String):Void {
		message.println(str);
		eventSrc.broadcastMessage("onScrollChanged", {event:"onScrollChanged", source:this});
	}
		
	public function getTextField():TextField {
		return message.getTextField();
	}
		
	public function setWidth(num:Number):Number {
		width = Math.round(Math.max(num, minWidth));
		title.setWidth(width);
		scroller._x = width - scrollerWidth;
		resize._x = scroller._x;
		message.setWidth(width);
		return width;
	}
	
	public function setHeight(num:Number):Number {
		height = Math.round(Math.max(num, minHeight));
		scroller.setHeight(height - (titleHeight + scrollerWidth));
		resize._y = height - resize._height;
		message.setHeight(height - titleHeight);
		return height;
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

	public static var serializable:Boolean = Object.registerClass(linkageId, classRef);
}
