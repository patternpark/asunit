package asunit.core {

    import asunit.printers.FlexUnitCIPrinter;
    import asunit.printers.FlashDevelopPrinter;

    import flash.system.fscommand;

    public class FlexUnitCICore extends TextCore {

        override protected function initializeObservers():void {
            super.initializeObservers();
            addListener(new FlexUnitCIPrinter());
        }

		override protected function onRunCompleted():void {
            super.onRunCompleted();
			//fscommand('quit'); // fails silently if not in debug player
			//System.exit(0); // generates SecurityError if not in debug player
		}
    }
}

