package asunit.framework {

	/**
     *
	 */
	public interface ITestSuccess {

		/**
		 * Gets the test case.
		 */
		function get test():Object;

		function get method():String;

		function get feature():String;
		
		/**
		 * Returns a short description of the failure.
		 */
		function toString():String;
	}
}
