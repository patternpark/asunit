package asunit.util {

    import asunit.util.Iterator;

    [ExcludeClass]
    public class ArrayIterator implements Iterator {
        private var items:Array;
        private var index:Number = 0;

        public function ArrayIterator(items:Array=null) {
            this.items = items || [];
        }

        public function hasNext():Boolean {
            return items[index] != null;
        }

        public function next():* {
            return items[index++];
        }

        public function get length():uint {
            return items.length;
        }

        public function reset():void {
            index = 0;
        }
    }
}
