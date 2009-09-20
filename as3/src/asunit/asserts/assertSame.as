package asunit.asserts {
	import asunit.framework.Assert;
	
	public function assertSame(...args:Array):void {
		Assert.assertSame.apply(null, args);
	}
	
}