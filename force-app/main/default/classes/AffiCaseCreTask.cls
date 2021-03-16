public class AffiCaseCreTask implements Queueable{

    //AsyncBegin
    public AffiCaseCreTask(Id pTaskId){ this.f_TaskId = pTaskId; }
    private Id f_TaskId = null;
    public void runTask(Id pTaskId){
        AffiCaseCreTask__c theTask = (AffiCaseCreTask__c)SobjectsExtension.firstOrNull(
            [
                select 
                Id, data__c, parent_mailshori_id__c
                from AffiCaseCreTask__c 
                where Id = :pTaskId
                limit 1
            ]
        );
        if(theTask == null){
            theTask.ShoriStatus__c = 'Completed'; 
            Update theTask;
            return;
        }
        if(String.isBlank(theTask.parent_mailshori_id__c)){
            theTask.ShoriStatus__c = 'Faulted'; 
            Update theTask;
            return;
        }

        try{

            Case theAffiliateCase = new AffiCaseBuilder().getAffiCase(theTask.data__c);
            if( theAffiliateCase == null ){
                theTask.ShoriStatus__c = 'Created';
                theTask.DefferedUntil__c = Datetime.now().addMinutes(5);
                Update theTask;
                return;
            }

            Insert theAffiliateCase;

            theTask.ShoriStatus__c = 'Completed'; 
            Update theTask;

        } catch (Exception e){
            theTask.ShoriStatus__c = 'Faulted'; 
            Update theTask;
            System.Debug( e.getMessage() );
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20180906-1600-02', 'AffiCaseCre')
                    .setSubjectRecordId(theTask.Id)
                    .putAttr( 'e.getMessage()', e.getMessage() )
            );
            return;
        }

    }

    public void execute(QueueableContext context) {
        this.runTask( this.f_TaskId );
    }
    //AsyncEnd

    private class AffiCaseBuilder {

        public Case getAffiCase(String pAffiliateCaseData){
            Data theData = (Data)JSON.deserialize(pAffiliateCaseData, Data.class);

            Boolean theParentIsNone = theData.parent_mailshori_id == 'none';
            Id theParentCaseId = null;
            if(!theParentIsNone){
                theParentCaseId = this.getParentId(theData.parent_mailshori_id);
                if( theParentCaseId == null ){
                    return null; //continue next
                }
            }

            Case newCase = new Case();

            newCase.RecordTypeId                                = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','affiliate');
            newCase.Status                                      = '新規';
            newCase.Origin                                      = 'Web';
            newCase.GaClientId__c                               = theData.gaclient_id;
            newCase.uniq_id__c                                  = theData.mailshori_id;
            newCase.ToiawaseDate__c                             = Com_Utility.toDateTime(theData.toiawase_date);
            newCase.Lastname__c                                 = theData.cust_name_sei;
            newCase.Firstname__c                                = theData.cust_name_mei;
            newCase.LastNameKana__c                             = theData.cust_name_sei_kana;
            newCase.FirstNameKana__c                            = theData.cust_name_mei_kana;

            newCase.MailAddress__c                              = theData.mail_address; 
            if(Com_Utility.isMobile(theData.tel_no)) {
                newCase.KeitaiDenwa__c       = theData.tel_no;
            }
            else{
                newCase.TelNo__c             = theData.tel_no;
            }
            newCase.PostalCode__c                               = theData.postal_code;
            newCase.State__c                                    = theData.state;
            newCase.City__c                                     = theData.city;
            newCase.Street__c                                   = theData.street;
            newCase.OkyakusamaCommnet__c                        = theData.cust_comment;
            newCase.AffiliateSoukyakuSaki__c                    = theData.service;
            newCase.parent_mailshori_id__c                      = (theParentIsNone ? null : theData.parent_mailshori_id);
            newCase.ParentId                                    = theParentCaseId;
            return newCase;
        }


        public Id getParentId(String parent_mailshori_id){
            if(String.isBlank(parent_mailshori_id)) return null;
            List<Case> pcase = [Select Id From Case Where uniq_id__c = :parent_mailshori_id];
            if(pcase != null && pcase.size() > 0){
                return pcase[0].Id;
            } else {
                return null;
            }
        }

    }

    public class Data{
        public String gaclient_id { get; set; }                    // GaClientId
        public String mailshori_id { get; set; }                    // メール処理Id
        public String parent_mailshori_id { get; set; }                 // 親メール処理Id
        public String toiawase_date { get; set; }                   // 問合せ日
        public String cust_name_sei { get; set; }                   // お客様名.姓
        public String cust_name_mei { get; set; }                   // お客様名.名
        public String cust_name_sei_kana { get; set; }                  // お客様名.姓カナ
        public String cust_name_mei_kana { get; set; }                  // お客様名.名カナ
        public String mail_address { get; set; }                    // メール
        public String tel_no { get; set; }                  // 電話番号
        public String postal_code { get; set; }                 // 郵便番号
        public String state { get; set; }                   // 都道府県
        public String city { get; set; }                    // 市区郡
        public String street { get; set; }                  // 町名番地
        public String cust_comment { get; set; }                    // お客様コメント
        public String service { get; set; }                 // アフィリエイト送客先
    }

}