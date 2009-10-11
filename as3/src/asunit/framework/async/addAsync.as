package asunit.framework.async {
	
	/**
	 *
	 */
	//TODO: failureHandler:Function=null
	public function addAsync(test:Object, handler:Function, duration:Number=0):Function {
		return Async.instance.addAsync(test, handler, duration);
	}
	
}
