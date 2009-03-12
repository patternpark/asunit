package asunit.framework {
	import asunit.errors.AbstractError;
	
	import flash.errors.IllegalOperationError;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.utils.getTimer;

	/**
	 * Extend this class if you have a TestCase that requires the
	 * asynchronous load of external data.
	 */
	public class AsynchronousTestCase extends TestCase {

		protected static const DEFAULT_NETWORK_TIMEOUT:int = 30000;
		private static const INVALID_TIME:int = -1;
		
		private var _networkStartTime:int;
		
		private var _networkDuration:int;
		public function get networkDuration():int
		{
			return _networkDuration;
		}
		
		private var _networkTimeout:int;
		// see testNetworkDuration() below
		public function set networkTimeout(ms:int):void
		{
			_networkTimeout = ms;
		}

		private var _ioErrorExpected:Boolean;
		public function set ioErrorExpected(yn:Boolean):void
		{
			_ioErrorExpected = yn;
		}
		
		private var _securityErrorExpected:Boolean;
		public function set securityErrorExpected(yn:Boolean):void
		{
			_securityErrorExpected = yn;
		}
		
		public function AsynchronousTestCase(testMethod:String = null) {
			super(testMethod);
			_networkStartTime = INVALID_TIME;
			
			// set defaults for user-configurable properties:
			_networkTimeout = DEFAULT_NETWORK_TIMEOUT;
			_ioErrorExpected = false;
			_securityErrorExpected = false;
		}

		protected function configureListeners(loader:URLLoader):void {
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.addEventListener(Event.OPEN, openHandler);
			loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}

		// override this method and call super.run() at the end
		public override function run():void {
			throw new AbstractError("run() method must be overridden in class derived from AsynchronousTestCase");
			
			startNetworkDuration();
		}

		private final function startNetworkDuration():void {
			_networkStartTime = getTimer();
		}

		private final function setNetworkDuration():void {
			if (_networkStartTime == INVALID_TIME)
			{
				// I guess you overrode run() in a subclass without calling super.run()
				_networkDuration = INVALID_TIME;
			}
			else
			{
				_networkDuration = getTimer() - _networkStartTime;
			}
		}

		protected final function completeHandler(event:Event):void {
			setNetworkDuration();
			setDataSource(event);
			// call super.run() to execute test methods
			runTests();
		}
		
		// override this method to put a copy of the data into a member reference
		protected function setDataSource(event:Event):void {
			//throw new AbstractError("setDataSource", this);
		}

		protected final function runTests():void {
			super.run();
		}
		
		// TODO: add support for failing status events...
		protected function httpStatusHandler(event:HTTPStatusEvent):void {
		}

		protected final function ioErrorHandler(event:IOErrorEvent):void {
			if (_ioErrorExpected == false)
			{
				// access is authorized and we didn't get in: log the error
				result.addError(this, new IllegalOperationError(event.text));
			}
			setDataSource(null);
			runTests();
		}

		protected function openHandler(event:Event):void {
		}

		protected function progressHandler(event:ProgressEvent):void {
		}

		protected final function securityErrorHandler(event:SecurityErrorEvent):void {
			if (_securityErrorExpected == false)
			{
				// access is authorized and we didn't get in: log the error
				result.addError(this, new IllegalOperationError(event.toString()));
			}
			setDataSource(null);
			runTests();
		}

		public function testNetworkDuration():void {
			if (_networkDuration > _networkTimeout)
			{
				fail("network communication took too long: " + _networkDuration/1000 + " seconds.\n" + this.toString());
			}
		}

		public function testUnauthorizedAccess():void {
			if (_securityErrorExpected == true)
			{
				fail("unauthorized access permitted (expected no access)\n" + this.toString());
			}
		}
		
	}
}