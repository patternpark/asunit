package asunit.asserts {
	import asunit.framework.Assert;
	
	public function assertNotSame(...args:Array):void {
		Assert.assertNotSame.apply(null, args);
	}
	
}