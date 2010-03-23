package asunit.framework {

	import flash.events.Event;

	public class ErrorEvent extends Event {
		public static const ERROR:String = 'error';
		protected var _error:Error;
		
		public function ErrorEvent(type:String, error:Error) {
			super(type);
			this._error = error;
		}
		
		override public function clone():Event {
			return new ErrorEvent(type, _error);
		}
		
		public function get error():Error { return _error; }
	}
}
