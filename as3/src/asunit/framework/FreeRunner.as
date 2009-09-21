package asunit.framework {
	import asunit.framework.async.TimeoutCommand;
	import asunit.runner.ITestRunner;
	import asunit.textui.ResultPrinter;
	import flash.events.Event;
	import flash.events.EventDispatcher;
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

	public class FreeRunner extends MovieClip implements ITestRunner {
		protected var result:FreeTestResult;
		protected var methodsList:Iterator;
		protected var currentTest:Object;
		protected var currentMethodName:String;
		protected var _printer:ResultPrinter;
		protected var startTime:Number;

		public function FreeRunner() {
			result = new FreeTestResult();
			configureListeners();
		}
		
		public function get printer():ResultPrinter { return _printer; }
		
        public function set printer(printer:ResultPrinter):void {
			if (_printer is DisplayObject && getChildIndex(_printer)) {
				removeChild(_printer);
			}

			_printer = printer;
			
			if (_printer is DisplayObject) {
				addChild(_printer);
			}
        }

		
		/**
		 *
		 * @param	test	An instance of a class with test methods.
		 * @return	An array of method names as strings.
		 */
		public static function getTestMethods(test:Object):Array {
			var description:XML = describeType(test);
			var methodNodes:XMLList = description..method.(@name.match("^test"));
			var methodNames:XMLList = methodNodes.@name;
			var testMethods:Array = [];
			for each (var item:Object in methodNames) {
				testMethods.push(String(item));
			}
			// For now, enforce a consistent order to enable precise testing.
			testMethods.sort();
			return testMethods;
		}
		
		public static function countTestMethods(test:Object):uint {
			return getTestMethods(test).length;
		}
		
		protected function get completed():Boolean {
			return (!methodsList || !methodsList.hasNext()) && asyncsCompleted;
		}
		
		public function run(test:Object):void {
			currentTest = test;
			currentMethodName = '';
			methodsList = new ArrayIterator(getTestMethods(test));
			
			startTime = getTimer();
			_printer.startTest(test);
			
			runNextMethod();
		}
		
		protected function runNextMethod():void {
			if (completed) {
				onCompleted();
				return;
			}
			
			currentMethodName = String(methodsList.next());
			var method:Function = currentTest[currentMethodName] as Function;
			
			if (currentTest.hasOwnProperty('setUp'))
				currentTest.setUp();
			
			runMethodForTest(method, currentTest, currentMethodName, result);
			
			var commands:Array = Async.instance.getCommandsForTest(currentTest);
			if (commands && commands.length) {
				// find the async commands and listen to them
				for each (var command:TimeoutCommand in commands) {
					command.addEventListener(TimeoutCommand.CALLED, onAsyncMethodCalled);
					command.addEventListener(ErrorEvent.ERROR, onAsyncMethodFailed);
				}
				return;
			}
			
			if (currentTest.hasOwnProperty('tearDown'))
				currentTest.tearDown();
			
			// If setTimeout() were not used, the synchronous test methods
			// would keep increasing the callstack.
			setTimeout(runNextMethod, 1);
		}
		
		protected function onAsyncMethodCalled(e:Event):void {
			var command:TimeoutCommand = TimeoutCommand(e.currentTarget);
			runMethodForTest(command.execute, currentTest, currentMethodName, result);
			onAsyncMethodCompleted(e);
		}
		
		protected function onAsyncMethodFailed(e:ErrorEvent):void {
			// The TimeoutCommand doesn't know the method name.
			var testFailure:FreeTestFailure = new FreeTestFailure(currentTest, currentMethodName, e.error);
			// Record the test failure.
			result.addFailure(testFailure);
			
			//TODO: use events
			if (testFailure.isFailure)
				_printer.addFailure(currentTest, e.error as AssertionFailedError);
			else
				_printer.addError(currentTest, e.error);
				
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
		
		protected static function runMethodForTest(method:Function, test:Object, testMethodName:String, result:FreeTestResult):void {
			try {
				method();
			}
			catch (error:Error) {
				result.addFailure(new FreeTestFailure(test, testMethodName, error));
			}
		}
		
		protected function onCompleted():void {
			dispatchEvent(new TestResultEvent(TestResultEvent.NAME, result));
			
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
            _printer.width = stage.stageWidth;
            _printer.height = stage.stageHeight;
        }
		/*
		public function doRun(test:Object, showTrace:Boolean = false):ITestResult {

			//result = new FreeTestResult();

			//if (test.getIsComplete())
				//return result;

			if(_printer == null) {
				printer = new ResultPrinter(showTrace);
			}
			else {
				_printer.setShowTrace(showTrace);
			}

			result.addListener(printer);
			startTime = getTimer();
			test.setResult(result);
			test.setContext(this);
			test.addEventListener(Event.COMPLETE, testCompleteHandler);
			test.run();
			return result;
		}
		*/
	}
}
