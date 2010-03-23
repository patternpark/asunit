package asunit.support {

    import asunit.asserts.*;
    import asunit.framework.IAsync;
    import flash.utils.Dictionary;

    public class AnnotatedSuperClass {

        [Inject]
        public var async:IAsync;

        [Inject]
        public var dictionary:Dictionary;
    }
}
