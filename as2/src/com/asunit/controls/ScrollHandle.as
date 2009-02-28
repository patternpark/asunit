
import com.asunit.controls.*;
import com.asunit.controls.shapes.*;

class com.asunit.controls.ScrollHandle extends Rectangle {
	public static var linkageId:String = "__Packages.com.asunit.controls.ScrollHandle";
	public static var classRef:Function = ScrollHandle;
	private var controller:TextScroller;
	private var bgColor:Number = 0xCCCCCC;

	public function ScrollHandle() {
		init();
	}
	
	public function init():Void {
		onPress = doPress;
		onRelease = doRelease;
		onReleaseOutside = doReleaseOutside;
	}
	
	public function doPress():Void {
		onMouseMove = doMouseMove;
		controller.onScrollHandlePressed();
		startDrag(this, false, 0, _parent.upArrow._y, 0, _parent.getHandleTravel());
	}
	
	public function doReleaseOutside():Void {
		onRelease();
	}
	
	public function doMouseMove():Void {
		controller.onScrollHandleMoved();
		updateAfterEvent();
	}
	
	public function doRelease():Void {
		stopDrag();
		controller.onScrollHandleReleased();
		delete onMouseMove;
	}
	
	public static var serializable:Boolean = Object.registerClass(linkageId, classRef);
}