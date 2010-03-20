package asunit4.ui {
	import asunit4.framework.IResult;
	import asunit4.framework.Result;
	import asunit4.printers.FlashDevelopPrinter;
	import asunit4.printers.TextPrinter;
	import asunit4.runners.BaseRunner;

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	public class TextRunnerUI extends MovieClip {
		
		protected var printer:TextPrinter;
		protected var runner:BaseRunner;
		protected var result:IResult;
		
		public function TextRunnerUI() {
			if (stage) {
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
			}
		}
		
		public function run(suite:Class):void {
			printer = new TextPrintur();
			addChild(printer);
			
			result = new Result();
			result.addListener(printer);
			result.addListener(new FlashDevelopPrinter());
			
			runner = new BaseRunner();
			runner.run(suite, result);
		}
	}
}
