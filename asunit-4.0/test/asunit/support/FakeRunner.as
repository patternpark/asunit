package asunit.support {

    import asunit.framework.IRunner;
    import asunit.framework.IResult;
    import asunit.framework.TestSuccess;
    import asunit.framework.IRunnerFactory;

    import flash.events.EventDispatcher;
    import flash.display.DisplayObjectContainer;

    public class FakeRunner extends EventDispatcher implements IRunner {

		public function run(testOrSuite:Class, result:IResult, testMethod:String=null, visualContext:DisplayObjectContainer=null):void {
            var currentTest:TestForFakeRunner = new testOrSuite() as TestForFakeRunner;

            result.onTestStarted(currentTest);
            result.onTestSuccess(new TestSuccess(currentTest, 'customTestMethod'));
            result.onTestCompleted(currentTest);
        }

        public function set factory(factory:IRunnerFactory):void {
        }

        public function get factory():IRunnerFactory {
        }
    }
}

