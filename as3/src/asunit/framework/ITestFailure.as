package asunit.framework
{

	/**
     *
	 */
	public interface ITestFailure {

		function get failedFeature():String;

		function get failedMethod():String;

		/**
		 * Gets the failed test case.
		 */
		function get failedTest():Object;

		/**
		 * Gets the thrown exception.
		 */
		function get thrownException():Error;

		function get exceptionMessage():String;

		function get isFailure():Boolean;

		/**
		 * Returns a short description of the failure.
		 */
		function toString():String;
	}
}
