class asunit.errors.UnimplementedFeatureError extends Error {

	public var fqcn:String = "asunit.errors.UnimplementedFeatureError";
	
	public function UnimplementedFeatureError(msg:String) {
		super(msg);
		name = "UnimplementedFeatureError";
	}
}