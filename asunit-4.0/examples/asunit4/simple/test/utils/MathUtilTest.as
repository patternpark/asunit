package utils {
    
    import asunit.framework.IAsync;
    import asunit.asserts.*;

	public class MathUtilTest {

        private var mathUtil:MathUtil;

        [Before]
		public function setUp():void {
			mathUtil = new MathUtil();
		}

        [After]
		public function tearDown():void {
			mathUtil = null;
		}

        [Test]
		public function canBeInstantiated():void {
			assertTrue("mathUtil is MathUtil", mathUtil is MathUtil);
		}

        [Test]
		public function confirmedTestExecution():void {
			assertTrue("Confirmed Test Execution", false);
		}
	}
}
