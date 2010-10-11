package asunit.framework {

    import flash.events.IEventDispatcher;
    import flash.display.DisplayObjectContainer;

	public interface IRunner extends IEventDispatcher {

		function run(testOrSuite:Class, testMethodName:String=null, visualContext:DisplayObjectContainer=null):void;

	}
}

