package asunit4.ui {
	import asunit4.framework.IResult;
	import asunit4.framework.Result;
	import asunit4.printers.FlashBuilderPrinter;
	import asunit4.runners.BaseRunner;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.fscommand;

	public class FlashBuilderRunnerUI extends MovieClip {
		
		protected var runner:BaseRunner;
		
		public function FlashBuilderRunnerUI() {
			runner = new BaseRunner();
			runner.addEventListener(Event.COMPLETE, onRunnerComplete);
		}
		
		public function run(suite:Class, projectName:String = ""):void {
			var result:IResult = new Result();
			result.addListener(new FlashBuilderPrinter(projectName));
			runner.run(suite, result);
		}
		
		protected function onRunnerComplete(e:Event):void {
			fscommand('quit'); // fails silently if not in debug player
			//System.exit(0); // generates SecurityError if not in debug player
		}
	}
}
