package asunit.core {
	
	import asunit.framework.IResult;
	import asunit.framework.IRunnerFactory;
	import asunit.framework.Result;
	import asunit.framework.IRunner;
	import asunit.framework.RunnerFactory;
	import asunit.framework.IRunListener;
	import asunit.runners.LegacyRunner;
	import org.swiftsuspenders.Injector;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class AsUnitCore extends EventDispatcher {

        internal var result:IResult;

		protected var injector:Injector;
        protected var legacyRunnerReference:LegacyRunner;
        protected var runner:IRunner;
        protected var _visualContext:DisplayObjectContainer;

        public function AsUnitCore() {
            super();
			initializeInjector();
            initializeObservers();
            initialize();
        }

		protected function initializeInjector():void {
			injector = new Injector();
			injector.mapValue(Injector, injector);
			injector.mapClass(IRunnerFactory, RunnerFactory);
 			result = new Result();
			injector.mapValue(IResult, result);
		}

        /**
         * Template method for subclasses to override,
         * and use to create default observers.
         */
        protected function initializeObservers():void {
        }

        /**
         * A template method that concrete sub classes
         * can override to auto-configure their own
         * observers or other settings before start
         * is called.
         */
        protected function initialize():void {
        }

        /**
         * Add a listener to this test run. 
         *
         * To use a different TestRunner on a Suite or Test, simply set:
         *
         *   [RunWith("fully.qualified.ClassName")]
         * 
         * If you call RunWith on a Suite, it should change the 
         * default TestRunner for all subsequent tests.
         *
         * A Printer can inject any number of concrete Bridges,
         * so you can still subscribe to the standard test execution
         * callbacks, while also handling some new functionality
         * provided by a couple of concrete runners.
         *
         */
        public function addListener(listener:IRunListener):void {
			result.addListener(listener);
		}

        /**
         * Set the visual context that will parent all injected
         * visual entities.
         *
         * This DisplayObjectContainer should be provided and
         * attached to the Display List before start is called if
         * you have any tests that [Inject] DisplayObject instances.
         * 
         */
        public function set visualContext(context:DisplayObjectContainer):void {
            _visualContext = context;
        }

        public function get visualContext():DisplayObjectContainer {
            return _visualContext;
        }

        /**
         * Start the test run using the provided Test or Suite class and 
         * optional test method name (String).
         *
         * If a test method name is provided, all [BeforeClass], and [Before]
         * methods will be called, then the test method will be called,
         * but no [After] or [AfterClass] methods will be called.
         *
         * This gives you the ability to see visual entities in isolation
         * while test-driving their development.
         */
		public function start(testOrSuite:Class, testMethodName:String=null, visualContext:DisplayObjectContainer=null):void {

			// Must use the accessor, not the _ value:
			if(visualContext) this.visualContext = visualContext;

			var factory:IRunnerFactory = injector.getInstance(IRunnerFactory);
			runner = factory.runnerFor(testOrSuite);
			runner.addEventListener(Event.COMPLETE, onRunnerComplete);
			result.onRunStarted();
			runner.run(testOrSuite, testMethodName, this.visualContext);
		}

        protected function onRunnerComplete(event:Event):void {
			runner.removeEventListener(Event.COMPLETE, onRunCompleted);
			result.onRunCompleted(result);
			onRunCompleted();
            dispatchEvent(event);
        }
		
         /**
         * Subclasses can override to perform some
         * operation when the run is complete.
         */
		protected function onRunCompleted():void {
			
		}
	}
}
