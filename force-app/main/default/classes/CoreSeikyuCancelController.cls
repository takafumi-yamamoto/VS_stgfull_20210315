public class CoreSeikyuCancelController {

    public class CancelResult{
        @AuraEnabled public Boolean is_success = false;
        @AuraEnabled public String sf_record_id = '';
        @AuraEnabled public String seikyubango = '';
        @AuraEnabled public String descr = '';
    }

    private class Processor{
        public CancelResult processCancel(String pRecordId) {
            CancelResult theCancelResult = new CancelResult();
            
            OkyakusamaSeikyuMeisai__c theSeikyu =
            [
                select id, SeikyuBango__c,IsSeikyuOyaExp__c,SeikyuStatus__c,
                (select id from Seikyukos__r)
                from OkyakusamaSeikyuMeisai__c
                where Id = :pRecordId
            ].get(0);

            theCancelResult.sf_record_id = theSeikyu.Id;
            theCancelResult.seikyubango = theSeikyu.SeikyuBango__c;

            if(!theSeikyu.IsSeikyuOyaExp__c){
                theCancelResult.is_success = false;
                theCancelResult.descr = '請求子はキャンセルできません。';
                return theCancelResult;
            }
            if(theSeikyu.SeikyuStatus__c == '売上確定済'){
                theCancelResult.is_success = false;
                theCancelResult.descr = '売上確定済みの請求はキャンセルできません。';
                return theCancelResult;
            }

            RsCoreApi_Kessai_Cancel.ReqArgs theReqArgs = new RsCoreApi_Kessai_Cancel.ReqArgs();
            theReqArgs.seikyuBango = theSeikyu.SeikyuBango__c;
            RsCoreApi_Kessai_Cancel.Result theApiResult = new RsCoreApi_Kessai_Cancel.Agent().sendRequest(theReqArgs);

            if( theApiResult.isError ){
                theCancelResult.is_success = false;
                theCancelResult.descr = 'error occured in api call.';
                return theCancelResult;
            }

            List<OkyakusamaSeikyuMeisai__c> theSeikyuMeisaisToBeDeleted = new List<OkyakusamaSeikyuMeisai__c>();

            theSeikyuMeisaisToBeDeleted.add(theSeikyu);
            for(OkyakusamaSeikyuMeisai__c aMeisai : theSeikyu.Seikyukos__r){
                theSeikyuMeisaisToBeDeleted.add(aMeisai);
            }
            OkyakusamaSeikyuMeisaiCrudPolicy.DeleteInNoPolicy( theSeikyuMeisaisToBeDeleted );
            theCancelResult.is_success = true;
            return theCancelResult;
        }
    }
    @AuraEnabled
    public static CancelResult processCancel(String pRecordId) {
            CancelResult theResult = new CancelResult();
            theResult.is_success = false;
        try{
            theResult = new Processor().processCancel(pRecordId);
        }catch(Exception e){
            theResult.is_success = false;
            theResult.descr = e.getMessage();
            System.Debug(theResult.descr);
        }

        if( theResult.is_success ) logSuccess(theResult);
        if( !theResult.is_success ) logError(theResult);
        return theResult;
    }

    private static void logError(CancelResult pResult){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error,'20180607-1149-01', 'CoreKessai.CancelSeikyu','請求キャンセル処理中にエラー')
                    .putAttr('sf_record_id', pResult.sf_record_id)
                    .putAttr('seikyubango', pResult.seikyubango)
                    .putAttr('descr', pResult.descr)
            );
    }
    private static void logSuccess(CancelResult pResult){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Info,'20180607-1149-02', 'CoreKessai.CancelSeikyu','請求キャンセル処理中成功')
                    .putAttr('sf_record_id', pResult.sf_record_id)
                    .putAttr('seikyubango', pResult.seikyubango)
                    .putAttr('descr', pResult.descr)
            );
    }

}