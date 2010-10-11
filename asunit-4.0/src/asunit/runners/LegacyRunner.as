package asunit.runners {

	import asunit.framework.IResult;
    import asunit.framework.LegacyTestIterator;
    import asunit.framework.TestIterator;
    
    public class LegacyRunner extends TestRunner {
        
		public function LegacyRunner(result:IResult = null) {
			super(result);
		}
        
		override protected function createTestIterator(test:*, testMethodName:String):TestIterator {
            return new LegacyTestIterator(test, testMethodName);
        }
    }
}

