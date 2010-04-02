package asunit.fixtures {

    [Event(name='customMethodStarted', type='flash.events.Event')]
    [Event(name='customMethodFinished', type='flash.events.Event')]
    public class CustomEventBridge extends EventDispatcher {

        public static const CUSTOM_METHOD_STARTED:String = 'customMethodStarted';
        public static const CUSTOM_METHOD_COMPLETED:String = 'customMethodCompleted';
    }
}

