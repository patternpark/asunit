class asunit.errors.InstanceNotFoundError extends Error {
	
	public var fqcn:String = "asunit.errors.InstanceNotFoundError";
	
	public function InstanceNotFoundError(msg:String) {
		super(msg);
		name = "InstanceNotFoundError";
	}
}