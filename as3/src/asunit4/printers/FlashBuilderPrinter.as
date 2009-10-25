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
				var xmlMessage:String = createErrorMessage(
					failure.failedMethod,
					getQualifiedClassName(failure.failedTest),
					getQualifiedClassName(failure.thrownException),
					failure.exceptionMessage,
					failure.thrownException.getStackTrace());
				//trace('******** sending failedMethod: ' + failure.failedMethod);
				sendMessage(xmlMessage);
			}
			
			for each (failure in result.failures) {
				var xmlMessage2:String = createFailureMessage(
					failure.failedMethod,
					getQualifiedClassName(failure.failedTest),
					getQualifiedClassName(failure.thrownException),
					failure.exceptionMessage,
					failure.thrownException.getStackTrace());
				//trace('******** sending failedMethod: ' + failure.failedMethod);
				sendMessage(xmlMessage2);
			}
			
			//trace('######  result.successes: ' + result.successes);
			for each (var success:ITestSuccess in result.successes) {
				var xmlMessageSuccess:String = "<testCase name='" + success.method + "' testSuite='" + getQualifiedClassName(success.test) + "' status='success'/>";
				//trace('->->->->->->->    xmlMessageSuccess: ' + xmlMessageSuccess);
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
			trace('+++++++++ sendMessage() - \n' + message + '\n');
		}
		
		protected function createFailureMessage(methodName:String, suite:String, type:String, message:String, stackTrace:String):String {
			var xml:String =
				"<testCase name='" + methodName
				+ "' testSuite='" + suite
				+ "' status='failure'>"
					+ "<failure type='" + type + "' >"
						+ "<messageInfo>" + xmlEscapeMessage(message) + "</messageInfo>"
						+ "<stackTraceInfo>" + xmlEscapeMessage(stackTrace) + "</stackTraceInfo>" +
					"</failure>"
				+ "</testCase>";

			return xml;
		}
		
		protected function createErrorMessage(methodName:String, suite:String, type:String, message:String, stackTrace:String):String {
			var xml:String =
				"<testCase name='" + methodName
				+ "' testSuite='" + suite
				+ "' status='error'>"
					+ "<failure type='" + type + "' >"
						+ "<messageInfo>" + xmlEscapeMessage(message) + "</messageInfo>"
						+ "<stackTraceInfo>" + xmlEscapeMessage(stackTrace) + "</stackTraceInfo>" +
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
