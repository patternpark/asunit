package p2.reflect {

    /**
     * Parses:
     * <metadata name="BeforeFilter">
     *   <arg key="order" value="1"/>
     * </metadata>
     */
    dynamic public class ReflectionMetaData {

        private var _args:Array;
		private var _xmlDescription:XML;
		private var _name:String;

		public function ReflectionMetaData(xmlDescription:XML) {
			_xmlDescription = xmlDescription;
            // Have to parse args here, because the 
            // args are appended to this instance - there's
            // no getter to trigger the parse:
            _args = parseArgs();
        }

		public function get name():String {
			return _name ||= _xmlDescription.@name;
		}

        public function get xmlDescription():XML {
            return _xmlDescription;
        }

        public function get args():Array {
            return _args;
        }

        public function getValueFor(argumentKey:String):* {
            var found:Object =  findFirst(args, function(item:Object, index:int, items:Array):Boolean {
                return (item.key == argumentKey);
            });
            if(found) {
                return found.value;
            }
            return null;
        }

        public function toString():String {
            return xmlDescription;
        }

        private function parseArgs():Array {
            var items:Array = [];
            var list:XMLList = xmlDescription..arg;
            var item:XML;
            var key:String;
            var value:*;
            for each(item in list) {
                key = item.@key;
                value = item.@value;
                if(key == "") {
                    items.push(value);
                }
                else {
                    items.push({ key: key, value: value });
                }
                this[key] = value;
            }
            return items;
        }
    }
}
