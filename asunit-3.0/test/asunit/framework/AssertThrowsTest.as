package asunit.framework {
	import asunit.errors.AssertionFailedError;

    public class AssertThrowsTest extends TestCase {

        public function AssertThrowsTest(testMethod:String = null) {
            super(testMethod);
        }
	
		public function test_throwing_correct_error_passes():void {
			assertThrows(ArgumentError, function():void { throw new ArgumentError(); } );
		}
		
		public function test_throwing_incorrect_error_fails_with_expected_message():void {
			try {
				assertThrows(ArgumentError, function():void { throw new Error("wrong error type"); } );
			}
			catch (e:AssertionFailedError) {
				assertEquals("expected error type:<ArgumentError> but was:<Error>", e.message)
				return;
			}
			fail('failed assertThrows() should have thrown AssertionFailedError');
		}
		
		/**
		 * Captures a bug in original assertThrows implementation
		 * where the message when nothing was thrown said "but was:<AssertionFailedError>".
		 */
		public function test_throwing_no_error_fails_with_message_that_none_was_thrown():void {
			try {
				assertThrows(ArgumentError, function():void { } );
			}
			catch (e:AssertionFailedError) {
				assertEquals("expected error type:<ArgumentError> but none was thrown.", e.message)
				return;
			}
			fail('failed assertThrows() should have thrown AssertionFailedError');
		}
		
		
	}
}
