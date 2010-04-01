package asunit.runners {

    import asunit.asserts.*;
    import asunit.framework.IResult;
    import asunit.framework.IRunner;
    import asunit.framework.Result;
    import asunit.runners.BaseRunner;
    import asunit.support.MultiMethod;
    import asunit.support.SucceedAssertTrue;
    import asunit.support.TestForFakeRunner;

    public class BaseRunnerTest {

        private var runner:IRunner;
        private var result:IResult;

        [Before]
        public function createRunnerAndResult():void {
            runner = new BaseRunner();
            result = new Result();
        }

        [After]
        public function cleanUpMultiMethod():void {
            MultiMethod.methodsCalled = [];
        }

        [After]
        public function cleanUpRunnerAndResult():void {
            runner = null;
            result = null;
        }

        private function run(test:Class, methodName:String=null):void {
            runner.run(test, result, methodName);
        }

        [Test]
        public function respectRunWith():void {
            run(TestForFakeRunner);
            assertEquals(1, result.successCount);
        }

        [Test]
        public function provideCustomMethod():void {
            run(MultiMethod, "stage_is_null_by_default");
            assertEquals(1, result.successCount);
            assertEquals(5, MultiMethod.methodsCalled.length);
        }

        [Test(expects="asunit.errors.UsageError")]
        public function providedCustomMethodNotFound():void {
            run(SucceedAssertTrue, "unknownMethod");
        }
    }
}

