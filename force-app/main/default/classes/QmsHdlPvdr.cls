public class QmsHdlPvdr {

	public static ResolveHandlerResult resolveHandler(String pMsgType){

		ResolveHandlerResult theResult = new ResolveHandlerResult();

		if( !String.isBlank(pMsgType) && getHandlerMap().containsKey(pMsgType) ){
			theResult.handlerClassName = getHandlerMap().get(pMsgType);
			theResult.handler = (IHdlQms)Type.forName( theResult.handlerClassName ).newInstance();
		}
		return theResult;
	}

	public class ResolveHandlerResult{
		public String handlerClassName;
		public IHdlQms handler;
	}

	private static Map<String, String> getHandlerMap(){ 
		if( cachedHandlerMap == null ) loadHandlerMap();
		return cachedHandlerMap; 
	}
	private static Map<String, String> cachedHandlerMap = null;

	private static void loadHandlerMap(){
		Map<String, String> theEntries = new Map<String, String>();
		for( QmsHdlPvdrHandlerMap__mdt aEntry : [ SELECT DeveloperName, HandlerClassName__c FROM QmsHdlPvdrHandlerMap__mdt ] )
		{
			if( String.isBlank(aEntry.HandlerClassName__c) ) continue;
			theEntries.put( aEntry.DeveloperName, aEntry.HandlerClassName__c );
		}
		cachedHandlerMap = theEntries;
	}
}