
import com.asunit.controls.*;
import com.asunit.controls.shapes.*;

class com.asunit.controls.ScrollArrow extends Rectangle {
	public static var linkageId:String = "__Packages.com.asunit.controls.ScrollArrow";
	public static var classRef:Function = ScrollArrow;
	private var controller:TextScroller;
	private var bgColor:Number = 0xCCCCCC;

	public function ScrollArrow() {
		init();
	}
	
	public function init():Void {
		onPress = doPress;
		onRelease = doRelease;
		onReleaseOutside = doReleaseOutside;
	}
	
	public function doPress():Void {
		controller.onArrowPressed(this);
	}
	
	public function doReleaseOutside():Void {
		onRelease();
	}
	
	public function doRelease():Void {
		controller.onArrowReleased(this);
	}
	
	public static var serializable:Boolean = Object.registerClass(linkageId, classRef);
}