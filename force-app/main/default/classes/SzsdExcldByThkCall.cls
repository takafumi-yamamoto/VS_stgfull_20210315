public class SzsdExcldByThkCall {

    public static IToExclude_Hantei_By_ThankYouCall get_IToExclude_Hantei_By_ThankYouCall_instance(){
        return new ToExclude_Hantei_By_ThankYouCall(
            new No_SozokuAnnnai_But_Shirgiku()
        );
    }

    public enum ExcludeReason{
        ThankCall_Not_Exixts,
        Not_Annnai_Taisho,
        Sozoku_Miannnai_But_Shirgiku,
        Okotowari
    }

    public interface IToExclude_Hantei_By_ThankYouCall {
        Set<ExcludeReason> get_reason_to_exclude_by_oppId(String p_opp_id, Boolean p_is_hakkou_shijji_directly);
    }
    public class ToExclude_Hantei_By_ThankYouCall implements IToExclude_Hantei_By_ThankYouCall{

        private INo_SozokuAnnnai_But_Shirgiku m_INo_SozokuAnnnai_But_Shirgiku;
        public ToExclude_Hantei_By_ThankYouCall(
            INo_SozokuAnnnai_But_Shirgiku p_INo_SozokuAnnnai_But_Shirgiku
        ){
            this.m_INo_SozokuAnnnai_But_Shirgiku = p_INo_SozokuAnnnai_But_Shirgiku;
        }

        public Set<ExcludeReason> get_reason_to_exclude_by_oppId(String p_opp_id, Boolean p_is_hakkou_shijji_directly){
            Set<ExcludeReason> the_reasons = new Set<ExcludeReason>();

            SgThkCall__c a_SgThkCall = (SgThkCall__c)SobjectsExtension.firstOrNull(
                this.select_SgThkCall_by_opp_id(p_opp_id)
            );

            if(a_SgThkCall == null){
                the_reasons.add( ExcludeReason.ThankCall_Not_Exixts );
            }
            if( the_reasons.size() > 0 ){ return the_reasons; }

            if( this.is_okotowari( a_SgThkCall ) ){
                the_reasons.add( ExcludeReason.Okotowari );
            }
            if( this.is_Not_Annnai_Taisho( a_SgThkCall ) ){
                the_reasons.add( ExcludeReason.Not_Annnai_Taisho );
            }

            if( !p_is_hakkou_shijji_directly ){
                if( this.m_INo_SozokuAnnnai_But_Shirgiku.is_sozoku_miannai_but_shiragiku( a_SgThkCall ) ){
                    the_reasons.add( ExcludeReason.Sozoku_Miannnai_But_Shirgiku );
                }
            }

            return the_reasons;
        }

        public List<SgThkCall__c> select_SgThkCall_by_opp_id(String p_opp_id){
            return [
                SELECT Id, Status__c,
                (
                    SELECT Id, ServiceKbn__c, CallKekka__c
                    FROM SgThkCallSvcAnnai__r
                )
                FROM SgThkCall__c
                WHERE Sogi_OppRef__c = :p_opp_id
                LIMIT 1
            ];
        }

        public Boolean is_okotowari(SgThkCall__c p_SgThkCall){
            Boolean is_okotowari = false;
            if( p_SgThkCall.Status__c == '完了/コール止め'){
                is_okotowari = true;
            }
            for(SgThkCallSvcAnnai__c aSgThkCallSvcAnnai : p_SgThkCall.SgThkCallSvcAnnai__r){
                if( aSgThkCallSvcAnnai.ServiceKbn__c == '相続相談' && aSgThkCallSvcAnnai.CallKekka__c == 'お断り' ){
                    is_okotowari = true;
                }
            }
            return is_okotowari;
        }

        public Boolean is_Not_Annnai_Taisho(SgThkCall__c p_SgThkCall){
            Boolean is_annnai_taisho = false;
            for(SgThkCallSvcAnnai__c aSgThkCallSvcAnnai : p_SgThkCall.SgThkCallSvcAnnai__r){
                if( aSgThkCallSvcAnnai.ServiceKbn__c == '相続相談' ){
                    is_annnai_taisho = true;
                }
            }
            return !is_annnai_taisho;
        }
    }

    public interface INo_SozokuAnnnai_But_Shirgiku {
        Boolean is_sozoku_miannai_but_shiragiku(SgThkCall__c p_SgThkCall);
    }
    public class No_SozokuAnnnai_But_Shirgiku implements INo_SozokuAnnnai_But_Shirgiku{
        public Boolean is_sozoku_miannai_but_shiragiku(SgThkCall__c p_SgThkCall){

            Boolean is_sozoku_miannnai = true;
            Boolean is_to_shokai_for_shiragiku = false;
            for(SgThkCallSvcAnnai__c aSgThkCallSvcAnnai : p_SgThkCall.SgThkCallSvcAnnai__r){
                if( aSgThkCallSvcAnnai.ServiceKbn__c == '相続相談' && aSgThkCallSvcAnnai.CallKekka__c != '未案内' ){
                    is_sozoku_miannnai = false;
                }
                if( aSgThkCallSvcAnnai.ServiceKbn__c == '香典返し' && aSgThkCallSvcAnnai.CallKekka__c != 'お断り' ){
                    is_to_shokai_for_shiragiku = true;
                }
            }

            return is_sozoku_miannnai && is_to_shokai_for_shiragiku;
        }
    }
}