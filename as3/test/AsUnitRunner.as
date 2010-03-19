package {
    import asunit.textui.TestRunner;
    import asunit4.printers.TextPrinterTest;
    
    public class AsUnitRunner extends TestRunner {

        public function AsUnitRunner() {
            //start(AllTests, null, TestRunner.SHOW_TRACE);
            start(TextPrinterTest, null, TestRunner.SHOW_TRACE);
        }
    }
}
