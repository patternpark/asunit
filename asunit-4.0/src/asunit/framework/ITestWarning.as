package asunit.framework {

    public interface ITestWarning {

        function set message(message:String):void;
        function get message():String;

        function set method(method:Method):void;
        function get method():Method;

        function toString():String;
    }
}

