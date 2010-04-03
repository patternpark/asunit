package asunit.core {

    public class FlashBuilderCore extends TextCore {

        override protected function initializeObservers():void {
            super.initializeObservers();

            var projectName:String = 'SomeProject';
            addObserver(new FlashBuilderPrinter(projectName));
        } 
		override protected function onRunCompleted(event:Event):void {
            super.onRunCompleted(event);
			fscommand('quit'); // fails silently if not in debug player
			//System.exit(0); // generates SecurityError if not in debug player
		}
    }
}

