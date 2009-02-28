
import com.asunit.ui.*;

class RemoteVersion extends XML {
	private var callback:Main;
	
	public function RemoteVersion(cb:Main) {
		callback = cb;
		init();
	}
	
	public function init():Void {
		ignoreWhite = true;
		load("http://www.asunit.com/version.xml?userVersion=" + callback.getVersionNumber());
	}
	
	public function onLoad(success:Boolean):Void {
		parseVersion(this.firstChild.firstChild);
	}
	
	public function parseVersion(node:XMLNode):Void {
		callback.checkRemoteVersion(node.firstChild.nodeValue);
	}
}