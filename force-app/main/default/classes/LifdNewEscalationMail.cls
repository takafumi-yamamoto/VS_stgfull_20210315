public class LifdNewEscalationMail {
    private MailTemplates.Template m_Template = new MailTemplates().getTemplate('LifdNewEscalationMail');

    public class Req{
        public String LifdEscalationId = '';
        public Req set_LifdEscalationId(String pValue){ this.LifdEscalationId = pValue; return this; }
    }
    public MailAlert__c createMail(Req pReq){
        MailAlert__c theMailAlert = new MailAlert__c();
        MailAlerts.applyTemplate(this.m_Template, theMailAlert);

        String theLifdEscalationUrl = 
            String.isBlank(pReq.LifdEscalationId) 
            ? '' 
            : SfUrls.getLexRecPageUrlStr(pReq.LifdEscalationId);

        theMailAlert.Body__c = theMailAlert.Body__c
            .replace('{{url}}', theLifdEscalationUrl)
            ;
        return theMailAlert;
    }
}