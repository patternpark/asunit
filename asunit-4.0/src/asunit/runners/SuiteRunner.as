package asunit.runners {
	import asunit.framework.IResult;
	import asunit.framework.IRunner;
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
		/** Can be changed at runtime. */
		public static var DEFAULT_TEST_RUNNER:Class = TestRunner;
		
		protected var defaultRunner:IRunner;
		protected var suiteRunner:SuiteRunner;
		protected var testClasses:SuiteIterator;
		protected var timer:Timer;
		protected var result:IResult;
        protected var visualContext:DisplayObjectContainer;
        protected var testMethod:String;
		
		public function SuiteRunner() {
			timer = new Timer(0, 1);
		}
		
		public function run(suite:Class, result:IResult, testMethod:String=null, visualContext:DisplayObjectContainer=null):void {
			this.result = result;
            this.visualContext = visualContext;
            this.testMethod = testMethod;
            runSuite(suite, result);
        }

        protected function runSuite(suite:*, result:IResult):void {
			testClasses = new SuiteIterator(suite);
			defaultRunner = new DEFAULT_TEST_RUNNER();
			defaultRunner.addEventListener(Event.COMPLETE, onTestCompleted);
			timer.addEventListener(TimerEvent.TIMER, runNextTest);
			
			runNextTest();
		}
		
		protected function runNextTest(e:TimerEvent = null):void{
			if (!testClasses.hasNext()) {
				onSuiteCompleted();
				return;
			}
			
			var testClass:Class = testClasses.next();
            var runner:IRunner = getRunnerForTest(testClass);
            // [luke] TODO: There should be a clear search,
            // and clear failure when testMethod is provided,
            // but not found...
			runner.run(testClass, result, testMethod, visualContext);
		}

        protected function getRunnerForTest(testClass:Class):IRunner {
            var reflection:Reflection = Reflection.create(testClass);
            var runWith:ReflectionMetaData = reflection.getMetaDataByName('RunWith');
            if(runWith) {
                if(runWith.args.length == 0) {
                    throw new VerifyError("Encountered [RunWith] declaration that's missing the class argument. Try [RunWith(my.class.Name)] instead.");
                }
                var className:String = runWith.args[0];
                try {
                    var customRunner:Class = getDefinitionByName(className) as Class;
                    return new customRunner() as IRunner;
                }
                catch(e:ReferenceError) {
                    var message:String = "Encountered [RunWith] declaration but cannot instantiate the provided runner. " + className + ". ";
                    message += "Is there an actual reference to this class somewhere in your project?";
                    throw new ReferenceError(message);
                }
            }
            return defaultRunner;
        }
		
		protected function onTestCompleted(e:Event):void {
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
