package asunit.framework {
	import flash.events.Event;
	
	/**
	 *
	 */
	public class TestResultEvent extends Event {
		public static const NAME:String = 'asunit.framework.TestResultEvent';
		public var testResult:FreeTestResult;
		
		public function TestResultEvent(type:String, testResult:FreeTestResult) {
			super(type);
			this.testResult = testResult;
		}
		
		override public function clone():Event {
			return new TestResultEvent(type, testResult);
		}
	}
}