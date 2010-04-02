package asunit.runners {

	import asunit.framework.IResult;
	import asunit.framework.IRunner;

	import flash.events.Event;
	import flash.events.EventDispatcher;
    import flash.display.DisplayObjectContainer;

	public class BaseRunner extends EventDispatcher implements IRunner {
		protected var suiteRunner:SuiteRunner;
		protected var result:IResult;
		
		public function BaseRunner() {
			suiteRunner = new SuiteRunner();
		}
		
		public function run(testOrSuite:Class, result:IResult, testMethod:String=null, visualContext:DisplayObjectContainer=null):void {
			this.result = result;
			suiteRunner.addEventListener(Event.COMPLETE, onSuiteCompleted);
			result.onRunStarted();
			suiteRunner.run(testOrSuite, result, testMethod, visualContext);
		}
		
		protected function onSuiteCompleted(e:Event):void {
			suiteRunner.removeEventListener(Event.COMPLETE, onSuiteCompleted);
			result.onRunCompleted(result);
			dispatchEvent(e);
		}
	}
}

