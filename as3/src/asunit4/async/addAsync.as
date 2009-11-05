package asunit4.async {
	
	/**
	 *
	 */
	//TODO: failureHandler:Function=null
	public function addAsync(handler:Function, duration:int = -1):Function {
		return Async.instance.addAsync(handler, duration);
	}
	
}
