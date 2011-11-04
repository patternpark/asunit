package asunit.printers {

    import asunit.framework.IResult;
    import asunit.framework.IRunListener;
    import asunit.framework.ITestFailure;
    import asunit.framework.ITestSuccess;
    import asunit.framework.ITestWarning;
    import asunit.framework.Method;

    import flash.system.Capabilities;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getTimer;

    public class ColorTracePrinter implements IRunListener {
        public static const LOCAL_PATH_PATTERN:RegExp = /([A-Z]:\\[^\/:\*\?<>\|]+\.\w{2,6})|(\\{2}[^\/:\*\?<>\|]+\.\w{2,6})/g;
        public static const DEFAULT_HEADER:String = "AsUnit 4.0 by Luke Bayes, Ali Mills and Robert Penner\n\nFlash Player version: " + Capabilities.version
        public static const DEFAULT_FOOTER:String = "";
		public static const DEFAULT_PERFORMANCE_COUNT:int = 10;

        public var header:String                     = DEFAULT_HEADER;
        public var footer:String                     = DEFAULT_FOOTER;
        public var displayPerformanceDetails:Boolean = true;
        public var hideLocalPaths:Boolean            = false;
        public var localPathPattern:RegExp           = LOCAL_PATH_PATTERN;
        public var performanceCount:int              = DEFAULT_PERFORMANCE_COUNT;

        private var dots:Array;
        private var failures:Array;
        private var ignores:Array;
        private var runCompleted:Boolean;
        private var startTime:Number;
        private var successes:Array;
        private var testTimes:Array;
        private var warnings:Array;

        public function ColorTracePrinter() {
            initialize();
        }

        private function initialize():void {
            dots      = [];
            failures  = [];
            ignores   = [];
            successes = [];
            testTimes = [];
            warnings  = [];
        }

        public function onRunStarted():void {
        }
        
        public function onTestFailure(failure:ITestFailure):void {
            var s:String = '';
            s += red(getQualifiedClassName(failure.failedTest));
            s += red('.' + failure.failedMethod) + ' : ';
            s += getFailureStackTrace(failure);

            failures.push(s);
            dots.push(failure.isFailure ? red('F') : red('E'));
        }

        private function getFailureStackTrace(failure:ITestFailure):String {
            var stack:String = "";
            stack = failure.thrownException.getStackTrace();
			if (hideLocalPaths) 
				stack = stack.replace(localPathPattern, '');
            stack = stack.replace(/AssertionFailedError: /, '');
            stack += "\n\n";
            return stack;
        }
        
        public function onTestSuccess(success:ITestSuccess):void {
            dots.push('.');
        }
        
        public function onTestIgnored(method:Method):void {
            dots.push(yellow('I'));
            ignores.push(getIgnoreFromMethod(method));
        }

        private function getIgnoreFromMethod(method:Method):String {
            var message:String 
				= "[" + yellow("Ignore") + "] "
				+ yellow(method.scopeName + "." + method.toString());
				
            if (method.ignoreDescription) {
               message += " (" + method.ignoreDescription + ")"; 
            }
            return message;
        }

        public function onWarning(warning:ITestWarning):void {
            warnings.push(getWarning(warning));
        }

		private function getWarning(warning:ITestWarning):String {
			var message:String 
				= "[" + yellow("Warning") + "] "
				+ (warning.method ? yellow(warning.method.scopeName + "." + warning.method.toString()) : "")
				+ warning.message;
			return message;
		}
        
        public function onTestStarted(test:Object):void {
            startTime = getTimer();
        }
        
        public function onTestCompleted(test:Object):void {
            var duration:Number = getTimer() - startTime;
            testTimes.push({test:test, duration:duration});
        }
        
        public function onRunCompleted(result:IResult):void {
            runCompleted = true;
            printRunSummary(result);
            printTimeSummary();
            printPerformanceDetails();
            logResult();
        }

        protected function logResult():void {
			trace(toString());
        }
        
        private function print(str:String):void {
            footer += str;
        }
        
        private function println(str:String = ""):void {
            print(str + "\n");
        }

		private function printRunSummary(result:IResult):void {
			if (result.runCount == 0) {
                println(yellow("[WARNING] No tests were found or executed."));
                println();
                return;
            }
			
			if (result.wasSuccessful) {
                println("[ " + green("OK") + " ]");
				println();
                println("Tests run: " + result.runCount);
            }
            else {
                println("[ " + red("FAILURE") + " ]");
				println();
                println("Tests run: " + result.runCount
                    + ",  Failures: " + result.failureCount
                    + ",  Errors: " + result.errorCount
                    + ",  Ignored: " + result.ignoredTestCount
                    );
            }
		}

        private function printTimeSummary():void {
            testTimes.sortOn('duration', Array.NUMERIC | Array.DESCENDING);
            var totalTime:Number = 0;
            var len:Number = testTimes.length;
            for (var i:uint; i < len; i++) {
                totalTime += testTimes[i].duration;
            }
            println("Total Time: " + totalTime + ' ms');
            println();
        }

        private function printPerformanceDetails():void {
			if (!displayPerformanceDetails)
				return;
				
            testTimes.sortOn('duration', Array.NUMERIC | Array.DESCENDING);
            println('Time Summary:');
            println();
            var len:Number = Math.min(performanceCount, testTimes.length);
            var total:Number = 0;
            var testTime:Object;
            for (var i:Number = 0; i < len; i++) {
                testTime = testTimes[i];
                println(testTime.duration + ' ms : ' + cyan(getQualifiedClassName(testTime.test)));
            }
        }

        public function toString():String {
            var parts:Array = [];
            parts.push(header);
            var len:int = dots.length;
            var str:String = '';
            for (var i:int; i < len; i++) {
                str += dots[i];
            }
            parts.push(str);

            if (runCompleted) {
                if (failures.length > 0) {
                    parts = parts.concat(failures);
                }
                if (warnings.length > 0) {
                    parts = parts.concat(warnings);
                }
                if (ignores.length > 0) {
                    // Tighten up the ignores line breaks:
                    parts.push(ignores.join("\n"));
                }
                parts.push(footer);
            }
            return parts.join("\n\n") + "\n\n";
        }
    }
}

