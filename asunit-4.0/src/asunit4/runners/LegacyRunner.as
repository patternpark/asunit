package asunit4.runners {

    import asunit4.framework.LegacyTestIterator;
    import asunit4.framework.TestIterator;
    
    public class LegacyRunner extends TestRunner {
        
        override protected function createTestIterator(test:*, testMethodName:String):TestIterator {
            return new LegacyTestIterator(test, testMethodName);
        }
    }
}

