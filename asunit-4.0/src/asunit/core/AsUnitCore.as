package asunit.core {

    import asunit.framework.IResult;
    import asunit.framework.IRunListener;
    import asunit.framework.IRunner;
    import asunit.framework.Result;
    import asunit.framework.RunnerFactory;
    import asunit.framework.TestObserver;
    import asunit.runners.LegacyRunner;

    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import asunit.framework.InjectionDelegate;
    import asunit.framework.CallbackBridge;
	
	public class AsUnitCore implements IEventDispatcher {

		[Inject]
        public var bridge:CallbackBridge;

		protected var bridgeInjector:InjectionDelegate;
        protected var dispatcher:IEventDispatcher;
        protected var legacyRunnerReference:LegacyRunner;
        protected var observers:Array;
        protected var runner:IRunner;
        protected var _visualContext:DisplayObjectContainer;

        public function AsUnitCore() {
            super();
			initializeBridgeInjector();
            initializeDispatcher();
            initializeObservers();
            initialize();
        }

		protected function initializeBridgeInjector():void {
			bridgeInjector = new InjectionDelegate();
		}
		
        protected function initializeDispatcher():void {
            dispatcher = new EventDispatcher();
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
         * Add a new Observer instance to this test run. 
         *
         * The TestObserver interface is simply a marker interface
         * that indicates your observer has at least one [Inject]
         * variable where a bridge will be injected.
         *
         * Concrete observers are coupled to concrete runners
         * by using [Inject] metadata and Bridges for message passing.
         *
         * The primary TestRunner, CallbackBridge and TextPrinter
         * are good examples of how to build this relationship.
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
        public function addObserver(observer:TestObserver):void {
			bridgeInjector.updateInjectionPoints(observer, InjectionDelegate.THROW_ERROR_ON_MISSING_INJECTION_POINT);
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

			// Will instantiate a new CallbackBridge:
            // and set it on this instance - but share it
            // with any Runners or Observers that also
            // use the CallbackBridge.
			bridgeInjector.updateInjectionPoints(this, InjectionDelegate.THROW_ERROR_ON_MISSING_INJECTION_POINT);
            // Must use the accessor, not the _ value:
            if(visualContext) this.visualContext = visualContext;

            var factory:RunnerFactory = new RunnerFactory();
			factory.injector = bridgeInjector;
            runner = factory.runnerFor(testOrSuite);
			runner.addEventListener(Event.COMPLETE, runCompleteHandler);
			bridge.onRunStarted();
		    runner.run(testOrSuite, testMethodName, this.visualContext);
        }

        private function runCompleteHandler(event:Event):void {
			runner.removeEventListener(Event.COMPLETE, onRunCompleted);
			bridge.onRunCompleted(bridge);
            onRunCompleted();
            dispatchEvent(event);
        }


        /**
         * Template method that subclasses can override to perform some
         * operation when the run is complete.
         */
		protected function onRunCompleted():void {
		}

        // BEGIN: Implement the IEvent Dispatcher Interface:

		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean {
			return dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean {
			return dispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean {
			return dispatcher.willTrigger(type);
		}

        // END: Implement the IEvent Dispatcher Interface:
	}
}
