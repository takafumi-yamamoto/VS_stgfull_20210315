public class ObHokoSm implements IObHokoSm{
    public interface IObHokoSm {
        AcrtSmsSender.Req createAcrtSmsSenderReq(Req pReq);
    }

    public static String m_MsgType = 'ObHokoSm';
    private static SmsTemplates.Template m_Template = new SmsTemplates().getTemplate(m_MsgType);
    private IOppDataPvdr mOppDataPvdr = null;

    public ObHokoSm(IOppDataPvdr pOppDataPvdr){
        this.mOppDataPvdr = pOppDataPvdr;
    }

    public class Req{
        public String account_id = null;
        public String account_name = '';
        public String telno = '';
        public String opp_id = null;
        public String pdf_url  = '';
        public String pdf_password  = '';
    }

    public AcrtSmsSender.Req createAcrtSmsSenderReq(Req pReq){

        OppData theOppData = this.mOppDataPvdr.getOppData(pReq.opp_id);

        String the_plan_shubetsu = '';

        if( OboPlanKeitais.isSogi(theOppData.oboPlan) ){
            the_plan_shubetsu = 'ご葬儀';
        }else if( OboPlanKeitais.isKaimyo(theOppData.oboPlan) ){
            the_plan_shubetsu = '戒名授与';
        }else{
            the_plan_shubetsu = 'ご法要';
        }

        String theBody = m_Template.getBody()
            .replace('{お客様.姓}', pReq.account_name)
            .replace('{商談番号}', theOppData.shodan_Bango)
            .replace('{url}', pReq.pdf_url)
            .replace('{password}', pReq.pdf_password)
            .replace('{プラン種別}', the_plan_shubetsu)
            ;

        return new AcrtSmsSender.Req()
            .set_telno(pReq.telno)
            .set_text_long(theBody)
            .set_shorten_url(true)
            .set_user_ref(null)
            .set_msg_type(m_MsgType)
            .set_msg_meta_data(null)
            .set_account_id(pReq.account_id)
            .set_opp_id(pReq.opp_id);
    }

    public class OppData{
        public String shodan_Bango = '';
        public String oboPlan = '';
    }
    public interface IOppDataPvdr {
        OppData getOppData(String pOppId);
    }
    public class OppDataPvdr implements IOppDataPvdr{
        public OppData getOppData(String pOppId){
            Opportunity theOpp =
            [
                SELECT Id, 
                ShodanBango__c,
                ObosanbinRef__r.MemorialServicePlan__c
                FROM Opportunity
                WHERE Id = :pOppId
                LIMIT 1
            ].get(0);

            OppData theOppData = new OppData();
            theOppData.shodan_Bango = theOpp.ShodanBango__c;
            theOppData.oboPlan = theOpp.ObosanbinRef__r.MemorialServicePlan__c;
            return theOppData;
        }
    }

    public class DlrHdlr implements AcrtDrResultHdlr.IAcrtDrResultHdlr{

        public void handleAcrtDrResult(AcrtDrResultQms.Data pData){
    
            Boolean isDeliveryFailed =
                pData.isExpired || 
                pData.Result_Code == AcrtApiSmsDr.result_code_undelivered ||
                pData.Result_Code == AcrtApiSmsDr.result_code_unknown_subscriber;
    
            if(isDeliveryFailed){
                AcrtDrTack__c theAcrtDrTack = (AcrtDrTack__c)SobjectsExtension.firstOrNull([
                    SELECT Id,
                    send_dt__c,
                    OppRef__c,
                    OppRef__r.ShodanBango__c
                    FROM AcrtDrTack__c
                    WHERE Id = :pData.AcrtDrTack_Id
                    LIMIT 1
                ]);
    
                ObHokoSmDlrErrMl.Req theMailReq = new ObHokoSmDlrErrMl.Req();
                theMailReq.SendDate = theAcrtDrTack.send_dt__c == null ? '' : theAcrtDrTack.send_dt__c.format('yyyy/MM/dd HH:mm');
                theMailReq.ShodanBango = String.isBlank(theAcrtDrTack.OppRef__r.ShodanBango__c) ? '' : theAcrtDrTack.OppRef__r.ShodanBango__c;
                theMailReq.ShodanId = theAcrtDrTack.OppRef__c;
                
                INSERT New ObHokoSmDlrErrMl().createMail(theMailReq);
            }
        }
    }
}