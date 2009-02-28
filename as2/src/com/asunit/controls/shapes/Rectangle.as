
import com.asunit.controls.shapes.*;

class com.asunit.controls.shapes.Rectangle extends MovieClip {
	private var strokeSize:Number = 0;
	private var bgColor:Number = 0xEEEEEE;
	private var borderColor:Number = 0x666666;
	public var width:Number;
	public var height:Number;
	
	public function Rectangle() {
	}
	
	public function onLoad():Void {
		refreshLayout();
	}
	
	public function refreshLayout():Void {
		clear();
		lineStyle(strokeSize, borderColor, 100);
		beginFill(bgColor, 100);
		moveTo(0, 0);
		lineTo(width, 0);
		lineTo(width, height);
		lineTo(0, height);
		lineTo(0, 0);
	}
	
}