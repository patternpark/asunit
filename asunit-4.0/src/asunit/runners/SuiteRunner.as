package asunit.runners {
	
	import asunit.framework.IResult;
	import asunit.framework.IRunner;
	import asunit.framework.IRunnerFactory;
	import asunit.framework.Result;
	import asunit.framework.RunnerFactory;
	import asunit.framework.SuiteIterator;
	import asunit.util.Iterator;
	import org.swiftsuspenders.Injector;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
    
    public class SuiteRunner extends EventDispatcher implements IRunner {

		public var result:IResult;
		
        protected var testClasses:Iterator;
        protected var timer:Timer;
        protected var visualContext:DisplayObjectContainer;
        protected var testMethod:String;
 		protected var injector:Injector;
        protected var factory:IRunnerFactory;
        
        public function SuiteRunner(factory:IRunnerFactory = null, result:IResult = null, injector:Injector = null) {
            timer = new Timer(0, 1);

			this.injector = injector ||= new Injector();
			injector.mapValue(Injector, injector);
 			this.result = result ||= new Result();
			injector.mapValue(IResult, result);
			this.factory = factory ||= injector.instantiate(RunnerFactory);
 			injector.mapValue(IRunnerFactory, factory);
		}
        
        public function run(suite:Class, testMethod:String=null, visualContext:DisplayObjectContainer=null):void {
            this.visualContext = visualContext;
            this.testMethod = testMethod;
            runSuite(suite);
        }

        protected function runSuite(suite:*):void {
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
            runner.run(testClass, testMethod, visualContext);
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

        /**
         * Template method that subclasses can override to perform some
         * operation when the run is complete.
         */
        protected function onRunCompleted():void {
        }
    }
}
