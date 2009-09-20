package asunit.asserts {
	import asunit.framework.Assert;
	
	public function assertTrue(...args:Array):void {
		Assert.assertTrue.apply(null, args);
	}
	
}