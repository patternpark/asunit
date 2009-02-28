
import com.asunit.util.*;

/************************************************

Copyright (C) 2004 Luke Bayes and Ali Mills

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

Any questions related to this code should be directed to :
lukebayes@users.sourceforge.net
or
alimills@users.sourceforge.net

************************************************/

class Sys {
	private static var localConn:LocalConnection;
	public static var CONN_ID:String = "_outputLineLc";
	private static var isUsingExternalOutput:Boolean = true;
	private static var localMsgBrkr:LocalMessageBroker;
	
	private function Sys() {
	}
	
	public static function useExternalOutput(useExtOut:Boolean):Void {
		isUsingExternalOutput = useExtOut;
	}
	
	public static function println(msg:String, category:String):String {
		if(isUsingExternalOutput) {
			var lc:LocalConnection = getLocalConn();
			lc.send(CONN_ID, "execResolve", "onShowEcho", escape(msg), category);
		} else {
			var lmb:LocalMessageBroker = LocalMessageBroker.getInstance();
			lmb.send(msg, category);
		}
		return msg;
	}
	
	public static function getLocalConn():LocalConnection {
		if(localConn == undefined) {
			localConn = new LocalConnection();
		}
		return localConn;
	}
	
	public static function getFileSeparator():String {
		var os:String = System.capabilities.os;
		if(os.indexOf("Win") > -1) {
			return "\\";
		} else if(os.indexOf("Mac") > -1) {
			return ":";
		} else if(os.indexOf("Linux") > -1) {
			return "/";
		}
	}
}
