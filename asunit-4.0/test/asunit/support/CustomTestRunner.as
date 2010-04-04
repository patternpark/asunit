package asunit.support {

    import asunit.framework.IResult;
    import asunit.runners.TestRunner;

    import flash.display.DisplayObjectContainer;

    public class CustomTestRunner extends TestRunner {

        // Used so that test cases can 
        // verify that this custom runner
        // worked.
        public static var runCalled:Boolean;

        override public function run(suite:Class, result:IResult, testMethod:String=null, visualContext:DisplayObjectContainer=null):void {
            runCalled = true;
            super.run(suite, result, testMethod, visualContext);
        }
    }
}

