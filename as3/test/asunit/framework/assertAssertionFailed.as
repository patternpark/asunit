package asunit.framework
{
	import asunit.errors.AssertionFailedError;
	import asunit.framework.Assert;
		
	internal function assertAssertionFailed(assertFunction:Function, expected:Array, actual:Array):void {
		var succeded:Boolean = false;
		try {
			assertFunction.apply(null, [expected, actual]);
			succeded = true;
		}
		catch (e:AssertionFailedError) {
			// expected
		}
		if (succeded) {
			Assert.fail("expected AssertionFailedError");
		}
	}
}