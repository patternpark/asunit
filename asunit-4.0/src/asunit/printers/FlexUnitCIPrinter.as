package asunit.printers {

    import asunit.framework.IResult;
    import asunit.framework.IRunListener;
    import asunit.framework.ITestFailure;
    import asunit.framework.ITestSuccess;
    import asunit.framework.ITestWarning;
    import asunit.framework.Method;

    import flash.events.DataEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.TimerEvent;
    import flash.net.XMLSocket;
    import flash.system.fscommand;
    import flash.utils.Timer;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getTimer;    

    public class FlexUnitCIPrinter extends EventDispatcher implements IRunListener
    {
        protected static const DEFAULT_PORT: uint = 1024;
        protected static const DEFAULT_SERVER: String = "127.0.0.1";
        private static const SUCCESS: String = "success";
        private static const ERROR: String = "error";
        private static const FAILURE: String = "failure";
        private static const IGNORE: String = "ignore";

        private var messageQueue: Array = [];

        private var _ready: Boolean = false;

        private static const END_OF_TEST_ACK: String ="<endOfTestRunAck/>";
        private static const END_OF_TEST_RUN: String = "<endOfTestRun/>";
        private static const START_OF_TEST_RUN_ACK: String = "<startOfTestRunAck/>";

        private var socket: XMLSocket;

        public var port: uint;

        public var server: String; //this is local host. same machine

        private var timeOut: Timer;
        private var lastTestTime: Number = 0;
        private var startTime: Number;

        /**
         *
         */
        public function FlexUnitCIPrinter(port: uint = DEFAULT_PORT, server: String = DEFAULT_SERVER)
        {
            this.port = port;
            this.server = server;

            messageQueue = [];

            socket = new XMLSocket ();
            socket.addEventListener( DataEvent.DATA, dataHandler );
            socket.addEventListener( Event.CONNECT, handleConnect );
            socket.addEventListener( IOErrorEvent.IO_ERROR, errorHandler);
            socket.addEventListener( SecurityErrorEvent.SECURITY_ERROR,errorHandler);
            socket.addEventListener( Event.CLOSE,errorHandler);

            timeOut = new Timer( 2000, 1 );
            timeOut.addEventListener(TimerEvent.TIMER_COMPLETE, declareBroken, false, 0, true );
            timeOut.start();

            try
            {
                socket.connect( server, port );
                timeOut.stop();
            } catch (e:Error) {
                //This needs to be more than a trace
                trace (e.message);
            }   
        }

        /**
         * Invoked when the timeout has been met, cancel everything
         */
        private function declareBroken( event:TimerEvent ):void {
            errorHandler( new Event( "broken") );
        }

        /**
         *
         */
        protected function sendResults(msg:String):void
        {
            if(socket.connected)
            {
                trace("sending message")
                socket.send( msg );             
            } else {
                // queue to message for when we are connected to the server
                trace("sendResults(): Queuing message: " + msg);
                messageQueue.push(msg);
            }

            trace(msg);
        }

        /**
         *
         */
        private function handleConnect(event:Event):void
        {
            trace("handleConnect()");
        }

        private function sendQueueTestResults(): void
        {
            trace("sendQueueTestResults()");
            for each ( var message: String in messageQueue )
            {
                trace("sendQueueTestResults(): msg=" + message);
                sendResults(message);
            }
        }

        /**
         *
         */
        private function errorHandler(event:Event):void
        {
            trace("errorHandler()");
            if ( !ready ) {
                //If we are not yet ready and received this, just inform the core so it can move on
//              dispatchEvent( new Event( AsyncListenerWatcher.LISTENER_FAILED ) );
            } else {
                //If on the other hand we were ready once, then the core is counting on us... so, if something goes
                //wrong now, we are likely hung up. For now we are simply going to bail out of this process
                exit();
            }            
        }

        /**
         *
         */
        private function dataHandler( event : DataEvent ) : void
        {
            var data : String = event.data;
            trace("FlexUnitCIPrinter#dataHandler: " + data);

            // If we received an acknowledgement on startup, the java server is read and we can start sending.          
            if ( data == START_OF_TEST_RUN_ACK ) {
                setStatusReady();
            } else if ( data == END_OF_TEST_ACK ) {
                // If we received an acknowledgement finish-up.
                // Close the socket.
                socket.close();
                exit();
            }
        }

        public function get ready():Boolean 
        {
            return _ready;
        }        

        protected function setStatusReady(): void
        {
            trace("FlexUnitCIPrinter#setStatusReady()");
            _ready = true;

            clientConnected();
        }

        protected function clientConnected(): void
        {
            trace("FlexUnitCIPrinter#clientConnected()");

            // now that we are connectd lets send all the test results which are already available
            sendQueueTestResults();
        }

        protected function exit(): void
        {
            trace("FlexUnitCIPrinter#exit()");
            fscommand("quit");
        }

        ///////////

        public function onRunStarted(): void
        {
            trace("onRunStarted()");
        }

        public function onTestStarted(test:Object):void
        {
            trace("onTestStarted()");
            startTime = getTimer();
            lastTestTime = getTimer(); // for the first test being run
        }

        public function onTestCompleted(test:Object):void
        {
            var duration:Number = getTimer() - startTime;
            var className: String = getQualifiedClassName(test);

            trace("onTestCompleted(): className=" + className + " duration=" + duration);
        }

        public function onTestFailure(failure:ITestFailure):void
        {
            trace("onTestFailure()");
			sendResults(getFailureMessage(failure));
            lastTestTime = getTimer();

        }      

        private function getFailureMessage(failure:ITestFailure): String
        {
            var duration:Number = getTimer() - startTime;
			var status:String = failure.isFailure ? FAILURE : ERROR;
			var stackTrace:String = failure.thrownException.getStackTrace();
			var xml:String =
				"<testcase classname='" + getQualifiedClassName(failure.failedTest)
				+ "' name='" + failure.failedMethod
				+ "' time='" + duration + "' status='" + status + "'>"

					+ "<error message='" + xmlEscapeMessage(failure.exceptionMessage) 
					+ "' type='"+ getQualifiedClassName(failure.thrownException) +"' >"
						+ "<![CDATA[" + stackTrace + "]]>"
					+ "</error>"				

				+ "</testcase>";

			return xml;
        }

        protected static function xmlEscapeMessage(message:String):String {
			if (!message) return '';

			var escape:XML = <escape/>;
			escape.setChildren( message );
			return escape.children()[0].toXMLString();
        }

        public function onTestSuccess(success:ITestSuccess):void
        {
            var duration:Number = getTimer() - lastTestTime;
            var methodName: String = success.method;
            var featureName: String = success.feature;
            var className: String = getQualifiedClassName(success.test);

            trace("onTestSuccess(): methodName=" +methodName + " featureName=" + featureName + " className=" + className + " duration=" + duration);

            sendResults("<testcase classname=\"" + className +"\" name=\"" + methodName +"\" time=\"" + duration +"\" status=\"success\" />");


            lastTestTime = getTimer();
        } 

        public function onTestIgnored(method:Method):void
        {
            trace("onTestIgnored()");
            var duration:Number = getTimer() - lastTestTime;
            var methodName: String = method.name;
            var className: String = getQualifiedClassName(method.scope);

            var xml:String =
            				"<testcase classname=\""+className+"\" name=\""+methodName+"\" time=\"" + duration  + "\" status=\""+IGNORE+"\">"
            				+ "<skipped />"
            				+ "</testcase>";
            sendResults(xml);

            lastTestTime = getTimer();
        }

        public function onWarning(warning:ITestWarning):void        
        {
            trace("onWarning()");
        }

        public function onRunCompleted(result:IResult):void
        {
            trace("onRunCompleted()");
			sendResults(END_OF_TEST_RUN);
        }
    }
}