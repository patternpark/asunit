
import com.asunit.framework.*;

class com.asunit.framework.TestFailure extends Assertion implements Test {

	public var output:String = "F";
	public var success:Boolean = false;

	public function TestFailure(cName:String, mName:String, msg:String, assertion:String)
	{
		super(cName, mName, msg, assertion);
		output = "F";
		success = false;
	}
}