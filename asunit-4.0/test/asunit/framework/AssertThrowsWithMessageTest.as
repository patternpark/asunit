package asunit.framework {

    import asunit.asserts.*;
	import asunit.errors.AssertionFailedError;

    public class AssertThrowsWithMessageTest {

        [Test]
		public function throwingExpectedErrorShouldPass():void {
			assertThrowsWithMessage(ArgumentError, "foo", function():void { throw new ArgumentError("foo"); } );
		}
		
        [Test]
		public function throwingUnexpectedErrorShouldFail():void {
			try {
				assertThrowsWithMessage(ArgumentError, "wrong error type", function():void { throw new Error("wrong error type"); } );
			}
			catch (e:AssertionFailedError) {
				assertEquals("expected error type:<ArgumentError> but was:<Error>", e.message)
				return;
			}
			fail('failed assertThrowsWithMessage() should have thrown AssertionFailedError');
		}
		
        [Test]
		public function throwingNoErrorShouldFailWithMessage():void {
			try {
				assertThrowsWithMessage(ArgumentError, "foo", function():void { } );
			}
			catch (e:AssertionFailedError) {
				assertEquals("expected error type:<ArgumentError> with message:<foo> but none was thrown.", e.message)
				return;
			}
			fail('failed assertThrowsWithMessage() should have thrown AssertionFailedError');
		}

        [Test]
		public function throwingErrorWithUnexpectedMessageShouldFail():void {
			try {
				assertThrowsWithMessage(Error, "foo", function():void { throw new Error("bar"); } );
			}
			catch (e:AssertionFailedError) {
				assertEquals("expected error message:<foo> but was:<bar>", e.message)
				return;
			}
			fail('failed assertThrowsWithMessage() should have thrown AssertionFailedError');
		}
	}
}

