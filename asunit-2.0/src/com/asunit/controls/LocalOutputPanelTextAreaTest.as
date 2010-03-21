
import com.asunit.controls.*;
import com.asunit.framework.*;

class LocalOutputPanelTextAreaTest extends TestCase {
	private var className:String = "com.asunit.controls.LocalOutputPanelTextAreaTest";
	private var testInstance:LocalOutputPanelTextArea;

	public function setUp():Void {
		var dpth:Number = getValidDepth(_root);
		testInstance = LocalOutputPanelTextArea(_root.attachMovie(LocalOutputPanelTextArea.linkageId, "textArea_" + dpth, dpth));
	}

	public function tearDown():Void {
		testInstance.removeMovieClip();
 	}

 	public function testInstantiated():Void {
		assertTrue("LocalOutputPanelTextArea instantiated", testInstance instanceof LocalOutputPanelTextArea);
	}
	
	public function testMessage():Void {
		testInstance.text = "hello world";
		assertTrue("text retrieves", (testInstance.text == "hello world"));
	}
}
