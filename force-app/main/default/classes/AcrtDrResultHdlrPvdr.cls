public class AcrtDrResultHdlrPvdr {

    public interface IAcrtDrResultHdlrPvdr {
        ResolveHandlerResult resolveHandler(String pMsgType);
    }
	public class ResolveHandlerResult{
		public String handlerClassName;
		public AcrtDrResultHdlr.IAcrtDrResultHdlr handler;
    }
    
	private static Map<String, String> getHandlerMap(){ 
		if( cachedHandlerMap == null ) loadHandlerMap();
		return cachedHandlerMap; 
	}
	private static Map<String, String> cachedHandlerMap = null;

	private static void loadHandlerMap(){
		Map<String, String> theEntries = new Map<String, String>();
		for( AcrtDrResultHdlr__mdt aEntry : [ SELECT DeveloperName, HandlerClassName__c FROM AcrtDrResultHdlr__mdt ] )
		{
			if( String.isBlank(aEntry.HandlerClassName__c) ) continue;
			theEntries.put( aEntry.DeveloperName, aEntry.HandlerClassName__c );
		}
		cachedHandlerMap = theEntries;
    }

    public class Provider implements IAcrtDrResultHdlrPvdr{
        public ResolveHandlerResult resolveHandler(String pMsgType){

            ResolveHandlerResult theResult = new ResolveHandlerResult();

            if( !String.isBlank(pMsgType) && AcrtDrResultHdlrPvdr.getHandlerMap().containsKey(pMsgType) ){
                theResult.handlerClassName = AcrtDrResultHdlrPvdr.getHandlerMap().get(pMsgType);
                theResult.handler = (AcrtDrResultHdlr.IAcrtDrResultHdlr)Type.forName( theResult.handlerClassName ).newInstance();
            }
            return theResult;
        }
    }
}