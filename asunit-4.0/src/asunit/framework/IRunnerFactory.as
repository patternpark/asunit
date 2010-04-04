package asunit.framework {

    public interface IRunnerFactory {
        function runnerFor(testOrSuite:Class):IRunner;
    }
}

