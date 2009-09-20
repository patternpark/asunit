package asunit.asserts {
	import asunit.framework.Assert;
	
	public function assertNull(...args:Array):void {
		Assert.assertNull.apply(null, args);
	}
	
}