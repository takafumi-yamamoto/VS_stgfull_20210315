public class ObHokoMl implements IObHokoMl{
    public interface IObHokoMl {
        MailAlert__c createMail(Req pReq);
    }

    public static String m_MsgType = 'ObHokoMl';
    private static MailTemplates.Template m_Template = new MailTemplates().getTemplate(m_MsgType);
    private IOppDataPvdr mOppDataPvdr = null;
    
    public ObHokoMl(IOppDataPvdr pOppDataPvdr){
        this.mOppDataPvdr = pOppDataPvdr;
    }

    public class Req{
        public String account_id = null;
        public String account_name = '';
        public String mailaddress = '';
        public String opp_id = null;
        public String pdf_url  = '';
        public String pdf_password  = '';
    }

    public MailAlert__c createMail(Req pReq){

        MailAlert__c theMailAlert = new MailAlert__c();
        MailAlerts.applyTemplate(m_Template, theMailAlert);

        OppData theOppData = this.mOppDataPvdr.getOppData(pReq.opp_id);

        String the_plan_shubetsu = '';

        if( OboPlanKeitais.isSogi(theOppData.oboPlan) ){
            the_plan_shubetsu = 'ご葬儀';
        }else if( OboPlanKeitais.isKaimyo(theOppData.oboPlan) ){
            the_plan_shubetsu = '戒名授与';
        }else{
            the_plan_shubetsu = 'ご法要';
        }
    
        theMailAlert.Body__c = theMailAlert.Body__c
            .replace('{お客様.姓}', pReq.account_name)
            .replace('{商談番号}', theOppData.shodan_Bango)
            .replace('{url}', pReq.pdf_url)
            .replace('{password}', pReq.pdf_password)
            .replace('{プラン種別}', the_plan_shubetsu)
            ;
        theMailAlert.ToAddress__c = pReq.mailaddress;
        return theMailAlert;
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
}