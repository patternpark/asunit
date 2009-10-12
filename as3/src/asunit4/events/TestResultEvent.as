package asunit4.events {
	import flash.events.Event;
	import asunit.framework.ITestResult;
	/**
	 *
	 */
	public class TestResultEvent extends Event {
		public static const NAME:String = 'asunit.framework.TestResultEvent';
		public var testResult:ITestResult;
		
		public function TestResultEvent(type:String, testResult:ITestResult) {
			super(type);
			this.testResult = testResult;
		}
		
		override public function clone():Event {
			return new TestResultEvent(type, testResult);
		}
	}
}
