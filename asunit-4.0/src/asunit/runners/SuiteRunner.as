package asunit.runners {
    
	import asunit.framework.IResult;
	import asunit.framework.IRunner;
	import asunit.framework.RunnerFactory;
    import asunit.util.Iterator;
	import asunit.framework.SuiteIterator;

    import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
    import flash.utils.getDefinitionByName;

    import p2.reflect.Reflection;
    import p2.reflect.ReflectionMetaData;

	public class SuiteRunner extends EventDispatcher implements IRunner {
		
        protected var factory:RunnerFactory;
		protected var testClasses:Iterator;
		protected var timer:Timer;
		protected var result:IResult;
        protected var visualContext:DisplayObjectContainer;
        protected var testMethod:String;
		
		public function SuiteRunner() {
			timer = new Timer(0, 1);
            factory = new RunnerFactory();
		}
		
		public function run(suite:Class, result:IResult, testMethod:String=null, visualContext:DisplayObjectContainer=null):void {
			this.result = result;
            this.visualContext = visualContext;
            this.testMethod = testMethod;
            runSuite(suite, result);
        }

        protected function runSuite(suite:*, result:IResult):void {
			testClasses = new SuiteIterator(suite);
			timer.addEventListener(TimerEvent.TIMER, runNextTest);
			
			runNextTest();
		}
		
		protected function runNextTest(e:TimerEvent = null):void{
			if (!testClasses.hasNext()) {
				onSuiteCompleted();
				return;
			}
			
			var testClass:Class = testClasses.next();
            // [luke] TODO: This runnerFor call can throw exceptions,
            // we need to handle them in some way.
            var runner:IRunner = factory.runnerFor(testClass);
			runner.addEventListener(Event.COMPLETE, onTestCompleted);
            // [luke] TODO: There should be a clear search,
            // and clear failure when testMethod is provided,
            // but not found...
			runner.run(testClass, result, testMethod, visualContext);
		}
		
		protected function onTestCompleted(e:Event):void {
            e.target.removeEventListener(Event.COMPLETE, onTestCompleted);
			// Start a new green thread.
			timer.reset();
			timer.start();
		}
		
		protected function onSuiteCompleted():void {
			timer.removeEventListener(TimerEvent.TIMER, runNextTest);
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
