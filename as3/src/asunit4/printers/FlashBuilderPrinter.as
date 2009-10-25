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
	
	public class FlashBuilderPrinter extends EventDispatcher implements IResultPrinter
	{
		protected var messageQueue:Array;
		protected var socket:XMLSocket;
		
		public function FlashBuilderPrinter() {
			messageQueue = [];
			socket = new XMLSocket();
	      	socket.addEventListener(Event.CONNECT, onConnect);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onErrorEvent);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorEvent);
   	   		socket.addEventListener(Event.CLOSE, onErrorEvent);
			connect();
		}
		
		public function startTestRun():void {
			var projectName:String = 'FlexProjectSDK4';
			var contextName:String = 'SomeContext';
			sendMessage("<startTestRun totalTestCount='0' projectName='" + projectName
				+ "' contextName='" + contextName +"' />");
		}
		
		public function addTestResult(result:IFreeTestResult):void {
			var failure:ITestFailure;
			
			for each (failure in result.errors) {
				sendMessage(getFailureMessage(failure));
			}
			
			for each (failure in result.failures) {
				sendMessage(getFailureMessage(failure));
			}
			
			for each (var success:ITestSuccess in result.successes) {
				var xmlMessageSuccess:String = "<testCase name='" + success.method
					+ "' testSuite='" + getQualifiedClassName(success.test) + "' status='success'/>";
				sendMessage(xmlMessageSuccess);
			}
		}
		
		public function endTestRun():void {
			sendMessage('<endOfTestRun/>');
		}
		
		protected function connect(ip:String = '127.0.0.1', port:uint = 8765):void {
   	   		try {
   	   			socket.connect(ip, port);
   	   		}
			catch (e:Error) {
   	   			trace('## Error connecting to Flash Builder socket: ' + e.message);
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
			//trace('+++++++++ sendMessage() - \n' + message + '\n');
		}
		
		protected function getFailureMessage(failure:ITestFailure):String {
			var status:String = failure.isFailure ? 'failure' : 'error';
			var xml:String =
				"<testCase name='" + failure.failedMethod
				+ "' testSuite='" + getQualifiedClassName(failure.failedTest)
				+ "' status='" + status + "'>"
					+ "<failure type='" + getQualifiedClassName(failure.thrownException) + "' >"
						+ "<messageInfo>" + xmlEscapeMessage(failure.exceptionMessage) + "</messageInfo>"
						+ "<stackTraceInfo>" + xmlEscapeMessage(failure.thrownException.getStackTrace()) + "</stackTraceInfo>" +
					"</failure>"
				+ "</testCase>";

			return xml;
		}
		
		protected function onErrorEvent(event:Event):void {
			trace('onErrorEvent() - event: ' + event);
		}
		
		public static function xmlEscapeMessage(message:String):String {
			if (!message) return '';
			
			var escape:XML = <escape/>;
			escape.setChildren( message );
			return escape.children()[0].toXMLString();
		}
		
	}
}
