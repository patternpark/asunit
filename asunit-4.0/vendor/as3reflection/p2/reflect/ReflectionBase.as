package p2.reflect {

    public class ReflectionBase {

		private var _description:XML;
        private var _metaDataItems:Array;
		private var _name:String;

        public function ReflectionBase(description:*) {
			_description = description;
        }

		public function get name():String {
			return _name ||= description.@name;
		}

        public function get description():XML {
            return _description;
        }

        public function get metaDataItems():Array {
            return _metaDataItems ||= parseMetaDataItems();
        }
		
		public function toString():String {
			return description.toXMLString();
		}

        public function getMetaDataByName(name:String):ReflectionMetaData {
            return findFirst(metaDataItems, function(item:*, index:int, items:Array):Boolean {
                return (item.name == name);
            });
        }

        // Class metadata is stored in a different
        // location from member metadata... Boo.
        protected function getRawMetaData():XMLList {
            return description.metadata;
        }

        private function parseMetaDataItems():Array {
            var items:Array = [];
            var list:XMLList = getRawMetaData();
            var item:XML;
            for each(item in list) {
                items.push(new ReflectionMetaData(item));
            }
            return items;
        }
    }
}

