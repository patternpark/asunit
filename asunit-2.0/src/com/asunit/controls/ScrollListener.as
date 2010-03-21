
import com.asunit.controls.*;
import com.asunit.util.*;

interface com.asunit.controls.ScrollListener extends Observable {
	
	public function onScrollUp(event:Object):Void;
	public function onScrollDown(event:Object):Void;
	public function getTextField():TextField;
}
