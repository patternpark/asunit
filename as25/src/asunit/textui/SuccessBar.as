class asunit.textui.SuccessBar extends MovieClip {
	private var myWidth:Number;
	private var myHeight:Number;
	private var bgColor:Number;
	private var passingColor:Number = 0x00FF00;
	private var failingColor:Number = 0xFD0000;

	public static function create(movieClip:MovieClip):SuccessBar{
		movieClip.__proto__ = SuccessBar.prototype;
		Function(SuccessBar).apply(movieClip);
		return SuccessBar(movieClip);
	}

	private function SuccessBar() {
	}

	public function setSuccess(success:Boolean):Void {
		bgColor = (success) ? passingColor : failingColor;
		draw();
	}

	public function set width(num:Number):Void {
		myWidth = num;
		draw();
	}

	public function set height(num:Number):Void {
		myHeight = num;
		draw();
	}

	private function draw():Void {
		clear();
		beginFill(bgColor);
		drawRect(0, 0, myWidth, myHeight);
		endFill();
	}
	
	private function drawRect(x:Number, y:Number, width:Number, height:Number):Void{
		moveTo(x,y);
		lineTo(x + width, y);
		lineTo(x + width, y + height);
		lineTo(x, y + height);
		lineTo(x,y);
	}
}