package asunit.core {

    import asunit.printers.TextPrinter;

    import flash.display.DisplayObjectContainer;

    /**
     * TextCore is just a simple helper class that
     * configures the base class AsUnitCore to use the 
     * standard TextPrinter.
     *
     * The main idea is that you may want a completely
     * different text output without the default TextPrinter,
     * and if that's the case, you can go ahead and 
     * instantiate AsUnitCore and configure it however you
     * wish.
     */
    public class TextCore extends AsUnitCore {

        private var textPrinter:TextPrinter;

        override protected function initializeObservers():void {
            super.initializeObservers();

            textPrinter = new TextPrinter();
            addObserver(textPrinter);
        }

        /* Delegate some configuration to the TextPrinter */
        public function set displayPerformanceDetails(show:Boolean):void {
            textPrinter.displayPerformanceDetails = show;
        }

        public function get displayPerformanceDetails():Boolean {
            return textPrinter.displayPerformanceDetails;
        }

        public function set traceOnComplete(should:Boolean):void {
            textPrinter.traceOnComplete = should;
        }

        public function get traceOnComplete():Boolean {
            return textPrinter.traceOnComplete;
        }
        

        override public function set visualContext(context:DisplayObjectContainer):void {
            super.visualContext = context;
            // Add the TextPrinter to the Display List:
            visualContext.addChild(textPrinter);
        }
    }
}

