
dynamic class com.asunit.util.LocalConnServer extends LocalConnection {

	private var controller:Object;
	private var id:String;
	public var status:Boolean;

	public function LocalConnServer(ctrl:Object, srvrId:String) {
		init(ctrl, srvrId);
	}

	private function init(ctrl:Object, srvrId:String):Void {
		controller = ctrl;
		id = srvrId;
		status = connect(srvrId);
	}

	public function getId():String {
		return id;
	}

	public function close():Void {
		//trace(">> LocalConnServer Closing now from : " + id);
		super.close();
	}

	public function connect(str:String):Boolean {
		if(super.connect(str)) {
			return true;
		} else {
			trace("!! CONNECT CALL FAILED IN createServer with : " + getId());
			return false;
		}
	}

	public function allowDomain(domain:String):Boolean {
		// EXTREMELY INSECURE...
		return true;
	}

	public function allowInsecureDomain(domain:String):Boolean {
		return true;
	}

	// Used for synchronous communication...
	public function execResolve_sync(method:String):Object {
		arguments.shift();
		return controller[method].apply(controller, arguments);
	}

	// Used for asynchronous communication...
	public function execResolve( method:String):Void {
// 		trace(">> exec resolve called from the window swf with : " + arguments);
		arguments.shift();
		controller[method].apply(controller, arguments);
	}

	public function onStatus(infoObject:Object):Void {
		trace("!! Server LocalConnonStatus Called with : " + arguments + " id : " + getId());
	}
}
