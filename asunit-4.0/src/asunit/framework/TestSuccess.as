package asunit.framework {
	import flash.utils.getQualifiedClassName;

    /**
     * @see Result
     */
    public class TestSuccess implements ITestSuccess {
        protected var _test:Object;
        protected var _method:String;

        /**
         * Constructs a TestFailure with the given test and exception.
         */
        public function TestSuccess(test:Object, method:String) {
            _test = test;
            _method = method;
        }

        public function get feature():String {
            return getQualifiedClassName(_test) + '.' + _method;
        }

        public function get test():Object {
            return _test;
        }
		
        public function get method():String {
            return _method;
        }

        /**
         * Returns a short description of the success.
         */
        public function toString():String {
            return "[TestSuccess " + method + "]";
        }
    }
}
