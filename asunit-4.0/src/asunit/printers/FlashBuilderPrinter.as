package asunit.printers {
	import asunit.framework.ITestFailure;
	import asunit.framework.ITestWarning;

	import asunit.framework.IResult;
	import asunit.framework.IRunListener;
	import asunit.framework.ITestSuccess;
	import asunit.framework.Method;
	import asunit.framework.TestObserver;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.XMLSocket;
	import flash.utils.getQualifiedClassName;

	public class FlashBuilderPrinter implements IRunListener, TestObserver {
		protected var projectName:String;
		protected var contextName:String;
		protected var messageQueue:Array;
		protected var socket:XMLSocket;
		
		public function FlashBuilderPrinter(projectName:String = '', contextName:String = '') {
			this.projectName = projectName;
			this.contextName = contextName;
			messageQueue = [];
			socket = new XMLSocket();
	      	socket.addEventListener(Event.CONNECT, onConnect);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onErrorEvent);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorEvent);
   	   		socket.addEventListener(Event.CLOSE, onErrorEvent);
			connect();
		}
		
		public function onRunStarted():void {
			sendMessage("<startTestRun totalTestCount='0' projectName='" + projectName
				+ "' contextName='" + contextName +"' />");
		}
		
		public function onTestStarted(test:Object):void {
		}
		
		public function onTestCompleted(test:Object):void {
        }
		
		// works for both errors and failures
		public function onTestFailure(failure:ITestFailure):void {
			sendMessage(getFailureMessage(failure));
		}
		
		public function onTestSuccess(success:ITestSuccess):void {
			var xmlMessageSuccess:String = "<testCase name='" + success.method
				+ "' testSuite='" + getQualifiedClassName(success.test) + "' status='success'/>";
			sendMessage(xmlMessageSuccess);
		}
		
		public function onTestIgnored(method:Method):void {
			var xmlMessageIgnore:String = "<testCase name='" + method.name
				+ "' testSuite='" + getQualifiedClassName(method.scope) + "' status='ignore'/>";
			sendMessage(xmlMessageIgnore);
		}
		
		public function onWarning(warning:ITestWarning):void {
			//TODO: is there any way to send a warning to Flash Builder?
		}
		
		public function onRunCompleted(result:IResult):void {
			sendMessage('<endOfTestRun/>');
			socket.close();
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
			sendQueuedMessages();
		}
		
		protected function sendQueuedMessages():void {
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
					
						+ "<messageInfo>" + xmlEscapeMessage(failure.exceptionMessage)
						+ "</messageInfo>"
						
						+ "<stackTraceInfo>" + xmlEscapeMessage(failure.thrownException.getStackTrace())
						+ "</stackTraceInfo>"
						
					+ "</failure>"
				+ "</testCase>";

			return xml;
		}
		
		protected function onErrorEvent(event:Event):void {
			trace('FlashBuilderPrinter::onErrorEvent() - event: ' + event);
			//throw new Error('FlashBuilderPrinter::onErrorEvent() - event: ' + event);
		}
		
		protected static function xmlEscapeMessage(message:String):String {
			if (!message) return '';
			
			var escape:XML = <escape/>;
			escape.setChildren( message );
			return escape.children()[0].toXMLString();
		}
		
	}
}
