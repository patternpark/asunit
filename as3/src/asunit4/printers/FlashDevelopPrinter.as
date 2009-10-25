package asunit4.printers
{
	import flash.events.EventDispatcher;
	import flash.net.XMLSocket;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import asunit4.IFreeTestResult;
	import asunit.framework.ITestFailure;
	import flash.utils.getQualifiedClassName;
	import asunit4.ITestSuccess;
	
	public class FlashDevelopPrinter extends EventDispatcher implements IResultPrinter
	{
		protected static const localPathPattern:RegExp =
			/([A-Z]:\\[^\/:\*\?<>\|]+\.\w{2,6})|(\\{2}[^\/:\*\?<>\|]+\.\w{2,6})/g;
		
		protected static const lineNumberPattern:RegExp = /:[0-9]*\]/;
		
		protected var messageQueue:Array;
		protected var socket:XMLSocket;
		
		public function FlashDevelopPrinter() {
			messageQueue = [];
			socket = new XMLSocket();
	      	socket.addEventListener(Event.CONNECT, onConnect);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onErrorEvent);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorEvent);
   	   		socket.addEventListener(Event.CLOSE, onErrorEvent);
			connect();
		}
		
		public function startTestRun():void {
			
		}
		
		public function addTestResult(result:IFreeTestResult):void {
			var failure:ITestFailure;
			
			for each (failure in result.errors) {
				sendMessage(getFailureMessage(failure));
			}
			
			for each (failure in result.failures) {
				sendMessage(getFailureMessage(failure));
			}
			
			// Don't send successes.
		}
		
		public function endTestRun():void {
		}
		
		protected function connect(ip:String = '127.0.0.1', port:uint = 1978):void {
   	   		try {
   	   			socket.connect(ip, port);
   	   		}
			catch (e:Error) {
   	   			trace('## Error connecting to Flash Develop socket: ' + e.message);
   	   		}
		}
		
		protected function onConnect(event:Event):void {
			dispatchEvent(event);
			sendQueuedMessages();
		}
		
		protected function sendQueuedMessages():void
		{
			while (messageQueue.length) {
				sendMessage(messageQueue.shift());
			}
		}
		
		protected function sendMessage(message:String):void {
			if (!socket.connected) {
				messageQueue.push(message);
				return;
			}
			socket.send(message);
		}
		
		protected function getFailureMessage(failure:ITestFailure):String {
			var stack:String = failure.thrownException.getStackTrace();
			var lines:Array = stack.split('\n');
			var methodPattern:RegExp = new RegExp(failure.failedMethod);
			
			var lineWithMethod:String = '';
			for each (var line:String in lines) {
				if (line.match(methodPattern)) {
					lineWithMethod = line;
					break;
				}
			}
			//trace('\n' + lineWithMethod + '\n');
			
			var filePath:String = String(lineWithMethod.match(localPathPattern)[0]);
			// Find the line number between : and ], e.g. :25].
			var lineNumberRaw:String = lineWithMethod.match(lineNumberPattern)[0];
			// Take off the colon and bracket (I need to get better at regex).
			var lineNumber:String = lineNumberRaw.slice(1, -1);
			
			var message:String = filePath + '('+lineNumber+'): '
				+ (failure.failedMethod + '(): ' + failure.exceptionMessage);
				
			return message;
		}
		
		protected function onErrorEvent(event:Event):void {
			trace('onErrorEvent() - event: ' + event);
		}
		
	}
}
