public class AcrtDrTackRegister {

    public interface IRegister {
        void InsertEntrries( List<AcrtSmsSender.Result> pAcrtSmsSenderResults);
        void InsertEntry(AcrtSmsSender.Result pAcrtSmsSenderResult);
    }
    public class Register implements IRegister{

        public void InsertEntrries( List<AcrtSmsSender.Result> pAcrtSmsSenderResults){

            Map<String,AcrtDrTack__c> theAcrtDrTacks = new Map<String,AcrtDrTack__c>();
            for(AcrtSmsSender.Result aResult : pAcrtSmsSenderResults){
                if( String.isBlank(aResult.delivery_id) ) continue;

                Datetime theExpiredAt = aResult.send_dt == null ? Datetime.now().addHours(24) : aResult.send_dt.addHours(24);
                AcrtDrTack__c theAcrtDrTack = 
                    new AcrtDrTack__c(
                        delivery_id__c = aResult.delivery_id,
                        msg_type__c = aResult.req.msg_type,
                        msg_meta_data__c = aResult.req.msg_meta_data,
                        text_long__c = aResult.req.text_long,
                        telno__c = aResult.req.telno,
                        AccountRef__c = aResult.req.account_id,
                        OppRef__c = aResult.req.opp_id,
                        send_dt__c = aResult.send_dt,
                        expired_at__c = theExpiredAt,
                        scheduled_at__c = aResult.send_dt
                    );
                theAcrtDrTacks.put( theAcrtDrTack.delivery_id__c, theAcrtDrTack );
            }

            UPSERT theAcrtDrTacks.values() delivery_id__c;
        }

        public void InsertEntry(AcrtSmsSender.Result pAcrtSmsSenderResult){
            this.InsertEntrries( new List<AcrtSmsSender.Result>{ pAcrtSmsSenderResult } );
        }
    }
}