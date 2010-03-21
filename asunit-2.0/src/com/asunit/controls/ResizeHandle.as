
import com.asunit.controls.*;
import com.asunit.controls.shapes.*;

class com.asunit.controls.ResizeHandle extends Rectangle {
	public static var linkageId:String = "__Packages.com.asunit.controls.ResizeHandle";
	public static var classRef:Function = ResizeHandle;
	private var bgColor:Number = 0xCCCCCC;
	private var controller:Object;

	public function ResizeHandle() {
		onPress = doPress;
		onRelease = doRelease;
		onReleaseOutside = doReleaseOutside;
	}
	
	public function doPress():Void {
		onMouseMove = doMouseMove;
	}
	
	public function doReleaseOutside():Void {
		onRelease();
	}
	
	public function doMouseMove():Void {
		controller.onResizeHandleMoved();
		updateAfterEvent();
	}
	
	public function doRelease():Void {
		delete onMouseMove;
	}
	
	public static var serializable:Boolean = Object.registerClass(linkageId, classRef);
}