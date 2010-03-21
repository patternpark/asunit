package asunit.util {

    [ExcludeClass]
    public interface Iterator {
        function next():*;
        function hasNext():Boolean;
        function reset():void;
        function get length():uint;
    }
}
