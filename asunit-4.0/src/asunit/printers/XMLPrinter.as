
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

    /**
    *   The <code>XMLPrinter</code> is used to transform AsUnit test results
    *   to JUnit-compatible XML content.
    *   
    *   This printer will send JUnit-compatible XML content to trace output. The XML content
    *   will be enclosed by '&lt;TestResults/&gt;' tags.
    **/
	public class XMLPrinter implements IRunListener {
        public var traceResults:Boolean = true;

		protected var projectName:String;
		protected var contextName:String;
		protected var messageQueue:Array;
        protected var testPrefix:String = "<TestResults>";
        protected var testSuffix:String = "</TestResults>";
		
		public function XMLPrinter(projectName:String = '', contextName:String = '') {
			this.projectName = projectName;
			this.contextName = contextName;
			messageQueue = [];
        }

        public function onRunStarted():void {
            if (testPrefix) {
                sendMessage(testPrefix);
            }
			sendMessage("<startTestRun totalTestCount='0' projectName='" + projectName
				+ "' contextName='" + contextName +"' />");
        }

        public function onRunCompleted(result:IResult):void {
			sendMessage('<endOfTestRun />');

            if (testSuffix) {
                sendMessage("</TestResults>");
            }

            if (traceResults) {
                trace(toString());
            }
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
			var xmlMessage:String = "<testCase name='" + warning.method.name
				+ "' testSuite='" + getQualifiedClassName(warning.method.scope) + "' status='warning'/>";
			sendMessage(xmlMessage);
		}
		
        public function toString():String {
            return messageQueue.join("\n");
        }
		
		protected function sendMessage(message:String):void {
            messageQueue.push(message);
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
		
		protected static function xmlEscapeMessage(message:String):String {
			if (!message) return '';
			
			var escape:XML = <escape/>;
			escape.setChildren( message );
			return escape.children()[0].toXMLString();
		}
	}
}





