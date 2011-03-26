package asunit.runners {
	
	import asunit.events.TimeoutCommandEvent;
	import asunit.framework.Assert;
	import asunit.framework.Async;
	import asunit.framework.IResult;
	import asunit.framework.Result;
	import asunit.framework.IAsync;
	import asunit.framework.IRunner;
	import asunit.framework.IRunnerFactory;
	import asunit.framework.Method;
	import asunit.framework.TestFailure;
	import asunit.framework.TestIterator;
	import asunit.framework.TestSuccess;
	import asunit.framework.TestWarning;
	import asunit.util.ArrayIterator;
	import asunit.util.Iterator;
	import flash.display.Sprite;
	import org.swiftsuspenders.Injector;

	import p2.reflect.Reflection;
	import p2.reflect.ReflectionMetaData;
	import p2.reflect.ReflectionVariable;

	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;

    public class TestRunner extends EventDispatcher implements IRunner {
        
		/**
		 * 
		 */
		//TODO: perhaps add a getter for this to IRunner
        public var result:IResult;

        // partially exposed for unit testing
        internal var currentTest:Object;
        internal var async:IAsync;
		/** Supplies dependencies to tests, e.g. IAsync, context Sprite. */
		internal var testInjector:Injector;

        protected var currentMethod:Method;
        protected var currentTestReflection:Reflection;
        protected var methodIsExecuting:Boolean = false;
        protected var methodPassed:Boolean = true;
        protected var methodTimeoutID:Number;
        protected var methodsToRun:TestIterator;
        protected var startTime:Number;
        protected var testMethodNameReceived:Boolean;
        protected var timer:Timer;
        protected var visualContext:DisplayObjectContainer;
        protected var visualInstances:Array;

        public function TestRunner(result:IResult = null) {
            async  = new Async();
            this.result = result ||= new Result();
            testInjector = new Injector();
			testInjector.mapValue(IAsync, async);
			testInjector.mapValue(Async, async);
            timer = new Timer(0, 1);
            timer.addEventListener(TimerEvent.TIMER, runNextMethods);
            visualInstances = [];
        }

        public function runMethodByName(testOrSuite:Class, methodName:String=null, visualContext:DisplayObjectContainer=null):void {
            run(testOrSuite, methodName, visualContext);
        }

        public function run(test:Class, methodName:String=null, visualContext:DisplayObjectContainer=null):void {
			currentTestReflection  = Reflection.create(test);
            this.visualContext     = visualContext;
			testInjector.mapValue(Sprite, visualContext);
            currentMethod          = null;
            testMethodNameReceived = (methodName != null);

            try {
                currentTest = testInjector.instantiate(test);
            }
            catch(e:VerifyError) {
                warn("Unable to instantiate provided test case with: " + currentTestReflection.name);
                return;
            }

            async.addEventListener(TimeoutCommandEvent.CALLED,     onAsyncMethodCalled);
            async.addEventListener(TimeoutCommandEvent.TIMED_OUT,  onAsyncMethodTimedOut);
            
            startTime = getTimer();
            result.onTestStarted(currentTest);
            
            methodsToRun = createTestIterator(currentTest, methodName);

            if(methodsToRun.length == 0) {
                warn(">> We were unable to find any test methods in " + currentTestReflection.name + ". Did you set the --keep-as3-metadata flag?");
            }
			
            runNextMethods();
        }

        protected function createTestIterator(test:*, testMethodName:String):TestIterator {
            return new TestIterator(test, testMethodName);
        }

        protected function runNextMethods(e:TimerEvent = null):void {
			// Loop through as many as possible without hitting asynchronous tests.
			// This keeps the call stack small.
			while (methodsToRun.hasNext()) {
				var hasAsyncPending:Boolean = runMethod(methodsToRun.next());
				if (hasAsyncPending) return;
			}
			
			onTestCompleted();
        }
        
		/**
		 * 
		 * @param	method
		 * @return	true if asynchronous calls are pending after calling the test method.
		 */
        protected function runMethod(method:Method):Boolean {
            if (!method) return false;
            currentMethod = method;
            methodPassed = true; // innocent until proven guilty by recordFailure()
            
            if (currentMethod.ignore) {
                result.onTestIgnored(currentMethod);
                onMethodCompleted();
                return false;
            }

            // This is used to prevent async callbacks from triggering onMethodCompleted too early.
            methodIsExecuting = true;
            
            if (currentMethod.expects) {
                try {
                    var errorClass:Class = getDefinitionByName(currentMethod.expects) as Class;
                    var errorMessage:String = currentMethod.message;
                    if(errorMessage == null) {
                    	Assert.assertThrows(errorClass, currentMethod.value);
                    }
                    else {
                        Assert.assertThrowsWithMessage(errorClass, errorMessage, currentMethod.value);
                    }
                }
                catch(definitionError:ReferenceError) {
                    // NOTE: [luke] Added ReferenceError catch here b/c I had a bad class name in my expects.
                    // Does this look right?
                    recordFailure(new Error('Could not find Reference for: ' + currentMethod.expects));
                }
                catch (error:Error) {
                    recordFailure(error);
                }
            }
            else {
                try {
                    currentMethod.execute();
                }
                catch (error:Error) {
                    recordFailure(error);
                }
            }
            
            methodIsExecuting = false;
            
            if (async.hasPending) return true;

            onMethodCompleted();
			return false;
        }

        protected function onMethodCompleted(wasAsync:Boolean = false):void {
            async.cancelPending();
            
            if (currentMethod.isTest && methodPassed && !currentMethod.ignore) {
                result.onTestSuccess(new TestSuccess(currentTest, currentMethod.name));
            }

            if (wasAsync)
				runNextMethods();
            
            // green thread for runNextMethods()
            // This runs much slower in Flash Player 10.1.
            //timer.reset();
            //timer.start();
        }
        
        protected function onAsyncMethodCalled(event:TimeoutCommandEvent):void {
            try {
                event.command.execute();
            }
            catch (error:Error) {
                recordFailure(error);
            }
            onAsyncMethodCompleted(event);
        }
        
        protected function onAsyncMethodTimedOut(event:TimeoutCommandEvent):void {
            var error:IllegalOperationError = new IllegalOperationError("Timeout (" + event.command.duration + "ms) exceeded on an asynchronous operation.");
            recordFailure(error);
            onAsyncMethodCompleted(event);
        }
        
        protected function recordFailure(error:Error):void {
            methodPassed = false;
            result.onTestFailure(new TestFailure(currentTest, currentMethod.name, error));
        }

        protected function onAsyncMethodCompleted(event:Event = null):void {
            if (!methodIsExecuting && !async.hasPending) {
                onMethodCompleted(true);
            }
        }
        
        protected function onTestCompleted():void {
            async.removeEventListener(TimeoutCommandEvent.CALLED,      onAsyncMethodCalled);
            async.removeEventListener(TimeoutCommandEvent.TIMED_OUT,   onAsyncMethodTimedOut);
            async.cancelPending();
            
            result.onTestCompleted(currentTest);
            
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        protected function get testCompleted():Boolean {
            return (!methodsToRun.hasNext() && !async.hasPending);

        }
        protected function warn(message:String, method:Method=null):void {
            result.onWarning(new TestWarning(message, method));
        }
    }
}

