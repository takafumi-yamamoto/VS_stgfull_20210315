public class YorisoNoOsoshikiShiryoSofuUrlMail {

    private MailTemplates.Template m_Template = new MailTemplates().getTemplate('YorisoNoOsoshikiShiryoSofuUrl');

    public class CreateMailArg{
        public String atena = '';
        public String mailaddress = '';
        public String pdfUrl = '';
        public String passWord = '';
    }

    public MailAlert__c createMail(createMailArg pCreateMailArg){
        MailAlert__c theMailAlert = new MailAlert__c();
        MailAlerts.applyTemplate(this.m_Template, theMailAlert);

        if( String.isBlank(pCreateMailArg.atena) ) throw new RequestInvalidException();
        if( String.isBlank(pCreateMailArg.mailaddress) ) throw new RequestInvalidException();
        if( String.isBlank(pCreateMailArg.pdfUrl) ) throw new RequestInvalidException();
        if( String.isBlank(pCreateMailArg.passWord) ) throw new RequestInvalidException();
        
        theMailAlert.Body__c = theMailAlert.Body__c
            .replace('{{宛名}}', pCreateMailArg.atena)
            .replace('{{送付資料URL}}', pCreateMailArg.pdfUrl)
            .replace('{{パスワード}}', pCreateMailArg.passWord)
            ;
        theMailAlert.ToAddress__c = pCreateMailArg.mailaddress;
        return theMailAlert;
    }

    public class RequestInvalidException extends Exception{}
}