package asunit.framework {

    import flash.events.IEventDispatcher;
    import flash.display.DisplayObjectContainer;

	public interface IRunner extends IEventDispatcher {
		function run(testOrSuite:Class, result:IResult, testMethodName:String=null, visualContext:DisplayObjectContainer=null):void;

        function set factory(factory:IRunnerFactory):void;
        function get factory():IRunnerFactory;
	}
}

