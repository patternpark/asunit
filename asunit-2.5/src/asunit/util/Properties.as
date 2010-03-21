import asunit.errors.UnimplementedFeatureError;
import asunit.flash.errors.IllegalOperationError;

dynamic class asunit.util.Properties {

	public function store(sharedObjectId:String):Void {
		throw new UnimplementedFeatureError("Properties.store");
	}

	public function put(key:String, value:Object):Void {
		this[key] = value;
	}

	public function setProperty(key:String, value:Object):Void {
		put(key, value);
	}

	public function getProperty(key:String):Object {
		try {
			return this[key];
		}
		catch(e:Error) {
			throw IllegalOperationError("Properties.getProperty");
		}
		return null;
	}
}