package asunit.framework {

    import asunit.asserts.*;
	import asunit.errors.AssertionFailedError;

    public class AssertThrowsTest {

        [Test]
		public function throwingExpectedErrorShouldPass():void {
			assertThrows(ArgumentError, function():void { throw new ArgumentError(); } );
		}
		
        [Test]
		public function throwingUnexpectedErrorShouldFailWithMessage():void {
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
        [Test]
		public function throwingNoErrorShouldFailWithMessage():void {
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

