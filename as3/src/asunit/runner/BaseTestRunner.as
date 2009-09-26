package asunit.runner {
    import flash.display.Sprite;

    /**
     * Base class for all test runners.
     * This class was born live on stage in Sardinia during XP2000.
     */
    public class BaseTestRunner extends Sprite {

        // Filters stack trace to improve readability.
        public static function getFilteredTrace(stack:String):String {
			// Remove local file paths to focus on the class names preceding them.
			var localPathExp:RegExp = /([A-Z]:\\[^\/:\*\?<>\|]+\.\w{2,6})|(\\{2}[^\/:\*\?<>\|]+\.\w{2,6})/g;
			stack = stack.replace(localPathExp, '');
            return stack
        }
    }
 }
