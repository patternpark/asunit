class asunit.errors.AssertionFailedError extends Error {
	
	public var fqcn:String = "asunit.errors.AssertionFailedError";
	
	public function AssertionFailedError(msg:String) {
		super(msg);
		name = "AssertionFailedError";
	}
}