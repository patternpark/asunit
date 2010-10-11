package asunit.support {

    import asunit.framework.CallbackBridge;
    import asunit.framework.IResult;
	import asunit.framework.IRunnerFactory;
	import asunit.runners.SuiteRunner;

    import flash.display.DisplayObjectContainer;

    public class CustomSuiteRunner extends SuiteRunner {

        // Used so that test cases can 
        // verify that this custom runner
        // worked.
        public static var runCalledCount:int;
		
		public function CustomSuiteRunner(factory:IRunnerFactory = null) {
			super(factory);
		}

        override public function run(testClass:Class, testMethod:String=null, visualContext:DisplayObjectContainer=null):void {
            runCalledCount++;
            super.run(testClass, testMethod, visualContext);
        }
    }
}

