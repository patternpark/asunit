package asunit4
{
	import flash.events.EventDispatcher;
	import flash.net.XMLSocket;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	public class FlashBuilderPrinter extends EventDispatcher
	{
		protected var socket:XMLSocket;
		//protected var ip:String = "127.0.0.1";
		//protected var port:uint = 8765;
		
		public function FlashBuilderPrinter()
		{
			socket = new XMLSocket();
	      	socket.addEventListener(Event.CONNECT, onConnect);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onErrorEvent);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorEvent);
   	   		socket.addEventListener(Event.CLOSE, onErrorEvent);
		}
		
		public function connect(ip:String = '127.0.0.1', port:uint = 8765):void
		{
   	   		try
   	   		{
   	   			socket.connect(ip, port);
   	   		}
			catch (e:Error)
			{
   	   			trace('## Error connecting to socket: ' + e.message);
   	   		}
		}
		
		
		
		
		
		protected function onConnect(event:Event):void
		{
			trace('onConnect()');
			dispatchEvent(event);
		}
		
		protected function onErrorEvent(event:Event):void
		{
			trace('onErrorEvent() - event: ' + event);
		}
		
	}
}
