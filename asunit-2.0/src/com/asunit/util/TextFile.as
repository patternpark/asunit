
class com.asunit.util.TextFile extends XML {
	public static var linkageId:String = "com.asunit.util.TextFile";
	public static var classRef:Function = TextFile;

	private var source:String;
	private var callback:Object;
	private var fileString:String;
	
	public function TextFile(src:String, cb:Object) {
		source = src;
		callback = cb;
		ignoreWhite = true;
		onData = doData;
		if(src != undefined) {
			load(source);
		}
	}
	
	public function doData(str:String):Void {
		fileString = str;
		callback.onTextFileLoaded(this);
	}
	
	public function toString():String {
		return fileString;
	}
		
	public static var serializable:Boolean = Object.registerClass(linkageId, classRef);
}
