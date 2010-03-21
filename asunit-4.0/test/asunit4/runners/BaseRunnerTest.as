package asunit4.runners {

    import asunit.framework.TestCase;

    import asunit4.framework.IRunner;
    import asunit4.framework.IResult;
    import asunit4.framework.Result;
    import asunit4.runners.BaseRunner;
    import asunit4.support.TestForFakeRunner;

    public class BaseRunnerTest extends TestCase {

        public function BaseRunnerTest(method:String=null) {
            super(method);
        }

        public function testRunWith():void {
            var runner:IRunner = new BaseRunner();
            var result:IResult = new Result();
            runner.run(TestForFakeRunner, result);
            assertEquals(1, result.successCount);
        }
    }
}

