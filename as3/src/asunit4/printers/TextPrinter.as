package asunit4.printers {

	import asunit.framework.ITestFailure;

	import asunit4.framework.IResult;
	import asunit4.framework.IRunListener;
	import asunit4.framework.ITestSuccess;
	import asunit4.framework.Method;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
    import flash.text.TextField;
    import flash.text.TextFormat;

	public class TextPrinter extends Sprite implements IRunListener {

        public static var DEFAULT_HEADER:String = "AsUnit 3.0 by people just like you.\n\nFlash Player version: " + Capabilities.version
		public static var LOCAL_PATH_PATTERN:RegExp = /([A-Z]:\\[^\/:\*\?<>\|]+\.\w{2,6})|(\\{2}[^\/:\*\?<>\|]+\.\w{2,6})/g;

        public var columnCount:int = 80;
        public var localPathPattern:RegExp;

        private var backgroundFill:Shape;
		private var dots:Array;
		private var footer:String;
		private var header:String;
		private var startTime:Number;
        private var failures:Array;
        private var ignores:Array;
        private var resultBar:Shape;
        private var resultBarHeight:uint = 3;
        private var successes:Array;
        private var testTimes:Array;
        private var textDisplay:TextField;

        private var runCompleted:Boolean;

		public function TextPrinter() {
            initialize();
        }

        private function initialize():void {
            dots      = [];
            failures  = [];
            ignores   = [];
            successes = [];
			testTimes = [];
			
            footer           = '';
            header           = DEFAULT_HEADER;
            localPathPattern = LOCAL_PATH_PATTERN;
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
			stack = stack.replace(localPathPattern, '');
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
            updateTextDisplay();
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

            if (result.wasSuccessful) {
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
			printTimeSummary();
            updateTextDisplay();
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
		
        private function printTimeSummary():void {
            testTimes.sortOn('duration', Array.NUMERIC | Array.DESCENDING);
            println();
            println();
            println('Time Summary:');
            println();
            var len:Number = testTimes.length;
            for (var i:Number = 0; i < len; i++) {
				var testTime:Object = testTimes[i];
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
                parts.push(footer);
            }
            return parts.join("\n\n");
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
		
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			initializeDisplay();
            updateTextDisplay();
		}
		
		private function onStageResize(e:Event):void {
			backgroundFill.width = stage.stageWidth;
			backgroundFill.height = stage.stageHeight;
            textDisplay.width = stage.stageWidth;
            textDisplay.height = stage.stageHeight;
		}
		
		private function initializeDisplay():void {
			stage.addEventListener(Event.RESIZE, onStageResize);

			backgroundFill = new Shape();
			backgroundFill.graphics.beginFill(0x333333);
			backgroundFill.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			addChild(backgroundFill);

            textDisplay = new TextField();
            textDisplay.multiline = true;
            textDisplay.wordWrap = true;
            textDisplay.textColor = 0xFFFFFF;
            textDisplay.x = 0;
            textDisplay.y = 0;
            textDisplay.width     = stage.stageWidth;
            textDisplay.height    = stage.stageHeight;

            var format:TextFormat = textDisplay.getTextFormat();
            format.font           = '_sans';
            format.size           = 12;
            format.leftMargin     = 5;
            format.rightMargin    = 5;
            textDisplay.defaultTextFormat = format;

            addChild(textDisplay);
			
            resultBar = new Shape();
            addChild(resultBar);
		}
	}
}

