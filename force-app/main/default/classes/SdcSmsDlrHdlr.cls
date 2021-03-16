public class SdcSmsDlrHdlr {
    public void onSmsDlrAfterInsert(List<SmsDlr__c> pSmsDlrs) {
        try {
            Map<String, SmsDlr__c> smsDlrMap = new Map<String, SmsDlr__c>();
            for(SmsDlr__c smsDlr : pSmsDlrs){
                if(String.isNotBlank(smsDlr.ClientTag__c)){
                    smsDlrMap.put((String)smsDlr.ClientTag__c, smsDlr);
                }
            }
            if(smsDlrMap.size() == 0) return;
            Set<String> clientTags = smsDlrMap.keySet();

            List<Qms__c> theSdcHdlSmsDlrQmses = new List<Qms__c>();
            for(SdcMsg__c sdcMsg : [
                    SELECT  Id, ClientTag__c
                    FROM SdcMsg__c
                    WHERE ClientTag__c = :clientTags
            ]){
                String theSmsDlrId = smsDlrMap.get(sdcMsg.ClientTag__c).Id;
                String theSdcMsgId = sdcMsg.Id;
                theSdcHdlSmsDlrQmses.add(
                    SdcHdlSmsDlrQms.CreateQmsAsRoot(theSmsDlrId, theSdcMsgId)
                );
            }
            if( theSdcHdlSmsDlrQmses.size() > 0 ) INSERT theSdcHdlSmsDlrQmses;
        } catch(Exception e) {
            Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Error, '20190828-1600-01', 'SdcSmsDlrHdlr.onSmsDlrAfterInsert')
                    .putAttr( 'e.getMessage()', e.getMessage() )
                    .putAttr( 'e.getLineNumber()', String.valueOf(e.getLineNumber())  )
                    .putAttr( 'e.getStackTraceString()', e.getStackTraceString() )
            );
        }
    }
}