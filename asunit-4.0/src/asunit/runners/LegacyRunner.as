package asunit.runners {

    import asunit.framework.LegacyTestIterator;
    import asunit.framework.TestIterator;
    
    public class LegacyRunner extends TestRunner {
        
        override protected function createTestIterator(test:*, testMethodName:String):TestIterator {
            trace(">> CREATE TEST ITERATOR from legacy!");
            return new LegacyTestIterator(test, testMethodName);
        }
    }
}

