package asunit4.printers {
	import asunit.errors.AssertionFailedError;
	import asunit.framework.ITestFailure;
	import asunit4.framework.IResult;
	import asunit4.framework.IRunListener;
	import asunit4.framework.ITestSuccess;
	import com.bit101.components.*;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	import flash.system.Capabilities;
	import asunit4.framework.Method;
	import flash.utils.getTimer;

	public class MinimalPrinter extends Sprite implements IRunListener {
		protected static const localPathPattern:RegExp = /([A-Z]:\\[^\/:\*\?<>\|]+\.\w{2,6})|(\\{2}[^\/:\*\?<>\|]+\.\w{2,6})/g;

		protected var header:Text;
		protected var dots:Text;
		protected var failuresField:Text;
		protected var footer:Text;
		protected var backgroundFill:Shape;
		
        protected var testTimes:Array;
		protected var startTime:Number;

		public function MinimalPrinter() {
			testTimes = [];
			
			if (stage)
				initUI();
			else
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function onRunStarted():void {
			
		}
		
		public function onTestFailure(failure:ITestFailure):void {
			var s:String = '';
			var stack:String = '';
			s += getQualifiedClassName(failure.failedTest);
			s += '.' + failure.failedMethod + ' : ';
			
			stack = failure.thrownException.getStackTrace();
			
			stack = stack.replace(localPathPattern, '');
			stack = stack.replace(/AssertionFailedError: /, '');

			s += stack + '\n\n';
			
			failuresField.text += s;
			dots.text += failure.isFailure ? 'F' : 'E';
		}
		
		public function onTestSuccess(success:ITestSuccess):void {
			dots.text += '.';
		}
		
		public function onTestIgnored(method:Method):void {
			dots.text += 'I';
		}
		
		public function onTestStarted(test:Object):void {
			//trace('MinimalPrinter.onTestStarted() - test: ' + test);
			startTime = getTimer();
		}
		
		public function onTestCompleted(test:Object):void {
            var duration:Number = getTimer() - startTime;
            testTimes.push({test:test, duration:duration});
        }
		
		public function onRunCompleted(result:IResult):void {
			//trace('???? result.wasSuccessful: ' + result.wasSuccessful);
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
		
		protected function print(string:String):void {
			footer.text += string;
		}
		
		protected function println(string:String = ""):void {
			print(string+'\n');
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
		
		
		protected function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(Event.RESIZE, onStageResize);
			initUI();
		}
		
		protected function onStageResize(e:Event):void {
			failuresField.width = stage.stageWidth;
			backgroundFill.width = stage.stageWidth;
			backgroundFill.height = stage.stageHeight;
		}
		
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

			dots = new Text(vbox);
			dots.width = 800;
			dots.height = 20;

			failuresField = new Text(vbox);
			failuresField.width = stage.stageWidth;
			failuresField.height = 300;
			failuresField.editable = false;
			
			footer = new Text(vbox);
			footer.width = 400;
			footer.height = 200;
			footer.editable = false;
		}
		
	}
}
