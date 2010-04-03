package asunit.framework {

    import asunit.framework.IRunListener;

    import flash.display.DisplayObjectContainer;
	
    /**
     * This is the centralized entry point to an AsUnit test run.
     * 
     * This class does not extend a visual entity in order to make
     * it dead-simple to integrate AsUnit with any programming, or
     * development environment.
     *
     * This includes environments such as:
     *
     * ActionScript 3, Flash Authoring, Flex Builder
     * Flex SDK, Flash Builder, FDT, Flash Develop, etc.
     *
     * The only requirement that AsUnit 4.0 has, is that you must be 
     * able to compile ActionScript 3.0 and retain metadata declarations.
     *
     * @example The following code shows how an Document Class would
     * instantiate and use the AsUnitCore class:
     *
     * <listing version="3.0">
     *   package {
     *
     *      import asunit.framework.AsUnitCore;
     *      import asunit.printers.TextPrinter;
     *
     *      import flash.display.MovieClip;
     *
     *      public class SomeProjectRunner extends MovieClip {
     *
     *          // Be sure to hold onto the reference so that 
     *          // it doesn't get garbage collected while
     *          // waiting for async test runs:
     *          private var core:AsUnitCore;
     *           
     *          public function SomeProjectRunner() {
     *              // Instantiate the Core class:
     *              core = new AsUnitCore();
     *              // Give it a DisplayObjectContainer to use
     *              // for Visual tests:
     *              // (Only necessary if you have visual tests)
     *              core.setVisualContext(this);
     *              // Add any number of TestObservers:
     *              core.addObserver(new TextPrinter());
     *
     *              // Start the test run with a Suite or Test 
     *              // class reference:
     *              start(AllTests);
     *          }
     *      }
     *  }
     * </listing>
     *
     *
	public class AsUnitCore {

        protected var visualContext:DisplayObjectContainer;
        protected var observers:Array;

        public function AsUnitCore() {
            super();
            initializeObservers();
            initialize();
        }

        protected function initializeObservers():void {
            observers = [];
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
         * by using metadata and Bridges for message passing.
         *
         * The primary TestRunner, CoreCallbackBridge and TextPrinter
         * are good examples of how to build this relationship.
         * 
         * To use a different TestRunner on a Suite or Test, simply set:
         *
         *   [RunWith("fully.qualified.ClassName")]
         * 
         * If you call RunWith on a Suite, it should change the 
         * default TestRunner for all subsequent tests.
         *
         */
        public function addObserver(observer:TestObserver):void {
            observers.push(observer);
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
        public function setVisualContext(context:DisplayObjectContainer):void {
            visualContext = context;
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
		public function start(testOrSuite:Class, testMethodName:String=null, showPerformanceSummary:Boolean=true):void {
        }
	}
}

