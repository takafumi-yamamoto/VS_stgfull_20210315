public class SekoKanoSogishaNashiShiryoSofuMail {

    private MailTemplates.Template m_Template = new MailTemplates().getTemplate('SekoKanoSogishaNashiShiryoSofu');

    public class CreateMailArg{
        public String atena = '';
        public String mailaddress = '';
        public String kiboarea = '';
    }

    public MailAlert__c createMail(createMailArg pCreateMailArg){
        MailAlert__c theMailAlert = new MailAlert__c();
        MailAlerts.applyTemplate(this.m_Template, theMailAlert);

        if( String.isBlank(pCreateMailArg.atena) ) throw new RequestInvalidException();
        if( String.isBlank(pCreateMailArg.mailaddress) ) throw new RequestInvalidException();
        if( String.isBlank(pCreateMailArg.kiboarea) ) throw new RequestInvalidException();
        
        String theAtena = pCreateMailArg.atena;
        String kiboarea = pCreateMailArg.kiboarea;

        theMailAlert.Body__c = theMailAlert.Body__c
            .replace('{{宛名}}', theAtena)
            .replace('{{希望エリア}}', kiboarea)
            ;
        theMailAlert.ToAddress__c = pCreateMailArg.mailaddress;
        return theMailAlert;
    }

    public class RequestInvalidException extends Exception{}
}