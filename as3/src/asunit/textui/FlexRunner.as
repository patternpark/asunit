package asunit.textui {
    import asunit.framework.TestResult;
    
    import mx.core.Application;
    
    /**
    *   This is the base class that should be used to test Flex applications.
    *   
    *   @example The <code>FlexTestRunner</code> should be the base class for your 
    *   test harness.
    *   
    *   @includeExample examples/FlexRunnerExample.mxml
    **/
    public class FlexRunner extends Application {
        protected var runner:TestRunner;

        override protected function createChildren():void {
            super.createChildren();
            runner = new FlexTestRunner();
            rawChildren.addChild(runner);
        }
        
        public function start(testCase:Class, testMethod:String = null, showTrace:Boolean = false):TestResult {
            return runner.start(testCase, testMethod, showTrace);
        }
    }
}
