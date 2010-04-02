package asunit.fixtures {

    public class ConcreteRunner implements IRunner {

        [Inject]
        public var bridge:AsUnitBridge;

		public function run(testOrSuite:Class, result:IResult, testMethod:String=null, visualContext:DisplayObjectContainer=null):void {
            // call methods on the Standard AsUnitBridge
            bridge.onTestStarted(test);
            bridge.onTestSuccess(null);
            bridge.onTestCompleted(test);
        }
    }
}

