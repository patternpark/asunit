package asunit.runners {

    import asunit.events.TimeoutCommandEvent;
    import asunit.framework.Assert;
    import asunit.framework.Async;
    import asunit.framework.CallbackBridge;
    import asunit.framework.IAsync;
    import asunit.framework.IResult;
    import asunit.framework.IRunner;
	import asunit.framework.IRunnerFactory;
    import asunit.framework.Method;
    import asunit.framework.TestFailure;
    import asunit.framework.TestIterator;
    import asunit.framework.TestSuccess;
    import asunit.framework.TestWarning;
    import asunit.util.ArrayIterator;
    import asunit.util.Iterator;

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
    import p2.reflect.ReflectionMetaData;
    import p2.reflect.ReflectionVariable;

    public class TestRunner extends EventDispatcher implements IRunner {
        public static var ASYNC_NAME:String = 'asunit.framework::Async';
        public static var IASYNC_NAME:String = 'asunit.framework::IAsync';
        public static var DISPLAY_OBJECT_CONTAINER:String = 'flash.display::DisplayObjectContainer';

        /**
         * This is how the Runner connects to a printer.
         * The AsUnitCore will inject the requested bridge
         * based on the concrete data type.
         *
         * There should be a similar Injection point on
         * whatever printers are interested in what this
         * concrete runner will dispatch.
         */
        [Inject]
        public var bridge:CallbackBridge;

        // partially exposed for unit testing
        internal var currentTest:Object;
        internal var async:IAsync;

        protected var asyncMembers:Iterator;
        protected var currentMethod:Method;
        protected var currentTestReflection:Reflection;
        protected var injectableMembers:Iterator;
        protected var methodIsExecuting:Boolean = false;
        protected var methodPassed:Boolean = true;
        protected var methodTimeoutID:Number;
        protected var methodsToRun:TestIterator;
        protected var startTime:Number;
        protected var testMethodNameReceived:Boolean;
        protected var timer:Timer;
        protected var visualContext:DisplayObjectContainer;
        protected var visualInstances:Array;

        private var _factory:IRunnerFactory;

        public function TestRunner() {
            async  = new Async();
            bridge = new CallbackBridge();
            timer  = new Timer(0, 1);
            timer.addEventListener(TimerEvent.TIMER, runNextMethod);
            visualInstances = [];
        }

        public function run(testOrSuite:Class, methodName:String=null, visualContext:DisplayObjectContainer=null):void {
            runMethodByName(testOrSuite, methodName, visualContext);
        }

        public function shouldRunTest(testClass:Class):Boolean {
            return bridge.shouldRunTest(testClass);
        }

        // This class doesn't really use the runner factory,
        // since it represents a leaf node in the test
        // hierarchy...
        public function set factory(factory:IRunnerFactory):void {
            _factory = factory;
        }

        public function get factory():IRunnerFactory {
            return _factory;
        }

        public function runMethodByName(test:Class, methodName:String=null, visualContext:DisplayObjectContainer=null):void {
            currentTestReflection  = Reflection.create(test);
            this.visualContext     = visualContext;
            currentMethod          = null;
            testMethodNameReceived = (methodName != null);

            try {
                currentTest            = new test();
            }
            catch(e:VerifyError) {
                warn("Unable to instantiate provided test case with: " + currentTestReflection.name);
                return;
            }

            initializeInjectableMembers();
            
            async.addEventListener(TimeoutCommandEvent.CALLED,     onAsyncMethodCalled);
            async.addEventListener(TimeoutCommandEvent.TIMED_OUT,  onAsyncMethodTimedOut);
            
            startTime = getTimer();
            bridge.onTestStarted(currentTest);
            
            methodsToRun = createTestIterator(currentTest, methodName);

            if(methodsToRun.length == 0) {
                warn(">> We were unable to find any test methods in " + currentTestReflection.name + ". Did you set the --keep-as3-metadata flag?");
            }
            runNextMethod();
        }

        protected function createTestIterator(test:*, testMethodName:String):TestIterator {
            return new TestIterator(test, testMethodName);
        }

        protected function initializeInjectableMembers():void {
            injectableMembers = new ArrayIterator(currentTestReflection.getMembersByMetaData('Inject'));
        }

        protected function runNextMethod(e:TimerEvent = null):void {
            if(!testMethodNameReceived && methodsToRun.readyToTearDown) {
                removeInjectedMembers();
                removeInjectedVisualInstances();
            }
            
            if (testCompleted) {
                onTestCompleted();
                return;
            }

            if(methodsToRun.readyToSetUp) {
                prepareForSetUp();
            }

            runMethod(methodsToRun.next());
        }
        
        protected function runMethod(method:Method):void {
            if (!method) return;
            currentMethod = method;
            methodPassed = true; // innocent until proven guilty by recordFailure()
            
            if (currentMethod.ignore) {
                bridge.onTestIgnored(currentMethod);
                onMethodCompleted();
                return;
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
                    currentMethod.execute();
                }
                catch (error:Error) {
                    recordFailure(error);
                }
            }
            
            methodIsExecuting = false;
            
            if (async.hasPending) return;

            onMethodCompleted();
        }

        protected function onMethodCompleted():void {
            async.cancelPending();
            
            if (currentMethod.isTest && methodPassed && !currentMethod.ignore) {
                bridge.onTestSuccess(new TestSuccess(currentTest, currentMethod.name));
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
            bridge.onTestFailure(new TestFailure(currentTest, currentMethod.name, error));
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
            
            bridge.onTestCompleted(currentTest);
            
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        protected function get testCompleted():Boolean {
            return (!methodsToRun.hasNext() && !async.hasPending);
        }

        protected function removeInjectedMembers():void {
            var member:ReflectionVariable;
            while(injectableMembers.hasNext()) {
                removeInjectedMember(injectableMembers.next());
            }
            injectableMembers.reset();
        }

        protected function removeInjectedVisualInstances():void {
            var visuals:Iterator = new ArrayIterator(visualInstances);
            while(visuals.hasNext()) {
                visualContext.removeChild(visuals.next());
            }
            visualInstances = [];
        }

        protected function removeInjectedMember(member:ReflectionVariable):void {
            if(!member) return;
            currentTest[member.name] = null;
        }

        protected function prepareForSetUp():void {
            injectMembers();
        }

        protected function injectMembers():void {
            var member:ReflectionVariable;
            while(injectableMembers.hasNext()) {
                injectMember(injectableMembers.next());
            }
            injectableMembers.reset();
        }

        protected function injectMember(member:ReflectionVariable):void {
            if(!member) return;
            var definition:Class;
            try {
                definition = getDefinitionByName(member.type) as Class;
            }
            catch(referenceError:ReferenceError) {
                warn("Unable to [Inject] with " + member.type + ". Maybe this was an inner class? That makes it unavailable to external code, try putting it in it's own file.");
                return;
            }
            var reflection:Reflection = Reflection.create(definition);
            try {
                var instance:* = createInstanceFromReflection(reflection);
                configureInjectedInstance(member, instance);
                currentTest[member.name] = instance;
            }
            catch(e:VerifyError) {
                throw new VerifyError("Failed to instantiate " + member.type + " in order to inject public var " + member.name);
            }
        }

        protected function configureInjectedInstance(member:ReflectionVariable, instance:*):void {
            var injectTag:ReflectionMetaData = member.getMetaDataByName('Inject');
            var args:Array = injectTag.args;
            var arg:Object;
            var len:int = args.length;
            for(var i:int; i < len; i++) {
                arg = args[i];
                try {
                    instance[arg.key] = coerceArgumentType(member, arg.value);
                }
                catch(e:ReferenceError) {
                    var reflect:Reflection = Reflection.create(instance);
                    warn("Unable to inject attribute " + arg.key + " on " + reflect.name);
                }
            }
        }

        protected function coerceArgumentType(member:ReflectionVariable, value:String):* {
            switch(value) {
                case "false" :
                    return false;
                case "true" :
                    return true;
            }

            return value;
        }

        protected function createInstanceFromReflection(reflection:Reflection):* {
            // Return the shared async instance if they're expecting the interface
            // or concrete instance, but NOT if their Inject is merely a subclass...
            if(reflection.name == ASYNC_NAME || reflection.name == IASYNC_NAME) {
                return async;
            }

            var clazz:Class = getClassReferenceFromReflection(reflection);
            var constructorReflection:Reflection = Reflection.create(clazz);
            try {
                var instance:* = new constructorReflection.classReference();
            }
            catch(e:VerifyError) {
                warn("Unable to instantiate: " + reflection.name + " for injection");
            }

            if(constructorReflection.isA(DISPLAY_OBJECT_CONTAINER)) {
                // Add injected DisplayObjectContainers to a collection
                // for removal, and add them to the visualContext if
                // one was provided to the run() method.
                if(visualContext) {
                    visualInstances.push(instance);
                    visualContext.addChild(instance);
                } 
                else {
                    warn("TestRunner is injecting a DisplayObjectContainer on your Test but wasn't given a visualContext when run was called. This means your visual entity will not be attached to the Display List.");
                }
            }

            return instance;
        }

        protected function warn(message:String, method:Method=null):void {
            bridge.onWarning(new TestWarning(message, method));
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
    }
}

