package asunit.ui {
	import asunit.framework.IResult;
	import asunit.framework.Result;
	import asunit.printers.FlashDevelopPrinter;
	import asunit.runners.BaseRunner;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.fscommand;

	public class FlashDevelopRunnerUI extends MovieClip {
		
		protected var runner:BaseRunner;
		
		public function FlashDevelopRunnerUI() {
			runner = new BaseRunner();
			runner.addEventListener(Event.COMPLETE, onRunnerComplete);
		}
		
		public function run(suite:Class):void {
			var result:IResult = new Result();
			result.addListener(new FlashDevelopPrinter());
			runner.run(suite, result);
		}
		
		protected function onRunnerComplete(e:Event):void {
			fscommand('quit'); // fails silently if not in debug player
			//System.exit(0); // generates SecurityError if not in debug player
		}
	}
}
