package asunit.framework {


    public interface IRunnerFactory {
		function get injector():InjectionDelegate;
		function set injector(value:InjectionDelegate):void;
        function runnerFor(testOrSuite:Class):IRunner;
    }
}