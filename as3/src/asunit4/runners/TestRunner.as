package asunit4.runners {
    import asunit.framework.Assert;
    import asunit.util.ArrayIterator;
    import asunit.util.Iterator;

    import asunit4.async.Async;
    import asunit4.async.IAsync;
    import asunit4.events.TimeoutCommandEvent;
    import asunit4.framework.IResult;
    import asunit4.framework.IRunner;
    import asunit4.framework.Method;
    import asunit4.framework.TestFailure;
    import asunit4.framework.TestIterator;
    import asunit4.framework.TestSuccess;

    import flash.display.DisplayObjectContainer;
    import flash.errors.IllegalOperationError;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.utils.clearTimeout;
    import flash.utils.getDefinitionByName;
    import flash.utils.getTimer;
    import flash.utils.setTimeout;

    import p2.reflect.Reflection;
    import p2.reflect.ReflectionMember;
    import p2.reflect.ReflectionVariable;

    public class TestRunner extends EventDispatcher implements IRunner, IAsync {

        public static var ASYNC_INTERFACE:String = 'asunit4.async::IAsync';
        public static var DISPLAY_OBJECT_CONTAINER:String = 'flash.display::DisplayObjectContainer';

        // partially exposed for unit testing
        internal var currentTest:Object;

        protected var async:IAsync;
        protected var asyncMembers:Iterator;
        protected var currentMethod:Method;
        protected var currentTestReflection:Reflection;
        protected var injectableMembers:Iterator;
        protected var methodIsExecuting:Boolean = false;
        protected var methodPassed:Boolean = true;
        protected var methodTimeoutID:int = -1;
        protected var methodsToRun:TestIterator;
        protected var result:IResult;
        protected var startTime:Number;
        protected var timer:Timer;
        protected var visualContext:DisplayObjectContainer;

        public function TestRunner() {
            async = new Async();
            timer = new Timer(0, 1);
            timer.addEventListener(TimerEvent.TIMER, runNextMethod);
        }

        public function run(test:Class, result:IResult, visualContext:DisplayObjectContainer=null):void {
            runMethodByName(test, result, visualContext);
        }
        
        public function runMethodByName(test:Class, result:IResult, visualContext:DisplayObjectContainer=null, testMethodName:String=null):void {
            currentTest           = new test();
            currentTestReflection = Reflection.create(test);
            currentMethod         = null;
            this.result           = result;
            this.visualContext    = visualContext;

            initializeInjectableMembers();
            
            async.addEventListener(TimeoutCommandEvent.CALLED,     onAsyncMethodCalled);
            async.addEventListener(TimeoutCommandEvent.TIMED_OUT,  onAsyncMethodTimedOut);
            
            startTime = getTimer();
            result.onTestStarted(currentTest);
            
            methodsToRun = new TestIterator(currentTest, testMethodName);
            runNextMethod();            
        }

        protected function initializeInjectableMembers():void {
            injectableMembers = new ArrayIterator(currentTestReflection.getMembersByMetaData('Inject'));
        }

        protected function runNextMethod(e:TimerEvent = null):void {
            if (testCompleted) {
                onTestCompleted();
                return;
            }
            
            runMethod(methodsToRun.next());
        }
        
        protected function runMethod(method:Method):void {
            if (!method) return;
            currentMethod = method;
            methodPassed = true; // innocent until proven guilty by recordFailure()
            
            if (currentMethod.ignore) {
                result.onTestIgnored(currentMethod);
                onMethodCompleted();
                return;
            }

            injectMembers();
            
            if (currentMethod.timeout >= 0) {
                methodTimeoutID = setTimeout(onMethodTimeout, currentMethod.timeout);
            }
            
            // This is used to prevent async callbacks from triggering onMethodCompleted too early.
            methodIsExecuting = true;
            
            if (currentMethod.expects) {
                try {
                    var errorClass:Class = getDefinitionByName(currentMethod.expects) as Class;
                    Assert.assertThrows(errorClass, currentMethod.value);
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
                    currentMethod.value();
                }
                catch (error:Error) {
                    recordFailure(error);
                }
            }
            
            methodIsExecuting = false;
            
            if (async.hasPending) return;
            onMethodCompleted();
        }

        protected function onMethodTimeout():void {
            recordFailure(new IllegalOperationError('Timeout (' + currentMethod.timeout + 'ms) exceeded during method ' + currentMethod.name));
            onMethodCompleted();
        }
        
        protected function onMethodCompleted():void {
            clearTimeout(methodTimeoutID);
            async.cancelPending();
            
            if (currentMethod.isTest && methodPassed && !currentMethod.ignore) {
                result.onTestSuccess(new TestSuccess(currentTest, currentMethod.name));
            }

            // Calling synchronously is faster but keeps adding to the call stack.
            runNextMethod();
            
            // green thread for runNextMethod()
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
                onMethodCompleted();
            }
        }
        
        protected function onTestCompleted():void {
            async.removeEventListener(TimeoutCommandEvent.CALLED,      onAsyncMethodCalled);
            async.removeEventListener(TimeoutCommandEvent.TIMED_OUT,   onAsyncMethodTimedOut);
            async.cancelPending();
            
            result.onTestCompleted(currentTest);
            
            //TODO: move out because runTime is for whole run, not one test
            //result.runTime = getTimer() - startTime;
            
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        protected function get testCompleted():Boolean {
            return (!methodsToRun.hasNext() && !async.hasPending);
        }

        protected function injectMembers():void {
            var member:ReflectionVariable;
            while(injectableMembers.hasNext()) {
                injectMember(injectableMembers.next());
            }
            injectableMembers.reset();
        }

        protected function injectMember(member:ReflectionVariable):void {
            var reflection:Reflection = Reflection.create(getDefinitionByName(member.type));
            try {
            var instance:* = createInstanceFromReflection(reflection);
            }
            catch(e:VerifyError) {
                throw new VerifyError("Failed to instantiate " + member.type + " in order to inject public var " + member.name);
            }
            currentTest[member.name] = instance;
        }

        protected function createInstanceFromReflection(reflection:Reflection):* {
            var clazz:Class = getClassReferenceFromReflection(reflection);
            var constructorReflection:Reflection = Reflection.create(clazz);
            // Return the shared async instance if they're expecting any 
            // data type that isA IAsync...
            if(constructorReflection.isA(ASYNC_INTERFACE)) {
                return async;
            }
            else if(constructorReflection.isA(DISPLAY_OBJECT_CONTAINER)) {
                trace(">> FOUND A DISPLAY OBJECT!!!");
            }

            return new constructorReflection.classReference();
        }

        protected function getClassReferenceFromReflection(reflection:Reflection):Class {
            // This will attempt to deal with I-prefixed interfaces - like IAsync.
            if(reflection.isInterface) {
                return attemptToGetClassReferenceFromReflection(reflection);
            }
            return reflection.classReference;
        }

        protected function attemptToGetClassReferenceFromReflection(reflection:Reflection):Class {
            var fullName:String = reflection.name;
            var parts:Array = fullName.split("::");
            var interfaceName:String = parts.pop();
            var expr:RegExp = /I([AZ].+)/;
            var match:Object = expr.exec(interfaceName);
            if(match) {
                parts.push(match[1]);
                var implementationName:String = parts.join("::");
                return Class(getDefinitionByName(implementationName));
            }
            throw new VerifyError("Unable to find class instance for interface " + fullName);
        }

        // TODO: Implement this method:
        protected function argumentFreeConstructor(reflection:Reflection):Boolean {
            return true;
        }

        protected function updateAsyncMembers():void {
            asyncMembers.reset();

            var member:ReflectionVariable;
            while(asyncMembers.hasNext()) {
                member = asyncMembers.next();
                try {
                    currentTest[member.name] = async;
                }
                catch(e:Error) {
                    trace("[ERROR] TestRunner attempted to write an IAsync instance, but was denied for some reason: " + e);
                }
            }
        }

        /**
         * Implementing the asunit4.async.IAsync interface to delegate
         **/

		public function add(handler:Function, duration:int = -1):Function {
            return async.add(handler, duration);
        }

		public function cancelPending():void {
            async.cancelPending();
        }

		public function proceedOnEvent(test:Object, target:IEventDispatcher, eventName:String, timeout:int = 500, timeoutHandler:Function = null):void {
            async.proceedOnEvent(test, target, eventName, timeout, timeoutHandler);
        }

		public function getPending():Array {
            return async.getPending();
        }

		public function get hasPending():Boolean {
            return async.hasPending;
        }
    }
}

