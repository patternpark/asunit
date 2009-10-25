package asunit4
{
	import flash.events.EventDispatcher;
	import flash.net.XMLSocket;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import asunit4.IFreeTestResult;
	import asunit.framework.ITestFailure;
	import flash.utils.getQualifiedClassName;
	
	public class FlashBuilderPrinter extends EventDispatcher
	{
		protected var socket:XMLSocket;
		//protected var ip:String = "127.0.0.1";
		//protected var port:uint = 8765;
		
		public function FlashBuilderPrinter()
		{
			socket = new XMLSocket();
	      	socket.addEventListener(Event.CONNECT, onConnect);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onErrorEvent);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorEvent);
   	   		socket.addEventListener(Event.CLOSE, onErrorEvent);
		}
		
		public function connect(ip:String = '127.0.0.1', port:uint = 8765):void
		{
   	   		try
   	   		{
   	   			socket.connect(ip, port);
   	   		}
			catch (e:Error)
			{
   	   			trace('## Error connecting to socket: ' + e.message);
   	   		}
		}
		
		public function startTestRun():void {
			var projectName:String = 'FlexProjectSDK4';
			var contextName:String = 'SomeContext';
			sendMessage("<startTestRun totalTestCount='0' projectName='" + projectName + "' contextName='" + contextName +"' />");
		}
		
		public function addTestResult(result:IFreeTestResult):void
		{
			if (!socket.connected) return;
			
			for each (var failure:ITestFailure in result.failures) {
				var xmlMessage:String = createFailureMessage(
					failure.failedMethod,
					getQualifiedClassName(failure.failedTest),
					getQualifiedClassName(failure.thrownException),
					failure.exceptionMessage,
					failure.thrownException.getStackTrace());
				//trace('******** sending failedMethod: ' + failure.failedMethod);
				sendMessage(xmlMessage);
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
		
		protected function sendMessage(message:String):void {
			if (!socket.connected) return;
			socket.send(message);
			//trace('sendMessage() - ' + message);
		}
		
		protected function createFailureMessage( methodName:String, suite:String, type:String, message:String, stackTrace:String ):String {
			var xml : String =
				"<testCase name='"+methodName+"' testSuite='"+suite+"' status='failure'>"+
				"<failure type='"+ type +"' >"+
				"<messageInfo>"+xmlEscapeMessage(message)+ "</messageInfo>"+
				"<stackTraceInfo>" +xmlEscapeMessage(stackTrace)+ "</stackTraceInfo>"+
				"</failure>"+
				"</testCase>";

			return xml;
		}
		
		protected function onConnect(event:Event):void
		{
			dispatchEvent(event);
		}
		
		protected function onErrorEvent(event:Event):void
		{
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
