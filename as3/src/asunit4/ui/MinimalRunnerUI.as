package asunit4.ui {
	import asunit4.printers.MinimalPrinter;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import asunit4.runners.BaseRunner;

	public class MinimalRunnerUI extends MovieClip {
		
		protected var printer:MinimalPrinter;
		protected var runner:BaseRunner;
		
		public function MinimalRunnerUI() {
			if (stage) {
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
			}
		}
		
		public function start(suite:Class):void {
			printer = new MinimalPrinter();
			addChild(printer);
			runner = new BaseRunner(printer);
			runner.start(suite);
		}
	}
}
