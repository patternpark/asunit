
import com.asunit.framework.*;

class com.asunit.framework.TestResult extends Assertion implements Test {

	public var output:String;
	public var success:Boolean;

	public function TestResult(cName:String, mName:String, msg:String, assertion:String)
	{
		super(cName, mName, msg, assertion);
		output = ".";
		success = true;
	}
}