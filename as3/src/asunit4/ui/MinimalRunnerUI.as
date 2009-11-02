package asunit4.ui {
	import asunit4.framework.IResult;
	import asunit4.framework.Result;
	import asunit4.printers.FlashDevelopPrinter;
	import asunit4.printers.MinimalPrinter;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import asunit4.runners.BaseRunner;

	public class MinimalRunnerUI extends MovieClip {
		
		protected var printer:MinimalPrinter;
		protected var runner:BaseRunner;
		protected var result:IResult;
		
		public function MinimalRunnerUI() {
			if (stage) {
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
			}
		}
		
		public function run(suite:Class):void {
			printer = new MinimalPrinter();
			addChild(printer);
			
			result = new Result();
			result.addListener(printer);
			result.addListener(new FlashDevelopPrinter());
			
			runner = new BaseRunner();
			runner.run(suite, result);
		}
	}
}
