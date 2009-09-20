package asunit.asserts {
	import asunit.framework.Assert;
	
	public function assertNotNull(...args:Array):void {
		Assert.assertNotNull.apply(null, args);
	}
	
}