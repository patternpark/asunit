package asunit.framework.async {
	import flash.utils.Dictionary;
	
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
			var operations:Array = operationsByTest[test]
			return operations ? operations.concat() : null; // clone to prevent changing
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
		}
		
		public function removeOperationForTest(test:Object, operation:FreeAsyncOperation):void {
			var operations:Array = operationsByTest[test];
			if (!operations) return;
			operations.splice(operations.indexOf(operation), 1);
			//TODO: maybe dispatch event when the last operation is removed
		}
		
	}
	
}