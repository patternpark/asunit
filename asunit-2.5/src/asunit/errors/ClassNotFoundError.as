class asunit.errors.ClassNotFoundError extends Error {
	
	public var fqcn:String = "asunit.errors.ClassNotFoundError";
	
	public function ClassNotFoundError(msg:String) {
		super(msg);
		name = "ClassNotFoundError";
	}
}