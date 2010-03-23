package asunit.ui {
	import asunit.framework.IResult;
	import asunit.framework.Result;
	import asunit.printers.FlashBuilderPrinter;
	import asunit.runners.BaseRunner;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.fscommand;

	public class FlashBuilderRunnerUI extends MovieClip {
		
		protected var runner:BaseRunner;
		
		public function FlashBuilderRunnerUI() {
			runner = new BaseRunner();
			runner.addEventListener(Event.COMPLETE, onRunnerComplete);
		}
		
		public function run(suite:Class, projectName:String = "", methodName:String=null):void {
			var result:IResult = new Result();
			result.addListener(new FlashBuilderPrinter(projectName));
			runner.run(suite, result, methodName, this);
		}
		
		protected function onRunnerComplete(e:Event):void {
			fscommand('quit'); // fails silently if not in debug player
			//System.exit(0); // generates SecurityError if not in debug player
		}
	}
}