import flash.system.Capabilities;

//	foreground
//
//	31	red
//	32 	green
// 	33	yellow
// 	34 	blue
//	35	purple
//	36	cyan
//	37	gray
//
//	background
//
//	40	black
//	41	red
//	42 	green
//	43	yellow
//	44	blue
//	45	purple
//	46	cyan
//	47 	gray
//
//	modifiers
//
//	\e[1;{fg};{bg}m 	bold fg
//	\e[4;{fg};{bg}m 	bold bg
//	\e[5;{fg};{bg}m 	bold fg bg
// 
//	see http://kpumuk.info/ruby-on-rails/colorizing-console-ruby-script-output/
internal const ASCII_ESCAPE_CHARACTER:String = String.fromCharCode(27);

internal const RESET:String = "0";
internal const RED:String = "31";
internal const GREEN:String = "32";
internal const YELLOW:String = "33";
internal const BLUE:String = "34";
internal const PURPLE:String = "35";
internal const CYAN:String = "36";
internal const colorise:Boolean = (!Capabilities.os.match(/Windows/));

internal function color(value:String):String
{
	return colorise ? ASCII_ESCAPE_CHARACTER + "[" + value + "m" : "";
}

internal function reset():String 
{
	return color(RESET);
}

internal function red(message:String):String 
{
	return color(RED) + message + color(RESET);
}

internal function green(message:String):String 
{
	return color(GREEN) + message + color(RESET);
}

internal function yellow(message:String):String 
{
	return color(YELLOW) + message + color(RESET);
}

internal function blue(message:String):String 
{
	return color(BLUE) + message + color(RESET);
}

internal function purple(message:String):String 
{
	return color(PURPLE) + message + color(RESET);
}

internal function cyan(message:String):String 
{
	return color(CYAN) + message + color(RESET);
}