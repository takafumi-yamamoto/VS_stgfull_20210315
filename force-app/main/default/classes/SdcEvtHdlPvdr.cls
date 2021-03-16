public class SdcEvtHdlPvdr {

    public static ResolveHandlerResult resolveHandler(String pMsgType){

        ResolveHandlerResult theResult = new ResolveHandlerResult();

        if( !String.isBlank(pMsgType) && getHandlerMap().containsKey(pMsgType) ){
            theResult.handlerClassName = getHandlerMap().get(pMsgType);
            theResult.handler = (IHdlSdcEvt)Type.forName( theResult.handlerClassName ).newInstance();
        }
        return theResult;
    }

    public class ResolveHandlerResult{
        public String handlerClassName;
        public IHdlSdcEvt handler;
    }

    private static Map<String, String> getHandlerMap(){
        if( cachedHandlerMap == null ) loadHandlerMap();
        return cachedHandlerMap;
    }
    private static Map<String, String> cachedHandlerMap = null;

    private static void loadHandlerMap(){
        Map<String, String> theEntries = new Map<String, String>();
        for( SdcEvtHdlMap__mdt aEntry : [ SELECT DeveloperName, HandlerClassName__c FROM SdcEvtHdlMap__mdt ] )
        {
            if( String.isBlank(aEntry.HandlerClassName__c) ) continue;
            theEntries.put( aEntry.DeveloperName, aEntry.HandlerClassName__c );
        }
        cachedHandlerMap = theEntries;
    }
}