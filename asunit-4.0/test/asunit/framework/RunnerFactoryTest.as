package asunit.framework {

	import asunit.asserts.*;
    import asunit.errors.UsageError;
    import asunit.framework.IRunner;
    import asunit.runners.TestRunner;
    import asunit.runners.SuiteRunner;
    import asunit.support.SingleSuccessSuite;
    import asunit.support.SucceedAssertTrue;

    import flash.display.Sprite;

	public class RunnerFactoryTest {

        [Inject]
        public var factory:RunnerFactory;

        [Test]
        public function shouldCreateDefaultRunner():void {
            var result:IRunner = factory.create(SucceedAssertTrue);
            assertTrue(result is TestRunner);
        }

        [Test]
        public function shouldCreateSuiteRunner():void {
            var result:IRunner = factory.create(SingleSuccessSuite);
            assertTrue(result is SuiteRunner);
        }

        [Ignore]
        [Test(expects="asunit.errors.UsageError")]
		public function shouldFailWhenGivenANonTestOrSuite():void {
            factory.create(Sprite);
		}

        [Ignore]
        [Test(expects="asunit.errors.UsageError")]
        public function runWithOnTestWithNoTypeDeclaration():void {
        }

        [Ignore]
        [Test(expects="asunit.errors.UsageError")]
        public function runWithOnSuiteWithNoTypeDeclaration():void {
        }
	}
}

