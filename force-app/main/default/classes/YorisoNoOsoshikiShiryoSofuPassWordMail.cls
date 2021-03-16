public class YorisoNoOsoshikiShiryoSofuPassWordMail {
    
    private MailTemplates.Template m_Template = new MailTemplates().getTemplate('YorisoNoOsoshikiShiryoSofuPassWord');

    public class CreateMailArg{
        public String atena = '';
        public String mailaddress = '';
        public String passWord = '';
    }

    public MailAlert__c createMail(createMailArg pCreateMailArg){
        MailAlert__c theMailAlert = new MailAlert__c();
        MailAlerts.applyTemplate(this.m_Template, theMailAlert);

        if( String.isBlank(pCreateMailArg.atena) ) throw new RequestInvalidException();
        if( String.isBlank(pCreateMailArg.passWord) ) throw new RequestInvalidException();
        if( String.isBlank(pCreateMailArg.mailaddress) ) throw new RequestInvalidException();
        
        String theAtena = pCreateMailArg.atena;
        String thePassWord = pCreateMailArg.passWord;

        theMailAlert.Body__c = theMailAlert.Body__c
            .replace('{{宛名}}', theAtena)
            .replace('{{パスワード}}', thePassWord)
            ;
        theMailAlert.ToAddress__c = pCreateMailArg.mailaddress;
        return theMailAlert;
    }

    public class RequestInvalidException extends Exception{}
}