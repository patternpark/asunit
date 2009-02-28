
import com.asunit.controls.*;
import com.asunit.util.*;

class com.asunit.controls.LocalOutputPanelTextArea extends MovieClip {
	public static var linkageId:String = "__Packages.com.asunit.controls.LocalOutputPanelTextArea";	public static var classRef:Function = LocalOutputPanelTextArea;
	private var message:TextField;
	private var txtFormat:TextFormat;
	private var width:Number;
	private var height:Number;
	private var eventSrc:EventSource;
	
	public function LocalOutputPanelTextArea() {
		init();
	}
	
	public function init():Void {
		createAssets();
	}
	
	public function createAssets():Void {
		createTextField("message", 1, 0, 0, width, height);
		message.border = true;
		message.background = true;
		message.backgroundColor = 0x000000;
		message.textColor = 0x33FF00;
		message.wordWrap = true;
		message.selectable = true;
		
		txtFormat = new TextFormat();
		txtFormat.font = "Verdana";
		txtFormat.leftMargin = 2;
		txtFormat.rightMargin = 20;
		txtFormat.size = 11;
	}
	
	public function println(msg:String):String {
		message.text += msg + "\n";
		message.setTextFormat(txtFormat);
		message.scroll = message.maxscroll;
		return msg;
	}
	
	public function set text(str:String):Void {
		message.text = str;
		message.setTextFormat(txtFormat);
		eventSrc.broadcastMessage("onTextChanged", {event:"onTextChanged", source:this});
	}
	
	public function getTextField():TextField {
		return message;
	}
	
	public function get text():String {
		return message.text;
	}
	
	public function set htmlText(str:String):Void {
		message.htmlText = str;
	}
	
	public function get htmlText():String {
		return message.htmlText;
	}
	
	public function set scroll(num:Number):Void {
		message.scroll = num;
	}
	
	public function get maxscroll():Number {
		return message.maxscroll;
	}
	
	public function get bottomScroll():Number {
		return message.bottomScroll;
	}
	
	public function setWidth(num:Number):Number {
		width = Math.round(num);
		message._width = width;
		return message.width;
	}
	
	public function setHeight(num:Number):Number {
		height = Math.round(num);
		message._height = height;
		return message.height;
	}
	
	public function get scroll():Number {
		return message.scroll;
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
