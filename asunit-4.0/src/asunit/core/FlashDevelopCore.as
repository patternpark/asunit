package asunit.core {

    import asunit.printers.FlashDevelopPrinter;

    import flash.system.fscommand;

    public class FlashDevelopCore extends TextCore {

        override protected function initializeObservers():void {
            super.initializeObservers();
            addObserver(new FlashDevelopPrinter());
        }

		override protected function onRunCompleted():void {
            super.onRunCompleted();
			fscommand('quit'); // fails silently if not in debug player
			//System.exit(0); // generates SecurityError if not in debug player
		}
    }
}

