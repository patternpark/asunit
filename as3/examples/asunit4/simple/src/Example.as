package {
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import skins.ExampleSkin;
	
	public class Example extends Sprite {

		public function Example() {
			addChild(new ExampleSkin.ProjectSprouts() as DisplayObject);
			trace("Example instantiated!");
		}
	}
}
