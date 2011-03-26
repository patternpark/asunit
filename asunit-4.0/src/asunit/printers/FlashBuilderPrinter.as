package asunit.printers {

    import asunit.errors.AssertionFailedError;
    import asunit.framework.Test;
    import asunit.framework.TestListener;
    import asunit.framework.TestResult;
    import flash.events.EventDispatcher;
	import flash.net.XMLSocket;
    import flash.utils.setTimeout;
    import flash.utils.Dictionary;
    
    /**
     * FlashBuilderPrinter should connect to the running Flash Builder test result
     * view over an XMLSocket and send it test results as they accumulate.
     */
    public class FlashBuilderPrinter extends XMLResultPrinter {
        
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
		
		protected function sendMessage(message:String):void {
			if (!socket.connected) {
				messageQueue.push(message);
				return;
			}
			socket.send(message);
		}
    }
}
