package asunit.asserts {
	import asunit.framework.Assert;
	
	public function assertFalse(...args:Array):void {
		Assert.assertFalse.apply(null, args);
	}
	
}