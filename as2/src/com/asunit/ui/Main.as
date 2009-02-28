
import com.asunit.ui.*;
import com.asunit.framework.*;
import com.asunit.util.*;
import mx.controls.*;

class Main extends MovieClip {
	public static var linkageId:String = "com.asunit.ui.Main";

	var version:String = "2.8.0";
	var flashIsTextEditorResult:Boolean;
	var remoteVersionObj:RemoteVersion;
	var localConn:LocalConnServer;
	var outputLine:LocalConnServer;
	var tResult:TestResult;
	var tFailure:TestFailure;
	var test:Test;
	var intervalId:Number;

	var items:Array;
	var gutter:Number = 10;
	var successes:Number = 0;
	var failures:Number = 0;
	var totalTests:Number = 0;

	var output_txt:TextArea;
	var clearAll:Button;
	var reload:Button;
	var outputPanel:TextArea;
	var showSys:CheckBox;
	var showSysSo:SharedObject;

	var bar_mc:SuccessMeter;

	public function Main() {
		configureAssets();
		items = new Array();
		showSysSo = SharedObject.getLocal("showSysSoId");
		_visible = false;
		onEnterFrame = function() {
			_visible = true;
			remoteVersionObj = new RemoteVersion(this);
			showSys.clickHandler = onShowClicked;
			showSys.setSelected(showSysSo.data.isSelected);
			onResize();
	 		Stage.addListener(this);

			delete onEnterFrame;
		}

	}

	public function checkRemoteVersion(remoteVersion:String):Void {
		var remNumber:Number = Number(remoteVersion.split(".").join(""));
		var vers:Number = Number(getVersionNumber().split(".").join("").split(" [Release Candidate]").join(""));
		if(remNumber > vers) {
			var obj:Object = new Object();
			obj.success = false;
			obj.message = ">> There is a newer version of AsUnit (" + remoteVersion + ") available for download at: <a href='http://www.asunit.com'><u>http://www.asunit.com</u></a>";
			addTests([obj]);
		}
	}

	// Attached as clickHandler to the CheckBox
	public function onShowClicked():Void {
		_parent.onResize();
	}

	public function getVersionNumber():String {
		return version;
	}

	public function onUnload():Void {
		localConn.close();
		outputLine.close();
		saveTraceChoice();
	}

	public function saveTraceChoice():Void {
		var success:Object = showSysSo.flush();
	}

	public function configureAssets() {
		output_txt.vScrollPolicy = "auto";

		reload.onRelease = function() {
			_parent.onReload();
		}

		clearAll.onRelease = function() {
			_parent.onClear();
		}
	}

	public function clearTestDisplay():Void {
		items 	= new Array();
		refreshOutput();
	}

	public function onClear() {
		MMExecute("fl.outputPanel.clear();");
		clearTestDisplay();
	}

	public function onReload():Void {
		_root.loadUi();
	}

	public function onLoad():Void {
		init();
	}

	public function onResizeNoTrace():Void {
		var w:Number = Stage.width-gutter*2;
		var h:Number = Stage.height-(bar_mc._height + gutter*3);
		outputPanel._visible = false;

		output_txt.setSize(w, h);
		output_txt._x = gutter;
		showSys._x = gutter;
		reload._x = showSys._x + showSys._width + gutter;
		bar_mc._x = reload._x + reload._width + gutter;
		output_txt._y = gutter;
		bar_mc.setSize(w - (reload._x + reload._width), bar_mc._height);
		reload._y = clearAll._y = bar_mc._y = output_txt._y + output_txt.height + gutter;
		showSys._y = reload._y;
	}

	public function onResizeWithTrace():Void {
		var w:Number = Stage.width-gutter*2;
		var h:Number = Stage.height-(bar_mc._height + gutter*4);
		outputPanel._visible = true;

		outputPanel._x = gutter;
		outputPanel._y = gutter;
		outputPanel.setSize(w, h/2);
		output_txt.setSize(w, h/2);
		output_txt._y = outputPanel._y + outputPanel._height + gutter;
		output_txt._x = gutter;
		clearAll._x = output_txt._x;
		showSys._x = gutter;
		reload._x = showSys._x + showSys._width + gutter;
		bar_mc._x = reload._x + reload._width + gutter;
		bar_mc.setSize(w - (reload._x + reload._width), bar_mc._height);
		reload._y = clearAll._y = bar_mc._y = output_txt._y + output_txt.height + gutter;
		showSys._y = reload._y;
	}

	public function onResize():Void {
		showSysSo.data.isSelected = showSys.selected;
		showSysSo.flush();

		if(showSys.selected) {
			onResizeWithTrace();
		} else {
			onResizeNoTrace();
		}
	}

	public function init():Void {
		localConn = LocalConnGateway.createServer(this, "_AsUnitTestRunner");
		outputLine = LocalConnGateway.createServer(this, "_outputLineLc");
		output_txt.wordWrap = true;
		refreshOutput();
	}

	public function onShowEcho(msg, category) {
		msg = unescape(msg);
		if(showSys.selected) {
			outputPanel.text += msg;
		} else {
			MMExecute("fl.trace('" + msg + "');");
		}
	}

