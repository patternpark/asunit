package asunit4.events {
	import flash.events.Event;
	import asunit4.IFreeTestResult;
	/**
	 *
	 */
	public class TestResultEvent extends Event {
		public static const TEST_COMPLETED:String = 'asunit4.events.TestResultEvent.TEST_COMPLETED';
		public static const SUITE_COMPLETED:String = 'asunit4.events.TestResultEvent.SUITE_COMPLETED';
		
		public var testResult:IFreeTestResult;
		
		public function TestResultEvent(type:String, testResult:IFreeTestResult) {
			super(type);
			this.testResult = testResult;
		}
		
		override public function clone():Event {
			return new TestResultEvent(type, testResult);
		}
	}
}
