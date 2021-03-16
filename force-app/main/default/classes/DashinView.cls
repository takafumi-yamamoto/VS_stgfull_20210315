public class DashinView {
  // 商談画面にはめ込んでいる打診画面情報Start
    @AuraEnabled
    public static DataContext doInit(String recordId) {
        List<Opportunity> oppList = [SELECT DashIraiRef__c,
        									 DashIraiRef__r.DashinIraiNichiji__c ,
        									 toLabel(DashIraiRef__r.Status__c) ,
        									 DashIraiRef__r.StatusDescr__c
        							  FROM Opportunity WHERE ID =: recordId];
        if(oppList.size() == 0) return null;
        if(oppList[0].DashIraiRef__c == null) return null;
        return toDataContext(oppList[0].DashIraiRef__r);
    }

    public class DataContext {
        @AuraEnabled public String DashIraiRef {get; set;}
        @AuraEnabled public datetime DashinIraiNichiji {get; set;}
        @AuraEnabled public String Status {get; set;}
        @AuraEnabled public String StatusDescr {get; set;}
        @AuraEnabled public String LabelDashinIraiNichiji {get; set;}
        @AuraEnabled public String LabelStatus {get; set;}
        @AuraEnabled public String LabelStatusDescr {get; set;}
        @AuraEnabled public String LabelResult {get; set;}
    }

    public static DataContext toDataContext(DashIrai__c sobj) {
        DataContext row = new DataContext();
		row.DashIraiRef = sobj.Id;
		row.DashinIraiNichiji = sobj.DashinIraiNichiji__c;
		row.Status = sobj.Status__c;
		row.StatusDescr = sobj.StatusDescr__c;

        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('DashIrai__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        row.LabelDashinIraiNichiji = fieldMap.get('DashinIraiNichiji__c').getDescribe().getLabel();
        row.LabelStatus = fieldMap.get('Status__c').getDescribe().getLabel();
        row.LabelStatusDescr = fieldMap.get('StatusDescr__c').getDescribe().getLabel();

        return row;
    }
  // 商談画面にはめ込んでいる打診画面情報END


  // 打診キャンセル機能Start
    // 打診先送信結果
    public class OfferCancelResult {
        @AuraEnabled public String resultCode;
        @AuraEnabled public List<String> errMsgs = new List<String>();
        public OfferCancelResult setResultCode(String presultCode){ this.resultCode = presultCode; return this; }
        public OfferCancelResult addErrorMsg(String pErrMsg){ this.errMsgs.add(pErrMsg); return this; }
        public OfferCancelResult addErrorMsg( List<String> pErrMsgs ){ this.errMsgs.addAll(pErrMsgs); return this; }
    }

    @AuraEnabled
    public static OfferCancelResult doOfferCancel(String recordId) {
        List<Opportunity> oppList = [SELECT DashIraiRef__c, DashIraiRef__r.offer_id__c, DashIraiRef__r.Status__c FROM Opportunity WHERE ID =: recordId LIMIT 1];

        if(     oppList.size() == 0
            ||  oppList[0].DashIraiRef__r.offer_id__c == null
            ||  oppList[0].DashIraiRef__r.Status__c != 'Opened'
            ){
            return new OfferCancelResult()
                        .setResultCode('error_unhandled')
                        .addErrorMsg('打診商談情報エラー')
                        .addErrorMsg(oppList[0].DashIraiRef__r.offer_id__c + '')
                        .addErrorMsg(oppList[0].DashIraiRef__r.Status__c);
        }

        OboStApi_OfferCancel.ReqBody pReqBody = new OboStApi_OfferCancel.ReqBody();
        try{
            pReqBody.id = oppList[0].DashIraiRef__r.offer_id__c.intValue();
            OboStApi_OfferCancel.Result result = new OboStApi_OfferCancel().sendRequest(pReqBody);
            if(result.isSuccess) {
                update new DashIrai__c(Id=oppList[0].DashIraiRef__c, Status__c='CANCELED');
                update new Opportunity(Id=recordId, SubPhase__c='僧侶手配（自動打診）');
                return new OfferCancelResult().setResultCode('success');
            } else {
                return new OfferCancelResult()
                            .setResultCode('error_unhandled')
                            .addErrorMsg('doOfferCancelエラー')
                            .addErrorMsg(result.descr+ '')
                            .addErrorMsg(result.endPoint+ '')
                            .addErrorMsg(result.statusCode+ '')
                            .addErrorMsg(result.reqBodyRaw+ '')
                            .addErrorMsg(result.resBodyRaw + '');
            }
        }catch(Exception e){
            Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Error, '20190614-1600-01', 'DashinController.doSendDashinIrai')
                    .putAttr( 'e.getMessage()', e.getMessage() )
                    .putAttr( 'e.getLineNumber()', String.valueOf(e.getLineNumber())  )
                    .putAttr( 'e.getStackTraceString()', e.getStackTraceString() )
            );
            return new OfferCancelResult().setResultCode('error_unhandled')
                        .addErrorMsg(e.getMessage())
                        .addErrorMsg(oppList[0].DashIraiRef__r.offer_id__c+'');
        }

    }
  // 打診キャンセル機能End
}