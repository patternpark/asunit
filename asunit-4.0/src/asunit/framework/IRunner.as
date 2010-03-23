package asunit.framework {

    import flash.events.IEventDispatcher;
    import flash.display.DisplayObjectContainer;

	public interface IRunner extends IEventDispatcher {
		function run(item:Class, result:IResult, testMethod:String=null, visualContext:DisplayObjectContainer=null):void;
	}
}

