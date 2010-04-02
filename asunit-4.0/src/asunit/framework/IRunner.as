package asunit.framework {

    import flash.events.IEventDispatcher;
    import flash.display.DisplayObjectContainer;

	public interface IRunner extends IEventDispatcher {
		function run(testOrSuite:Class, result:IResult, testMethod:String=null, visualContext:DisplayObjectContainer=null):void;
	}
}

