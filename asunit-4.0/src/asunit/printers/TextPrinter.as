package asunit.printers {

    import asunit.framework.IResult;
    import asunit.framework.IRunListener;
    import asunit.framework.ITestFailure;
    import asunit.framework.ITestSuccess;
    import asunit.framework.ITestWarning;
    import asunit.framework.Method;

    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.system.Capabilities;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getTimer;

    public class TextPrinter extends Sprite implements IRunListener {
        public static const LOCAL_PATH_PATTERN:RegExp = /([A-Z]:\\[^\/:\*\?<>\|]+\.\w{2,6})|(\\{2}[^\/:\*\?<>\|]+\.\w{2,6})/g;
        public static const DEFAULT_BACKGROUND_COLOR:uint = 0x333333;
        public static const DEFAULT_HEADER:String = "AsUnit 4.0 by Luke Bayes, Ali Mills and Robert Penner\n\nFlash Player version: " + Capabilities.version
        public static const DEFAULT_FOOTER:String = "";
        public static const DEFAULT_FONT_SIZE:int = 12;
        public static const DEFAULT_PERFORMANCE_COUNT:int = 10;
        public static const DEFAULT_TEXT_COLOR:uint = 0xffffff;

        public var header:String                     = DEFAULT_HEADER;
        public var footer:String                     = DEFAULT_FOOTER;
        public var backgroundColor:uint              = DEFAULT_BACKGROUND_COLOR;
        public var textColor:uint                    = DEFAULT_TEXT_COLOR;
        public var displayPerformanceDetails:Boolean = true;
        public var traceOnComplete:Boolean           = true;
        public var hideLocalPaths:Boolean            = false;
        public var localPathPattern:RegExp           = LOCAL_PATH_PATTERN;
        public var performanceCount:int              = DEFAULT_PERFORMANCE_COUNT;

        protected var textDisplay:TextField;

        private var backgroundFill:Shape;
        private var dots:Array;
        private var failures:Array;
        private var ignores:Array;
        private var resultBar:Shape;
        private var resultBarHeight:uint = 3;
        private var runCompleted:Boolean;
        private var startTime:Number;
        private var successes:Array;
        private var testTimes:Array;
        private var warnings:Array;

        public function TextPrinter() {
            initialize();
        }

        private function initialize():void {
            dots      = [];
            failures  = [];
            ignores   = [];
            successes = [];
            testTimes = [];
            warnings  = [];
            
            if(stage) {
                initializeDisplay();
            } else {
                addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            }
        }

        public function onRunStarted():void {
            updateTextDisplay();
        }
        
        public function onTestFailure(failure:ITestFailure):void {
            var s:String = '';
            s += getQualifiedClassName(failure.failedTest);
            s += '.' + failure.failedMethod + ' : ';
            s += getFailureStackTrace(failure);

            failures.push(s);
            dots.push(failure.isFailure ? 'F' : 'E');
            updateTextDisplay();
        }

        private function getFailureStackTrace(failure:ITestFailure):String {
            var stack:String = "";
            stack = failure.thrownException.getStackTrace();
			if (hideLocalPaths) stack = stack.replace(localPathPattern, '');
            stack = stack.replace(/AssertionFailedError: /, '');
            stack += "\n\n";
            return stack;
        }
        
        public function onTestSuccess(success:ITestSuccess):void {
            dots.push('.');
            updateTextDisplay();
        }
        
        public function onTestIgnored(method:Method):void {
            dots.push('I');
            ignores.push(getIgnoreFromMethod(method));
            updateTextDisplay();
        }

        private function getIgnoreFromMethod(method:Method):String {
            var message:String = "[Ignore] found at: " + method.scopeName + "." + method.toString();
            if(method.ignoreDescription) {
               message += " (" + method.ignoreDescription + ")"; 
            }
            return message;
        }

        public function onWarning(warning:ITestWarning):void {
            warnings.push(warning.toString());
        }
        
        public function onTestStarted(test:Object):void {
            startTime = getTimer();
            updateTextDisplay();
        }
        
        public function onTestCompleted(test:Object):void {
            var duration:Number = getTimer() - startTime;
            testTimes.push({test:test, duration:duration});
            updateTextDisplay();
        }
        
        public function onRunCompleted(result:IResult):void {
            runCompleted = true;
            if(result.runCount == 0) {
                println("[WARNING] No tests were found or executed.");   
                println();
                return;
            }

            printTimeSummary();

            if(result.wasSuccessful) {
                print("OK");
                println (" (" + result.runCount + " test" + (result.runCount == 1 ? "": "s") + ")");
            }
            else {
                println("FAILURES!!!");
                println("Tests run: " + result.runCount
                    + ",  Failures: " + result.failureCount
                    + ",  Errors: " + result.errorCount
                    + ",  Ignored: " + result.ignoredTestCount
                    );
            }
            if(displayPerformanceDetails) {
                printPerformanceDetails();
            }
            updateTextDisplay();
            logResult();
        }

        protected function logResult():void {
            if(traceOnComplete) {
                trace(toString());
            }
        }
        
        private function print(str:String):void {
            footer += str;
        }
        
        private function println(str:String = ""):void {
            print(str + "\n");
        }

        private function printTimeSummary():void {
            testTimes.sortOn('duration', Array.NUMERIC | Array.DESCENDING);
            println();
            var totalTime:Number = 0;
            var len:Number = testTimes.length;
            for(var i:uint; i < len; i++) {
                totalTime += testTimes[i].duration;
            }
            println("Total Time: " + totalTime + ' ms');
            println();
        }

        private function printPerformanceDetails():void {
            testTimes.sortOn('duration', Array.NUMERIC | Array.DESCENDING);
            println();
            println();
            println('Time Summary:');
            println();
            var len:Number = Math.min(performanceCount, testTimes.length);
            var total:Number = 0;
            var testTime:Object;
            for (var i:Number = 0; i < len; i++) {
                testTime = testTimes[i];
                println(testTime.duration + ' ms : ' + getQualifiedClassName(testTime.test));
            }
        }

        override public function toString():String {
            var parts:Array = [];
            parts.push(header);
            var len:int = dots.length;
            var str:String = '';
            for(var i:int; i < len; i++) {
                str += dots[i];
            }
            parts.push(str);

            if(runCompleted) {
                if(failures.length > 0) {
                    parts = parts.concat(failures);
                }
                if(warnings.length > 0) {
                    parts = parts.concat(warnings);
                }
                if(ignores.length > 0) {
                    // Tighten up the ignores line breaks:
                    parts.push(ignores.join("\n"));
                }
                parts.push(footer);
            }
            return parts.join("\n\n") + "\n\n";
        }

        private function updateTextDisplay():void {
            if(textDisplay) {
                textDisplay.text = toString();
                updateResultBar();
            }
        }

        private function updateResultBar():void {
            if(stage) {
                var color:uint = (failures.length > 0) ? 0xFF0000 : 0x00FF00;
                resultBar.graphics.clear();
                resultBar.graphics.beginFill(color);
                resultBar.graphics.drawRect(0, 0, stage.stageWidth, resultBarHeight);
                resultBar.y = stage.stageHeight - resultBarHeight;
            }
        }
        
        private function onAddedToStage(event:Event):void {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
            initializeDisplay();
            updateTextDisplay();
        }

        private function onRemovedFromStage(event:Event):void {
            stage.removeEventListener(Event.RESIZE, onStageResize);
        }
        
        private function onStageResize(event:Event):void {
            backgroundFill.width  = stage.stageWidth;
            backgroundFill.height = stage.stageHeight;
            textDisplay.width     = stage.stageWidth;
            textDisplay.height    = stage.stageHeight;
            updateResultBar();
        }
        
        private function initializeDisplay():void {
            stage.align     = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.addEventListener(Event.RESIZE, onStageResize);

            backgroundFill = new Shape();
            backgroundFill.graphics.beginFill(backgroundColor);
            backgroundFill.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
            addChild(backgroundFill);

            textDisplay = new TextField();
            textDisplay.multiline = true;
            textDisplay.wordWrap = true;
            textDisplay.textColor = textColor;
            textDisplay.x = 0;
            textDisplay.y = 0;
            textDisplay.width     = stage.stageWidth;
            textDisplay.height    = stage.stageHeight;

            var format:TextFormat = textDisplay.getTextFormat();
            format.font           = '_sans';
            format.size           = DEFAULT_FONT_SIZE;
            format.leftMargin     = 5;
            format.rightMargin    = 5;
            textDisplay.defaultTextFormat = format;

            addChild(textDisplay);
            
            resultBar = new Shape();
            addChild(resultBar);
        }
    }
}
