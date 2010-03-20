package asunit4.framework {

    import flash.display.DisplayObjectContainer;

	public interface IRunner {
		function run(item:Class, result:IResult, visualContext:DisplayObjectContainer=null):void;
	}
}

