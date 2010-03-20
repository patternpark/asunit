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

	public class TextPrinter extends Sprite implements IRunListener {

        public static var DEFAULT_HEADER:String = "AsUnit 3.0 by Luke Bayes and Ali Mills\n\nFlash Player version: " + Capabilities.version
		public static var LOCAL_PATH_PATTERN:RegExp = /([A-Z]:\\[^\/:\*\?<>\|]+\.\w{2,6})|(\\{2}[^\/:\*\?<>\|]+\.\w{2,6})/g;

        public var columnCount:int = 80;
        public var localPathPattern:RegExp;

        private var failures:Array;
        private var successes:Array;
        private var ignores:Array;
		private var dots:Array;
		private var footer:String;
		private var header:String;

        private var testTimes:Array;
		private var startTime:Number;

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
			//if(stage) {
				//initUI();
            //} else {
				//addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            //}
		}
		
		public function onRunStarted():void {
		}
		
		public function onTestFailure(failure:ITestFailure):void {
            var s:String = '';
			s += getQualifiedClassName(failure.failedTest);
			s += '.' + failure.failedMethod + ' : ';
            s += getFailureStackTrace(failure);

            failures.push(s);
            dots.push(failure.isFailure ? 'F' : 'E');
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
		}
		
		public function onTestIgnored(method:Method):void {
			dots.push('I');
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
		}
		
		protected function print(str:String):void {
			footer += str;
		}
		
		protected function println(str:String = ""):void {
			print(str + "\n");
		}
		
        protected function printTimeSummary():void {
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
		
		//protected function onAddedToStage(e:Event):void {
			//removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//stage.addEventListener(Event.RESIZE, onStageResize);
			//initUI();
		//}
		
		//protected function onStageResize(e:Event):void {
			//failuresField.width = stage.stageWidth;
			//backgroundFill.width = stage.stageWidth;
			//backgroundFill.height = stage.stageHeight;
		//}
		
        /**
		protected function initUI():void {
			backgroundFill = new Shape();
			backgroundFill.graphics.beginFill(0x333333);
			backgroundFill.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			addChild(backgroundFill);
			
			Style.LABEL_TEXT = 0xFFFFFF;
			
			var vbox:VBox = new VBox(this);
			vbox.spacing = 0;
			
			header = new Text(vbox);
			header.width = 400;
			header.height = 50;
			header.editable = false;
			header.text = "AsUnit 3.0 by Luke Bayes and Ali Mills"
				+ "\n\n" + "Flash Player version: " + Capabilities.version

			//dots = new Text(vbox);
			//dots.width = 800;
			//dots.height = 20;

			failuresField = new Text(vbox);
			failuresField.width = stage.stageWidth;
			failuresField.height = 300;
			failuresField.editable = false;
		}
        */
	}
}

