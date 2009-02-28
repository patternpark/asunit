interface asunit.runner.TestSuiteLoader {
	// throws ClassNotFoundException
	function load(suiteClassName:String):Function;
	// throws ClassNotFoundException
	function reload(aClass:Function):Function;
}