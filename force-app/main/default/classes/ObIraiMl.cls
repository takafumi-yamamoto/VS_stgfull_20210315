public class ObIraiMl implements IObIraiMl{
    public interface IObIraiMl {
        MailAlert__c createMail(Req pReq);
    }

    public static String m_MsgType = 'ObIraiMl';
    private static MailTemplates.Template m_Template = new MailTemplates().getTemplate(m_MsgType);
    private IOppDataPvdr mOppDataPvdr = null;

    public ObIraiMl(IOppDataPvdr pOppDataPvdr){
        this.mOppDataPvdr = pOppDataPvdr;
    }

    public class Req{
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

        String the_nittei = '';
        if( OboPlanKeitais.isSogi(theOppData.oboPlan) ){

            String the_tsuya = theOppData.tsuya_datetime != null ? theOppData.tsuya_datetime.format('yyyy/MM/dd HH:mm') : '';
            String the_kokubetsu = theOppData.kokubetsu_datetime != null ? theOppData.kokubetsu_datetime.format('yyyy/MM/dd HH:mm') : '';
            String the_kaso = theOppData.kaso_datetime != null ? theOppData.kaso_datetime.format('yyyy/MM/dd HH:mm') : '';

            if( !String.isBlank(the_tsuya) && new List<String>{'一般葬'}.contains(theOppData.oboPlan) ){
                the_nittei += ( '通夜日時：' + the_tsuya + '\r\n' );
            }
            if( !String.isBlank(the_kokubetsu) && new List<String>{'一般葬','一日葬'}.contains(theOppData.oboPlan) ){
                the_nittei += ( '告別式日時：' + the_kokubetsu + '\r\n' );
            }
            if( !String.isBlank(the_kaso) && new List<String>{'一般葬','一日葬','火葬式'}.contains(theOppData.oboPlan) ){
                the_nittei += ( '火葬日時：' + the_kaso + '\r\n' );
            }
        }else if( OboPlanKeitais.isKaimyo(theOppData.oboPlan) ){
            the_nittei = '';
        }else{
            String the_hoyo = theOppData.hoyo_datetime != null ? theOppData.hoyo_datetime.format('yyyy/MM/dd HH:mm').replace(' 00:00','') : '';
            if( !String.isBlank(the_hoyo) ){
                the_nittei += ( '法要日時：' + the_hoyo + '\r\n' );
            }
        }
    
        theMailAlert.Body__c = theMailAlert.Body__c
            .replace('{僧侶.名}', pReq.account_name)
            .replace('{商談番号}', theOppData.shodan_Bango)
            .replace('{url}', pReq.pdf_url)
            .replace('{password}', pReq.pdf_password)
            .replace('{お坊さん便プラン}', theOppData.oboPlan)
            .replace('{法務日程}', the_nittei)
            ;
        theMailAlert.ToAddress__c = pReq.mailaddress;

        theMailAlert.Title__c = theMailAlert.Title__c.replace('{商談番号}', theOppData.shodan_Bango);
        return theMailAlert;
    }

    public class OppData{
        public String shodan_Bango = '';
        public String oboPlan = '';
        public Datetime tsuya_datetime;
        public Datetime kokubetsu_datetime;
        public Datetime kaso_datetime;
        public Datetime hoyo_datetime;
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
                ObosanbinRef__r.MemorialServicePlan__c,
                ObosanbinRef__r.TsuyaDateTime_Inp__c,
                ObosanbinRef__r.KokubetsushikiNichiji__c,
                ObosanbinRef__r.KasoDateTime_Inp__c,
                ObosanbinRef__r.KokubetsuDateTime_Inp__c
                FROM Opportunity
                WHERE Id = :pOppId
                LIMIT 1
            ].get(0);

            OppData theOppData = new OppData();
            theOppData.shodan_Bango = theOpp.ShodanBango__c;
            theOppData.oboPlan = theOpp.ObosanbinRef__r.MemorialServicePlan__c;
            theOppData.tsuya_datetime = theOpp.ObosanbinRef__r.TsuyaDateTime_Inp__c;
            theOppData.kokubetsu_datetime = theOpp.ObosanbinRef__r.KokubetsushikiNichiji__c;
            theOppData.kaso_datetime = theOpp.ObosanbinRef__r.KasoDateTime_Inp__c;
            theOppData.hoyo_datetime = theOpp.ObosanbinRef__r.KokubetsuDateTime_Inp__c;
            
            return theOppData;
        }
    }
}