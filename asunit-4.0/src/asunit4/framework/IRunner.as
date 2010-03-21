package asunit4.framework {

    import flash.events.IEventDispatcher;
    import flash.display.DisplayObjectContainer;

	public interface IRunner extends IEventDispatcher {
		function run(item:Class, result:IResult, visualContext:DisplayObjectContainer=null):void;
	}
}

