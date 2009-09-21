package asunit.framework.async {
	import asunit.framework.AsyncOperation;
	import asunit.framework.ErrorEvent;
	import flash.utils.Dictionary;
	import flash.events.Event;
	
	/**
	 *
	 */
	public class Async {
		
		private static var _instance:Async;
		
		public var operationsByTest:Dictionary;
		
		public function Async() {
			operationsByTest = new Dictionary(true);
		}
		
		public static function get instance():Async {
			if (!_instance) _instance = new Async();
			return _instance;
		}
		
		public function getOperationsForTest(test:Object):Array {
			var operations:Array = operationsByTest[test];
			// Clone to prevent changing by reference.
			return operations ? operations.concat() : null;
		}
		
		public function addAsync(test:Object, handler:Function, duration:Number):Function {
			var operation:FreeAsyncOperation = new FreeAsyncOperation(test, handler, duration);
			addOperationForTest(test, operation);
			return operation.getCallback();
		}
		
		protected function addOperationForTest(test:Object, operation:FreeAsyncOperation):void {
			if (!operationsByTest[test])
				operationsByTest[test] = [];
				
			operationsByTest[test].push(operation);
			operation.addEventListener(FreeAsyncOperation.CALLED,	onTestResult);
			operation.addEventListener(ErrorEvent.ERROR, 			onTestResult);
		}
		
		protected function onTestResult(e:Event):void {
			var operation:FreeAsyncOperation = FreeAsyncOperation(e.currentTarget);
			operation.removeEventListener(FreeAsyncOperation.CALLED,	onTestResult);
			operation.removeEventListener(ErrorEvent.ERROR,				onTestResult);
			
			removeOperationForTest(operation.scope, operation);
		}
		
		public function removeOperationForTest(test:Object, operation:FreeAsyncOperation):void {
			var operations:Array = operationsByTest[test];
			if (!operations) return;
			
			operations.splice(operations.indexOf(operation), 1);
			// Remove the array when emptied.
			if (!operations.length)
				delete operationsByTest[test];
			//TODO: maybe dispatch event when the last operation is removed
		}
		
	}
	
}