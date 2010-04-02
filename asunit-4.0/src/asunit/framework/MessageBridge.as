package asunit.framework {

    /**
     * MessageBridge is a marker interface that is used
     * by AsUnit core in order to support custom messaging
     * schemes between TestObservers and IRunners.
     *
     * The idea is that you [Inject] one or more entities
     * into your concrete IRunner and related TestObservers.
     *
     * The contract is between the concrete MessageBridge,
     * and the other actors that [Inject] it into.
     * 
     * This implementation gives AsUnit the ability to support
     * a variety of messaging protocols including native
     * Flash EventDispatchers, callbacks, and even progressive
     * systems like AS3Signals. The decision as to which
     * messaging system to use is made by the person creating
     * the concrete Runner and Observer.
     */
    public interface MessageBridge {
    }
}

