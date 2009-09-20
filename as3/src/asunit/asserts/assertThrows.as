package asunit.asserts {
	import asunit.framework.Assert;
	
	public function assertThrows(errorType:Class, block:Function):void {
		Assert.assertThrows(errorType, block);
	}
	
}