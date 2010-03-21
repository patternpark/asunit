
import com.asunit.ui.*;

class SuccessMeter extends MovieClip {
	private var bg_mc:MovieClip;
	private var border_mc:MovieClip;
	private var _hasFailed:Boolean = false;

	private var successColor:Number = 0xA8E085;
	private var failureColor:Number = 0xDF412B;

	public function hasFailed():Boolean
	{
		return _hasFailed;
	}

	public function setSuccess(success:Boolean):Void
	{
		var col:Number = (success) ? successColor : failureColor;
		var bgColor:Color = new Color(bg_mc);
		bgColor.setRGB(col);
		if(!success) {
			_hasFailed = true;
		}
	}

	public function setSize(w:Number, h:Number):Void
	{
		_width = Math.floor(w);
		_height = Math.floor(h);
	}
}