	public function getFirstLine():String {
		var str:String = "Version : " + getVersionNumber() + "\n";
		if(localConn.status) {
			str += "Unit Test UI Loaded at LocalConnection ID: '" + localConn.getId() + "'\n";
		} else {
			str += "ALERT : Unit Test UI LocalConnection <b>Failed</b> at ID : '<b>" + localConn.getId() + "</b>'\n";
		}
		if(outputLine.status) {
			str += "Echo Output Loaded at LocalConnection ID: '" + outputLine.getId() + "'\n";
		} else {
			str += "ALERT : Echo Output LocalConnection <b>Failed</b> at ID : '<b>" + outputLine.getId() + "</b>'\n";
		}
		return str;
	}

	public function getTestResultString():String {
		successes = 0;
		failures = 0;
		 var str = "";
		 var fStr = "";
		 for(var i=0; i<items.length; i++) {
		 	str += items[i].output;
		 	if(items[i].success) {
		 		successes++;
		 	} else {
		 		failures++;
		 		fStr += renderItemFailure(items[i]);
		 	}
		 }
		 return str + "\n" + getTestNumberOutput() + "\n" + fStr;
	}

	public function osIsWin():Boolean {
		var vs = $version;
		vs = vs.split(" ");
		vs = vs[0];
		if(vs != "WIN") {
			return false;
		}
		return true;
	}

	public function flashIsTextEditor():Boolean {
		if(flashIsTextEditorResult == undefined) {
			var doc = MMExecute("fl.getDocumentDOM().getDataFromDocument('lastFlashEditor');");
			if(doc == "true" || doc == null) {
				flashIsTextEditorResult = true;
			} else {
				flashIsTextEditorResult = false;
			}
		}
		return flashIsTextEditorResult;
	}

	public function renderItemFailure(item:Object):String {
		var str = "-----------------\nItem Failed at :\n";
		var isWin:Boolean = osIsWin();

		str += "assertion : " + item.assertion + "\n";
		str += "message : " + item.message + "\n";
		str += "methodName : " + item.methodName + "\n";
		if(isWin) {
			str += "className : " + "<a href=\"asfunction:_parent.classNameClicked," + item.className + "\"><u>" + item.className + "</u></a>\n";
		} else {
			str += "className : " + item.className + "\n";
		}

// 		for(var i in item) {
// 			if(i == "className" && isWin) {
// 				str += i + " : " + "<a href=\"asfunction:_parent.classNameClicked," + item[i] + "\"><u>" + item[i] + "</u></a>\n";
// 			} else {
// 				str += i + " : " + item[i] + "\n";
// 			}
// 		}
		return str;
	}

	public function classNameClicked(name:String):Void {
		name = name.split(".").join("/") + ".as";
		var uri:String = "";
		if(MMExecute('fl.version.indexOf("MAC");') == -1) {
			if(flashIsTextEditor()) {
				uri = getMacPath(name);
		 		MMExecute('fl.openScript("' + uri + '");');;
			} else {
				uri = getWinPath(name);
		 		MMExecute("FileIo.open('" + uri + "');");
		 	}
		}
		else {
			uri = getMacPath(name);
	 		MMExecute('fl.openScript("' + uri + '");');;
		}
	}

	public function getWinPath(suffix:String):String {
		var flaUri:String = MMExecute("fl.getDocumentDOM().path");
		var dPath = flaUri.split(Sys.getFileSeparator());
		var sPath = suffix.split("/");
		dPath.pop();
		dPath = dPath.join("\\\\") + "\\\\" + sPath.join("\\\\");
		dPath = dPath.split(" ").join("\\ ");
		return dPath;
	}

	public function getMacPath(suffix:String):String {
		return getCurrentUri(suffix);
	}

	public function getCurrentUri(suffix:String):String {
		var flaUri:String = MMExecute("fl.getDocumentDOM().path");
		var dPath = flaUri.split(Sys.getFileSeparator());
		dPath.pop();
		dPath = dPath.join("/")
		// Perform Windows Colonoscopy
		if(dPath.charAt(1) == ":") {
			dPath = dPath.substring(0,1) + "|" + dPath.substring(2);
		}
		return "file:///" + dPath + "/" + suffix;
	}

	public function getTestNumberOutput():String {
		return successes + " out of " + items.length + " Asserts passed.\n";
	}

	public function refreshOutput() {
		output_txt.text = getFirstLine();
		output_txt.text += "\n" + getTestResultString();
		bar_mc.setSuccess((failures == 0));
		if(intervalId == undefined) {
			intervalId = setInterval(this, "scrollDown", 100);
		}
	}

	public function scrollDown():Void {
		output_txt.vPosition = output_txt.maxVPosition;
		clearInterval(intervalId);
		delete intervalId;
	}

	public function addTests(arr:Array) {
		if(items == undefined) {
			items = new Array();
		}
		for(var i = 0; i < arr.length; i++) {
			items.push(arr[i]);
		}
		refreshOutput();
	}
}
