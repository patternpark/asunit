package asunit.framework {
	import org.swiftsuspenders.Injector;

    public interface IRunnerFactory {
		function get injector():Injector;
		function set injector(value:Injector):void;
        function runnerFor(testOrSuite:Class):IRunner;
    }
}