package asunit.framework {
    import asunit.errors.AssertionFailedError;

    public interface TestListener {

        /**
         * Run the provided Test.
         */
        function run(test:Object):void;
        /**
         * A test started.
         */
        function startTest(test:Object):void;
        /**
         * A test method has begun execution.
         */
        function startTestMethod(test:Object, methodName:String):void;
        /**
         * A test method has completed.
         */
        function endTestMethod(test:Object, methodName:String):void;
        /**
         * A test ended.
         */
         function endTest(test:Object):void;
		
		function addFailure(failure:ITestFailure):void;
		
		
		
    }
}