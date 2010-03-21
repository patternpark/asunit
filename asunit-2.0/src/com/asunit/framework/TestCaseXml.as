
import com.asunit.framework.*;

class com.asunit.framework.TestCaseXml extends XML {

	public static var linkageId:String = "com.asunit.framework.TestCaseXml";
	public static var classRef:Function = TestCaseXml;

	private var source:String;
	private var callback:TestCase;
	
	public function TestCaseXml(src:String, cb:TestCase) {
		source = src;
		callback = cb;
		ignoreWhite = true;
		onLoad = doLoad;
		if(src != undefined) {
			load(source);
		}
	}
	
	public function doLoad(success:Boolean):Void {
		if(success) {
			callback.onXmlLoaded(this.firstChild);
		} else {
			Sys.println(">> there was an error loading XML at : " + source);
		}
	}
	
	public static var serializable:Boolean = Object.registerClass(linkageId, classRef);
}
