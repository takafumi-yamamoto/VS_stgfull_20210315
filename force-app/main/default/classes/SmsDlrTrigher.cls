public class SmsDlrTrigher {
    public void OnAfterInsert(List<SmsDlr__c> newList) {
        new SdcSmsDlrHdlr().onSmsDlrAfterInsert(newList);
    }
}