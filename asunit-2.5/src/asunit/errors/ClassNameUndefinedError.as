class asunit.errors.ClassNameUndefinedError extends Error {
	
	public var fqcn:String = "ClassNameUndefinedError";
		public function ClassNameUndefinedError(message : String){		super(message);
		name = "ClassNameUndefinedError";	}
}