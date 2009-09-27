package asunit.framework {
	import asunit.framework.async.TimeoutCommand;
	import asunit.runner.ITestRunner;
	import asunit.textui.ResultPrinter;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.describeType;
	import asunit.errors.AssertionFailedError;
	import asunit.util.ArrayIterator;
	import asunit.util.Iterator;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import asunit.framework.async.Async;
	import flash.events.IEventDispatcher;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.utils.Timer;

	public class FreeRunner extends MovieClip implements ITestRunner {
		protected var beforeMethodsList:Iterator;
		protected var testMethodsList:Iterator;
		protected var afterMethodsList:Iterator;
		
		protected var currentTest:Object;
		protected var currentMethodName:String;
		protected var _printer:ResultPrinter;
		protected var startTime:Number;
		protected var timer:Timer;
		protected var result:FreeTestResult;

		public function FreeRunner(printer:ResultPrinter = null) {
			result = new FreeTestResult();
			this.printer = printer;
			timer = new Timer(1, 1);
			timer.addEventListener(TimerEvent.TIMER, runNextMethod);
			configureListeners();
		}
		
		public function get printer():ResultPrinter { return _printer; }
		
        public function set printer(printer:ResultPrinter):void {
			if (_printer && result)
				result.removeListener(_printer);
				
			if (_printer is DisplayObject && getChildIndex(_printer)) {
				removeChild(_printer);
			}

			_printer = printer;
			
			if (_printer is DisplayObject) {
				addChild(_printer);
			}
			if (result)
				result.addListener(_printer);
        }

		protected static function getMethodsWithPrefixOrMetadata(object:Object, thePrefix:String, theMetadata:String):Array {
			var description:XML = describeType(object);
			var methodNodes:XMLList = description.method.( @name.indexOf(thePrefix) == 0
				|| (hasOwnProperty("metadata") && metadata.@name == theMetadata) );
			var methodNames:XMLList = methodNodes.@name;
			var testMethods:Array = [];
			for each (var item:Object in methodNames) {
				testMethods.push(String(item));
			}
			// For now, enforce a consistent order to enable precise testing.
			testMethods.sort();
			return testMethods;
		}
		
		public static function getBeforeMethods(test:Object):Array {
			return getMethodsWithPrefixOrMetadata(test, "setUp", "Before");
		}
		
		/**
		 *
		 * @param	test	An instance of a class with test methods.
		 * @return	An array of method names as strings.
		 */
		public static function getTestMethods(test:Object):Array {
			return getMethodsWithPrefixOrMetadata(test, "test", "Test");
		}
		
		public static function getAfterMethods(test:Object):Array {
			return getMethodsWithPrefixOrMetadata(test, "tearDown", "After");
		}
		
		public static function countTestMethods(test:Object):uint {
			return getTestMethods(test).length;
		}
		
		protected function get completed():Boolean {
			return (!testMethodsList || !testMethodsList.hasNext()) && asyncsCompleted;
		}
		
		public function run(test:Object):void {
			currentTest = test;
			currentMethodName = '';
			beforeMethodsList = new ArrayIterator(getBeforeMethods(test));
			testMethodsList   = new ArrayIterator(getTestMethods(test));
			afterMethodsList  = new ArrayIterator(getAfterMethods(test));
			
			startTime = getTimer();
			if (_printer)
				_printer.startTest(test);
			
			runNextMethod();
		}
		
		protected function runNextMethod(e:TimerEvent = null):void {
			if (completed) {
				onCompleted();
				return;
			}
			
			currentMethodName = String(testMethodsList.next());
			var method:Function = currentTest[currentMethodName] as Function;
			
			beforeMethodsList.reset();
			var beforeMethod:Function;
			while (beforeMethodsList.hasNext()) {
				beforeMethod = currentTest[String(beforeMethodsList.next())];
				try {
					beforeMethod();
				}
				catch (error:Error) {
					recordFailure(error);
				}
			}
			
			try {
				method();
			}
			catch (error:Error) {
				recordFailure(error);
			}
			
			var commands:Array = Async.instance.getCommandsForTest(currentTest);
			if (commands && commands.length) {
				// find the async commands and listen to them
				for each (var command:TimeoutCommand in commands) {
					command.addEventListener(TimeoutCommand.CALLED, onAsyncMethodCalled);
					command.addEventListener(ErrorEvent.ERROR, onAsyncMethodFailed);
				}
				return;
			}
			
			afterMethodsList.reset();
			var afterMethod:Function;
			while (afterMethodsList.hasNext()) {
				afterMethod = currentTest[String(afterMethodsList.next())];
				try {
					afterMethod();
				}
				catch (error:Error) {
					recordFailure(error);
				}
			}
				
			
			// If the asynchronous Timer were not used, the synchronous test methods
			// would keep increasing the callstack.
			timer.reset();
			timer.start();
		}
		
		protected function onAsyncMethodCalled(e:Event):void {
			var command:TimeoutCommand = TimeoutCommand(e.currentTarget);
			try {
				command.execute();
			}
			catch (error:Error) {
				recordFailure(error);
			}
			onAsyncMethodCompleted(e);
		}
		
		protected function onAsyncMethodFailed(e:ErrorEvent):void {
			// The TimeoutCommand doesn't know the method name.
			var testFailure:FreeTestFailure = new FreeTestFailure(currentTest, currentMethodName, e.error);
			// Record the test failure.
			result.addFailure(testFailure);
				
			onAsyncMethodCompleted(e);
		}
		
		protected function onAsyncMethodCompleted(e:Event):void {
			var command:TimeoutCommand = TimeoutCommand(e.currentTarget);
			command.removeEventListener(TimeoutCommand.CALLED,	onAsyncMethodCompleted);
			command.removeEventListener(ErrorEvent.ERROR,		onAsyncMethodFailed);
			
			if (asyncsCompleted) {
				onCompleted();
			}
		}
		
		protected function recordFailure(error:Error):void {
			result.addFailure(new FreeTestFailure(currentTest, currentMethodName, error));
		}
		
		protected function onCompleted():void {
			dispatchEvent(new TestResultEvent(TestResultEvent.NAME, result));
			
			if (!_printer) return;
			_printer.endTest(currentTest);
			var runTime:Number = getTimer() - startTime;
			_printer.printResult(result, runTime);
		}
		
		protected function get asyncsCompleted():Boolean {
			//TODO: maybe have Async send an event instead of checking it
			var commands:Array = Async.instance.getCommandsForTest(currentTest);
			return (!commands || commands.length == 0);
		}
		
		
		//////////////////////////////////////////////////////
		
        private function configureListeners():void {
            addEventListener(Event.ADDED_TO_STAGE, addedHandler);
            addEventListener(Event.ADDED, addedHandler);
        }

        protected function addedHandler(event:Event):void {
            if (!stage)
            {
                return;
            }
            if(event.target === _printer) {
                stage.align = StageAlign.TOP_LEFT;
                stage.scaleMode = StageScaleMode.NO_SCALE;
                stage.addEventListener(Event.RESIZE, resizeHandler);
                resizeHandler(new Event("resize"));
            }
        }

        private function resizeHandler(event:Event):void {
			if (!_printer) return;
            _printer.width = stage.stageWidth;
            _printer.height = stage.stageHeight;
        }
	}
}
