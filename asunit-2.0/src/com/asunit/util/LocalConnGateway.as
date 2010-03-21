
import com.asunit.util.*;

/************************************************
::: LocalConnGateway

SERVER EXAMPLE:
var dp = new RemoteApiClass(); // Like DataProviderClass();
var srvrId = "SomeUniqueIdentifier";
this.local = com.framework.util.LocalConnGateway.createServer(dp, srvrId);

CLIENT EXAMPLE:
var srvrId = "SomeUniqueIdentifier"; // matches an existing serverId
this.remote = com.framework.util.LocalConnGateway.createClient(srvrId);

this.res = this.remote.getItemAt(3);
echo("res : " + this.res.label);

************************************************/

class com.asunit.util.LocalConnGateway {
	//private static var existingServers:Array;
	//private static var clientQueue:Array;

	//------------------------------------------------
	// Factory method for LC Server Instances
	// cb : An Object Instance that whose methods/props will be called
	// 		by any client classes
	// srvrId : Unique string to identify the LC Server instance
	// NOTE: Any "." found in the serverId will be ripped out...
	// this is done to prevent any potential namespace conflicts...
	public static function createServer(cb:Object, srvrId:String):LocalConnServer
	{
		return new LocalConnServer(cb, srvrId);
	}

	//------------------------------------------------
	// Factory method for LC Client Instances
	// srvrId : Unique String Matching an existing .createServer instance
	public static function createClient(srvrId:String):LocalConnClient
	{
		return new LocalConnClient(srvrId);
		// was attempting to build a queue so that clients could be created
		// before servers - but *I think* that they already can!!!
		//return getClient(validateId(srvrId));
	}
}
