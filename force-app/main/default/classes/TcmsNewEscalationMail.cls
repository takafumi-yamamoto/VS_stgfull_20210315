public class TcmsNewEscalationMail{
    private MailTemplates.Template m_Template = new MailTemplates().getTemplate('TcmsNewEscalationMail');

    public class Req{
        public String TcmsEscalationId = '';
        public Req set_TcmsEscalationId(String pValue){ this.TcmsEscalationId = pValue; return this; }
    }
    public MailAlert__c createMail(Req pReq){
        MailAlert__c theMailAlert = new MailAlert__c();
        MailAlerts.applyTemplate(this.m_Template, theMailAlert);

        String theTcmsEscalationUrl = 
            String.isBlank(pReq.TcmsEscalationId) 
            ? '' 
            : SfUrls.getLexRecPageUrlStr(pReq.TcmsEscalationId);

        theMailAlert.Body__c = theMailAlert.Body__c
            .replace('{{url}}', theTcmsEscalationUrl)
            ;
        return theMailAlert;
    }
}