package asunit.framework {
 
    public class CallbackBridge extends Result {
    	
	    internal function get numListeners():uint {
            return listeners.length;
        }
	
    }
}