package asunit.core {

	import asunit.printers.ColorTracePrinter;
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

        public var textPrinter:TextPrinter;

        override protected function initializeObservers():void {
            super.initializeObservers();

            textPrinter = new TextPrinter();
			textPrinter.traceOnComplete = false;
            addListener(textPrinter);

			addListener(new ColorTracePrinter());
        }

        override public function set visualContext(context:DisplayObjectContainer):void {
            super.visualContext = context;
            // Add the TextPrinter to the Display List:
            visualContext.addChild(textPrinter);
        }
    }
}

