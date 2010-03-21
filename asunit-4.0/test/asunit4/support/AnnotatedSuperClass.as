package asunit4.support {

    import asunit.asserts.*;
    import asunit4.async.IAsync;
    import flash.utils.Dictionary;

    public class AnnotatedSuperClass {

        [Inject]
        public var async:IAsync;

        [Inject]
        public var dictionary:Dictionary;
    }
}

