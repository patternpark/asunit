package asunit.framework {

    import flash.events.IEventDispatcher;

    public interface IAsync extends IEventDispatcher {

        function set timeout(timeout:int):void;
        function get timeout():int;

		function add(handler:Function=null, duration:int=-1):Function;

		function cancelPending():void;
        
		function get hasPending():Boolean;
        
		function getPending():Array;

		function proceedOnEvent(target:IEventDispatcher, eventName:String, timeout:int = 500, timeoutHandler:Function = null):void;
    }
}

