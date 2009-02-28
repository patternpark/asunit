/**
 * Base class for all test runners.
 * This class was born live on stage in Sardinia during XP2000.
 */
class asunit.runner.BaseTestRunner extends MovieClip {

	// Filters stack frames from internal JUnit classes
	public static function getFilteredTrace(stack:String):String {
		return stack;
	}
}
