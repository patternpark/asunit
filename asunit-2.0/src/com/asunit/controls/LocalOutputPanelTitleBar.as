
import com.asunit.controls.*;
import com.asunit.controls.shapes.*;

class com.asunit.controls.LocalOutputPanelTitleBar extends Rectangle {
	public static var linkageId:String = "__Packages.com.asunit.controls.LocalOutputPanelTitleBar";
	public static var classRef:Function = LocalOutputPanelTitleBar;
	private var controller:LocalOutputPanel;
	private var title:TextField;
	private var txtFormat:TextFormat;

	public function LocalOutputPanelTitleBar() {
		init();
	}
	
	public function init():Void {
		onPress = doPress;
		onRelease = doRelease;
		createAssets();
	}
	
	public function createAssets():Void {
		createTextField("title", 1, 0, 0, width, height);
		title.wordWrap = true;
		title.selectable = false;
		
		txtFormat = new TextFormat();
		txtFormat.font = "Verdana";
		txtFormat.bold = true;
		txtFormat.leftMargin = 2;
		txtFormat.rightMargin = 20;
		txtFormat.size = 10;
		
		title.text = "AsUnit Output Panel [v." + controller.getVersion() + "]";
		title.setTextFormat(txtFormat);
	}
	
	public function doPress():Void {
		onMouseMove = doMouseMove;
	}
	
	public function doMouseMove():Void {
		controller.beginDrag();
		onRelease = doReleaseDrag;
		onMouseMove = doMouseUpdate;
	}
	
	public function doMouseUpdate():Void {
		updateAfterEvent();
	}
	
	public function doReleaseDrag():Void {
		delete onMouseMove;
		onRelease = doRelease;
		controller.endDrag();
	}
	
	public function onReleaseOutside():Void {
		doReleaseDrag();
	}
	
	public function doRelease():Void {
		Sys.println(">> title released");
		delete onMouseMove;
//		controller.toggleVisible();
	}
	
	public function setWidth(num:Number):Number {
		width = Math.round(num);
		title._width = width;
		refreshLayout();
		return width;
	}
	
	public function refreshLayout():Void {
		super.refreshLayout();
		title.width = width;
	}
	
	public static var serializable:Boolean = Object.registerClass(linkageId, classRef);
}