package asunit4.ui {
	import flash.display.MovieClip;
	import asunit4.runners.BaseRunner;
	import asunit4.printers.FlashBuilderPrinter;
	import flash.events.Event;
	import flash.system.fscommand;
	import flash.system.System;
	
	public class FlashBuilderRunnerUI extends MovieClip {
		
		protected var runner:BaseRunner;
		
		public function FlashBuilderRunnerUI() {
			runner = new BaseRunner(new FlashBuilderPrinter());
			runner.addEventListener(Event.COMPLETE, onRunnerComplete);
		}
		
		public function start(suite:Class):void {
			runner.start(suite);
		}
		
		protected function onRunnerComplete(e:Event):void {
			fscommand('quit'); // fails silently if not in debug player
			//System.exit(0); // generates SecurityError if not in debug player
		}
	}
}
