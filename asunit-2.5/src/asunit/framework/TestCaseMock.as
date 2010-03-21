
class asunit.framework.TestCaseMock extends MovieClip {
	public static var linkageId:String = "__Packages.asunit.framework.TestCaseMock";
	public static var classRef:Function = TestCaseMock;

	public function TestCaseMock() {
		draw();
	}
	
	public function draw():Void {
		var w:Number = 100;
		var h:Number = 100;
		clear();
		beginFill(0xFFCC00);
		lineTo(w, 0);
		lineTo(w, h);
		lineTo(0, h);
		lineTo(0, 0);
		endFill();		
	}

	public static var serializable:Boolean = Object.registerClass(linkageId, classRef);
}
