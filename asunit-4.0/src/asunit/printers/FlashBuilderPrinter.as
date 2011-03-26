package asunit.printers {
	import asunit.framework.ITestFailure;
	import asunit.framework.ITestWarning;
	import asunit.framework.IResult;
	import asunit.framework.IRunListener;
	import asunit.framework.ITestSuccess;
	import asunit.framework.Method;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.getQualifiedClassName;
    import flash.net.XMLSocket;

    /**
     * FlashBuilderPrinter should connect to the running Flash Builder test result
     * view over an XMLSocket and send it test results as they accumulate.
     */
    public class FlashBuilderPrinter extends XMLPrinter {
        
		protected var socket:XMLSocket;

		public function FlashBuilderPrinter(projectName:String = '', contextName:String = '') {
            testPrefix = null;
            testSuffix = null;
            traceResults = false;
            super(projectName, contextName);
            connectToSocket();
        }

        protected function connectToSocket():void {
			socket = new XMLSocket();
	      	socket.addEventListener(Event.CONNECT, onConnect);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onErrorEvent);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorEvent);
   	   		socket.addEventListener(Event.CLOSE, onErrorEvent);
			connect();
		}
		
		protected function onErrorEvent(event:Event):void {
			trace('FlashBuilderPrinter::onErrorEvent() - event: ' + event);
		}
		
		protected function connect(ip:String = '127.0.0.1', port:uint = 8765):void {
   	   		try {
   	   			socket.connect(ip, port);
   	   		}
			catch (e:Error) {
   	   			trace('## Error connecting to Flash Builder socket: ' + e.message);
   	   		}
		}

        override public function onRunCompleted(result:IResult):void {
            super.onRunCompleted(result);
			socket.close();
        }
		
		protected function onConnect(event:Event):void {
			sendQueuedMessages();
		}
		
		protected function sendQueuedMessages():void {
			while (messageQueue.length) {
				sendMessage(messageQueue.shift());
			}
		}
		
		override protected function sendMessage(message:String):void {
			if (!socket.connected) {
				messageQueue.push(message);
				return;
			}
			socket.send(message);
		}
    }
}
