package asunit.core {

    import asunit.printers.FlexUnitCIPrinter;

    public class FlexUnitCICore extends TextCore {

        override protected function initializeObservers():void {
            super.initializeObservers();
            addListener(new FlexUnitCIPrinter());
        }

		override protected function onRunCompleted():void {
            super.onRunCompleted();
			// The FlexUnitCIPrinter will close Flash Player when the socket acknowledges the end.
		}
    }
}
