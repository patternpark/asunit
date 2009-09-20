package asunit.asserts {
	import asunit.framework.Assert;
	
	public function assertEqualsArrays(...args:Array):void {
		Assert.assertEqualsArrays.apply(null, args);
	}
	
}