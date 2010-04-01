package asunit.errors {
    
    public class UsageError extends Error {
        
        public function UsageError(message:String) {
            super(message);
            name = "UsageError";
        }    
    }
}

