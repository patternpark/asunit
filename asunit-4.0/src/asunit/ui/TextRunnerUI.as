package asunit.ui {
	import asunit.framework.IResult;
	import asunit.framework.Result;
	import asunit.printers.FlashDevelopPrinter;
	import asunit.printers.TextPrinter;
	import asunit.runners.BaseRunner;

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	public class TextRunnerUI extends MovieClip {
		
		protected var printer:TextPrinter;
		protected var runner:BaseRunner;
		protected var result:IResult;
		
		public function TextRunnerUI() {
			if (stage) {
				stage.align     = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
			}
		}
		
		public function run(suite:Class, testMethod:String=null):void {
		    trace(">> running with: " + suite);
			printer = new TextPrinter();
			addChild(printer);
			
			result = new Result();
			result.addListener(printer);
			result.addListener(new FlashDevelopPrinter());
			
			runner = new BaseRunner();
			runner.run(suite, result, testMethod, this);
		}
	}
}
