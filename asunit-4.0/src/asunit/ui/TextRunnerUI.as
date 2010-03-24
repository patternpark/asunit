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
            initialize();
		}

        protected function initialize():void {
            initializeResult();
            initializePrinters();
            initializeRunner();
        }

        protected function initializeResult():void {
            result = new Result();
        }

        protected function initializePrinters():void {
			printer = new TextPrinter();
			addChild(printer);
			result.addListener(printer);

			result.addListener(new FlashDevelopPrinter());
        }

        protected function initializeRunner():void {
			runner = new BaseRunner();
        }
		
		public function run(suite:Class, testMethod:String=null):void {
			runner.run(suite, result, testMethod, this);
		}
	}
}
