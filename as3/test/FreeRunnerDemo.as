package  {
	import asunit.framework.FreeRunner;
	import asunit.framework.SpriteFreeTest;
	import asunit.textui.ResultPrinter;
	/**
	 * ...
	 * @author Robert Penner
	 */
	public class FreeRunnerDemo extends FreeRunner {
		
		public function FreeRunnerDemo() {
			printer = new ResultPrinter();
			run(new SpriteFreeTest());
		}
		
	}

}