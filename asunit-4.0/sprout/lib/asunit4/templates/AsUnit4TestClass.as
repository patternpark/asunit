package <%= package_name %> {
    
    import asunit.asserts.*;
    import asunit.framework.IAsync;
    import flash.display.Sprite;

    public class <%= test_class_name %> {

        [Inject]
        public var async:IAsync;

        [Inject]
        public var context:Sprite;

        private var <%= instance_name %>:<%= class_name %>;

        [Before]
        public function setUp():void {
            <%= instance_name %> = new <%= class_name %>();
        }

        [After]
        public function tearDown():void {
            <%= instance_name %> = null;
        }

        [Test]
        public function shouldBeInstantiated():void {
            assertTrue("<%= instance_name %> is <%= class_name %>", <%= instance_name %> is <%= class_name %>);
        }
    }
}

