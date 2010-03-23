package asunit.runners {

    import asunit.framework.TestCase;

    import asunit.framework.IRunner;
    import asunit.framework.IResult;
    import asunit.framework.Result;
    import asunit.runners.BaseRunner;
    import asunit.support.TestForFakeRunner;
    import asunit.support.MultiMethod;

    public class BaseRunnerTest extends TestCase {

        public function BaseRunnerTest(method:String=null) {
            super(method);
        }

        override protected function setUp():void {
            super.setUp();
            MultiMethod.methodsCalled = [];
        }

        public function testRunWith():void {
            var runner:IRunner = new BaseRunner();
            var result:IResult = new Result();
            runner.run(TestForFakeRunner, result);
            assertEquals(1, result.successCount);
        }

        public function testCustomMethod():void {
            var runner:IRunner = new BaseRunner();
            var result:IResult = new Result();
            runner.run(MultiMethod, result, "stage_is_null_by_default");
            assertEquals(1, result.successCount);
            assertEquals(5, MultiMethod.methodsCalled.length);
        }
    }
}

