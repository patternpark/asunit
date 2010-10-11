package asunit.framework {

	import asunit.asserts.*;
    import asunit.errors.UsageError;
    import asunit.framework.IRunner;
    import asunit.runners.TestRunner;
    import asunit.runners.SuiteRunner;
    import asunit.support.RunWithButNoType;
    import asunit.support.RunWithSuiteButNoType;
    import asunit.support.SingleSuccessSuite;
    import asunit.support.SucceedAssertTrue;

    import flash.display.Sprite;

	public class RunnerFactoryTest {

        [Inject]
        public var factory:RunnerFactory;

        [Test]
        public function shouldCreateDefaultRunner():void {
            var result:IRunner = factory.runnerFor(SucceedAssertTrue);
            assertTrue(result is TestRunner);
        }

        [Test]
        public function shouldCreateSuiteRunner():void {
            var result:IRunner = factory.runnerFor(SingleSuccessSuite);
            assertTrue(result is SuiteRunner);
        }

        [Test(expects="asunit.errors.UsageError")]
		public function shouldFailWhenGivenANonTestOrSuite():void {
            factory.runnerFor(Sprite);
		}

        [Test(expects="asunit.errors.UsageError")]
        public function runWithOnTestWithNoTypeDeclaration():void {
            factory.runnerFor(RunWithButNoType);
        }

        [Test(expects="asunit.errors.UsageError")]
        public function runWithOnSuiteWithNoTypeDeclaration():void {
            factory.runnerFor(RunWithSuiteButNoType);
        }
	}
}

