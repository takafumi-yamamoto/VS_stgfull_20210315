public class OboDashin_KetteiNGMail {

    private MailTemplates.Template m_Template = new MailTemplates().getTemplate('OboDashin_KetteiNG');

    public class CreateMailArg{
        public String ShodanBango = '';
        public String ShodanId = '';
        public String DashinIraiId = '';        
    }
    public MailAlert__c createMail(createMailArg pCreateMailArg){
        MailAlert__c theMailAlert = new MailAlert__c();
        MailAlerts.applyTemplate(this.m_Template, theMailAlert);

        String theShodanBango = pCreateMailArg.ShodanBango;
        String theShodanUrl = SfUrls.getLexRecPageUrlStr(pCreateMailArg.ShodanId);
        String theDashinIraiUrl = SfUrls.getLexRecPageUrlStr(pCreateMailArg.DashinIraiId);

        theMailAlert.Body__c = theMailAlert.Body__c
            .replace('{{商談番号}}', theShodanBango)
            .replace('{{商談URL}}', theShodanUrl)
            .replace('{{打診結果URL}}', theDashinIraiUrl)
            ;
        return theMailAlert;
    }

}