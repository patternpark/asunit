package asunit4.runners {
	import asunit4.framework.IResult;
	import asunit4.framework.IRunner;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class BaseRunner extends EventDispatcher implements IRunner {
		protected var suiteRunner:SuiteRunner;
		protected var result:IResult;
		
		public function BaseRunner() {
			suiteRunner = new SuiteRunner();
		}
		
		public function run(suite:Class, result:IResult):void {
			this.result = result;
			suiteRunner.addEventListener(Event.COMPLETE, onSuiteCompleted);
			result.onRunStarted();
			suiteRunner.run(suite, result);
		}
		
		protected function onSuiteCompleted(e:Event):void {
			suiteRunner.removeEventListener(Event.COMPLETE, onSuiteCompleted);
			result.onRunCompleted(result);
			dispatchEvent(e);
		}
	}
}
