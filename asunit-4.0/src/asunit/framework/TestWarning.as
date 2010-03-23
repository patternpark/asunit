package asunit.framework {

    public class TestWarning implements ITestWarning {

        private var _message:String;
        private var _method:Method;

        public function TestWarning(message:String, method:Method=null) {
            _message = message;
            _method = method;
        }

        public function set message(message:String):void {
            _message = message;
        }

        public function get message():String {
            return _message;
        }

        public function set method(method:Method):void {
            _method = method;
        }

        public function get method():Method {
            return _method;
        }

        public function toString():String {
            if(method) {
                return "[WARNING] " + method + " : " + message;
            }
            else {
                return "[WARNING] " + message;
            }
        }
    }
}


