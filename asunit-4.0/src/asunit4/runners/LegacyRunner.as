package asunit4.runners {

    import asunit4.framework.TestIterator;
    
    public class LegacyRunner extends TestRunner {
        
        public function LegacyRunner() {
        } 

        override protected function createTestIterator(test:*, testMethodName:String):TestIterator {
            return new TestIterator(test, testMethodName);
        }

    }
}
