package asunit.asserts {
	import asunit.framework.Assert;
	
	public function assertEquals(...args:Array):void {
		Assert.assertEquals.apply(null, args);
	}
	
}