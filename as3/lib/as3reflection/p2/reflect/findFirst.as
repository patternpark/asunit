package p2.reflect {

    public function findFirst(collection:Array, handler:Function):* {
        var result:*;
        var len:Number = collection.length;
        for(var i:int; i < len; i++) {
            result = collection[i];
            if(handler(result, i, collection)) {
                return result;
            }
        }
    }
}

