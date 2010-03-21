
import com.asunit.controls.shapes.*;

class com.asunit.controls.shapes.Triangle extends MovieClip {
	private var strokeSize:Number = 0;
	private var bgColor:Number = 0xCCCCCC;
	private var borderColor:Number = 0x666666;
	private var width:Number;
	private var height:Number;
	
	public function Triangle() {
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
		lineTo(width/2, height);
		lineTo(0,0);
	}	
}