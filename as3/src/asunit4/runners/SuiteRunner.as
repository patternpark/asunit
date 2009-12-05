package asunit4.runners 
{
	import asunit4.framework.IResult;
	import asunit4.framework.Result;
	import asunit4.framework.SuiteIterator;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class SuiteRunner extends EventDispatcher {
		protected var testRunner:TestRunner;
		protected var suiteRunner:SuiteRunner;
		protected var testClasses:SuiteIterator;
		protected var timer:Timer;
		protected var result:IResult;
		
		public function SuiteRunner() {
			timer = new Timer(0, 1);
			timer.addEventListener(TimerEvent.TIMER, runNextTest);
		}
		
		public function run(suite:Class, result:IResult = null):void {
			this.result = result || new Result();
			testRunner = new TestRunner();
			testRunner.addEventListener(Event.COMPLETE, onTestCompleted);
			testClasses = new SuiteIterator(suite);
			
			runNextTest();
		}
		
		protected function runNextTest(e:TimerEvent = null):void{
			if (!testClasses.hasNext()) {
				onSuiteCompleted();
				return;
			}
			
			var testClass:Class = testClasses.next();
			testRunner.run(new testClass(), result);
		}
		
		protected function onTestCompleted(e:Event):void {
			// Start a new green thread.
			timer.reset();
			timer.start();
		}
		
		protected function onSuiteCompleted():void {
			dispatchEvent(new Event(Event.COMPLETE));
		}
				
	}
}
