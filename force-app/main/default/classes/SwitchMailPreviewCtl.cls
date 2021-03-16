public class SwitchMailPreviewCtl {

    public String template = '';
    public String atena = '';
    public String mailaddress  {get;set;}
    public String pdfUrl = '';
    public String passWord = '';
    public String kiboarea = '';
    public String title {get;set;}
    public String honbun {get;set;}
    public SwitchMailPreviewCtl() {
        template = Apexpages.currentPage().getParameters().get('template');
        atena = Apexpages.currentPage().getParameters().get('atena');
        mailaddress = Apexpages.currentPage().getParameters().get('mailaddress');
        pdfUrl = Apexpages.currentPage().getParameters().get('pdfUrl');
        passWord = Apexpages.currentPage().getParameters().get('passWord');
        kiboarea = Apexpages.currentPage().getParameters().get('kiboarea');
    }

    public void init(){
        if(template == '標準'){
            YorisoNoOsoshikiShiryoSofuUrlMail.CreateMailArg theArgUrl = new YorisoNoOsoshikiShiryoSofuUrlMail.CreateMailArg();
            theArgUrl.atena = atena;
            theArgUrl.mailaddress = mailaddress;
            theArgUrl.pdfUrl = pdfUrl;
            theArgUrl.passWord = passWord;

            MailAlert__c mailAlert = new YorisoNoOsoshikiShiryoSofuUrlMail().createMail(theArgUrl);
            title = mailAlert.Title__c;
            honbun = mailAlert.Body__c;
        }
        if(template == '施行可能葬儀社なし'){
            SekoKanoSogishaNashiShiryoSofuMail.CreateMailArg theArgUrl = new SekoKanoSogishaNashiShiryoSofuMail.CreateMailArg();
            theArgUrl.atena = atena;
            theArgUrl.mailaddress = mailaddress;
            theArgUrl.kiboarea = kiboarea;

            MailAlert__c mailAlert = new SekoKanoSogishaNashiShiryoSofuMail().createMail(theArgUrl);
            title = mailAlert.Title__c;
            honbun = mailAlert.Body__c;
        }
    }
}