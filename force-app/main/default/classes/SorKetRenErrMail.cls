public class SorKetRenErrMail {
    private MailTemplates.Template m_Template = new MailTemplates().getTemplate('SorKetRenErrMail');

    public class CreateMailArg{
        public String ShodanId = '';
        public String ShodanBango = '';
        public String errorMessage = '';
    }
    public MailAlert__c createMail(createMailArg pCreateMailArg){
        MailAlert__c theMailAlert = new MailAlert__c();
        MailAlerts.applyTemplate(this.m_Template, theMailAlert);

        String theShodanUrl = SfUrls.getLexRecPageUrlStr(pCreateMailArg.ShodanId);

        theMailAlert.Body__c = theMailAlert.Body__c
            .replace('{{商談番号}}', pCreateMailArg.ShodanBango)
            .replace('{{商談URL}}', theShodanUrl)
            .replace('{{エラー内容}}', pCreateMailArg.errorMessage)
            ;
        return theMailAlert;
    }
}