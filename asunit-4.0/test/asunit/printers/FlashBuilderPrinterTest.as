
package asunit.printers {
    
    import asunit.asserts.*;
    import asunit.framework.TestCase;

    public class FlashBuilderPrinterTest extends TestCase {

        public function FlashBuilderPrinterTest(method:String=null) {
            super(method);
        }

        private function testInstantiable():void {
            var printer:FlashBuilderPrinter = new FlashBuilderPrinter();
        }
    }
}

