public class ObHokoSmDlrErrMl {
    private MailTemplates.Template m_Template = new MailTemplates().getTemplate('ObHokoSmDlrErrMl');

    public class Req{
        public String ShodanBango = '';
        public String ShodanId = '';
        public String SendDate = '';
    }
    public MailAlert__c createMail(Req pReq){
        MailAlert__c theMailAlert = new MailAlert__c();
        MailAlerts.applyTemplate(this.m_Template, theMailAlert);

        String theShodanBango = pReq.ShodanBango;
        String theShodanUrl = SfUrls.getLexRecPageUrlStr(pReq.ShodanId);

        theMailAlert.Body__c = theMailAlert.Body__c
            .replace('{{商談番号}}', theShodanBango)
            .replace('{{商談URL}}', theShodanUrl)
            .replace('{{送信日}}', pReq.SendDate)
            ;
        return theMailAlert;
    }
}