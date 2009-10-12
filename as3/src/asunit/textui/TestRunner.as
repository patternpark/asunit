package asunit.textui {
    import asunit.framework.Test;
    import asunit.framework.TestResult;
    import asunit.framework.ITestResult;
	import asunit.runner.ITestRunner;

    import flash.display.MovieClip;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.system.fscommand;
    import flash.utils.getTimer;
    import flash.display.DisplayObject;

    /**
    *   The base class for ActionScript 3.0 test harness.
    *
    *   The <code>TestRunner</code> should be extended by your
    *   concrete runner for your project.
    *
    *   If you're building a Flex application, you will need to
    *   extend the <code>FlexRunner</code>
    *
    *   Your concrete runner will usually look like the following:
    *   <listing>
    *   package {
    *       import asunit.textui.TestRunner;
    *
    *       public class MyProjectRunner extends TestRunner {
    *
    *           public function MyProjectRunner() {
    *               // start(clazz:Class, methodName:String, showTrace:Boolean)
    *               // NOTE: sending a particular class and method name will
    *               // execute setUp(), the method and NOT tearDown.
    *               // This allows you to get visual confirmation while developing
    *               // visual entities
    *               start(AllTests, null, TestRunner.SHOW_TRACE);
    *           }
    *       }
    *   }
    *   </listing>
    *
    *   @includeExample TestRunnerExample.as
    *
    *   @see asunit.textui.FlexRunner
    *   @see asunit.textui.AirRunner
    *   @see asunit.textui.XMLResultPrinter
    **/
    public class TestRunner extends MovieClip implements ITestRunner {
        public static const SUCCESS_EXIT:int   = 0;
        public static const FAILURE_EXIT:int   = 1;
        public static const EXCEPTION_EXIT:int = 2;
        public static const SHOW_TRACE:Boolean = true;
        protected var _printer:ResultPrinter;
        protected var startTime:Number;
        protected var result:ITestResult;

        public function TestRunner() {
            configureListeners();
        }

        private function configureListeners():void {
            addEventListener(Event.ADDED_TO_STAGE, addedHandler);
            addEventListener(Event.ADDED, addedHandler);
        }

        protected function addedHandler(event:Event):void {
            if (!stage)
            {
                return;
            }
            if(event.target === _printer) {
                stage.align = StageAlign.TOP_LEFT;
                stage.scaleMode = StageScaleMode.NO_SCALE;
                stage.addEventListener(Event.RESIZE, resizeHandler);
                resizeHandler(new Event("resize"));
            }
        }

        private function resizeHandler(event:Event):void {
            _printer.width = stage.stageWidth;
            _printer.height = stage.stageHeight;
        }

        /**
         *  Starts a test run based on the <code>TestCase</code> or <code>TestSuite</code> provided.
         *
         *  If a concrete <code>TestCase</code> is provided to the <code>start</code> method,
         *  you can also provide the string name of a single test method to execute.
         *
         *  This will run the <code>TestCase</code> <code>setUp</code> method, then
         *  the test method name that was provided, and will <em>not</em> run <code>tearDown</code>.
         *
         *  This is a great way to build visual components in isolation and verify that they
         *  behave as expected.
         *
         *  @example The start method can accept a concrete test case and test method name:
         *  <listing>
         *  start(MyTestCase, 'myTestMethod');
         *  </listing>
         *
         *  @example The start method usually accepts a test suite that includes all of your
         *  test methods.
         *  <listing>
         *  start(AllTests, null, TestRunner.SHOW_TRACE);
         *  </listing>
         *
         *  @see TestSuite
         */
        public function start(testCase:Class, testMethod:String = null, showTrace:Boolean = false):ITestResult {
//            fscommand("showmenu", "false");
            try {
                var instance:Test;
                if(testMethod != null) {
                    instance = new testCase(testMethod);
                }
                else {
                    instance = new testCase();
                }
                return doRun(instance, showTrace);
            }
            catch(e:Error) {
                throw new Error("Could not create and run test suite: " + e.getStackTrace());
            }
            return null;
        }

        public function doRun(test:Object, showTrace:Boolean = false):ITestResult {

            result = new TestResult();

            if (test.getIsComplete())
                return result;

            if(_printer == null) {
                printer = new ResultPrinter(showTrace);
            }
            else {
                _printer.setShowTrace(showTrace);
            }
			
            result.addListener(printer);
            startTime = getTimer();
            test.setResult(result);
            test.setContext(this);
            test.addEventListener(Event.COMPLETE, testCompleteHandler);
            test.run();
            return result;
        }

        private function testCompleteHandler(event:Event):void {
            var endTime:Number = getTimer();
            var runTime:Number = endTime - startTime;
            printer.printResult(result, runTime);
        }

        public function set printer(printer:ResultPrinter):void {
            if(_printer is DisplayObject && getChildIndex(_printer)) {
                removeChild(_printer);
            }

            _printer = printer;
            if(_printer is DisplayObject) {
                addChild(_printer);
            }
        }

        public function get printer():ResultPrinter {
            return _printer;
        }
    }
}
