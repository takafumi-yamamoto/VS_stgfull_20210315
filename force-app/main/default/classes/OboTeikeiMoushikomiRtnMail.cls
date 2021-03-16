public class OboTeikeiMoushikomiRtnMail {

    private MailTemplates.Template m_Template = new MailTemplates().getTemplate('OboTeikeiMoushikomiRtnMail');

    public class CreateMailArg{
        public String last_name = '';
        public String first_name = '';
        public String last_kana = '';
		public String first_kana = '';
		public String zip = '';
		public String state = '';
		public String city = '';
		public String street = '';
		public String MobilePhone = '';
		public String email = '';
		public String shuha = '';
		public String Temple = '';
		public String JiinMeiKana = '';
		public String unit = '';
		public String Other_company = '';
		public String MoshikomiKeii = '';
		public String SonotaRenrakuJiko = '';
    }
    public MailAlert__c createMail(createMailArg pCreateMailArg){
        MailAlert__c theMailAlert = new MailAlert__c();
        MailAlerts.applyTemplate(this.m_Template, theMailAlert);
		
		theMailAlert.ToAddress__c = pCreateMailArg.email;

        theMailAlert.Body__c = theMailAlert.Body__c
            .replace('%%last_name%%', pCreateMailArg.last_name)
            .replace('%%first_name%%', pCreateMailArg.first_name)
			.replace('%%last_kana%%', pCreateMailArg.last_kana)
			.replace('%%first_kana%%', pCreateMailArg.first_kana)
			.replace('%%zip%%', pCreateMailArg.zip)
			.replace('%%state%%', pCreateMailArg.state)
			.replace('%%city%%', pCreateMailArg.city)
			.replace('%%street%%', pCreateMailArg.street)
			.replace('%%MobilePhone%%', pCreateMailArg.MobilePhone)
			.replace('%%email%%', pCreateMailArg.email)
			.replace('%%shuha%%', pCreateMailArg.shuha)
			.replace('%%Temple%%', pCreateMailArg.Temple)
			.replace('%%JiinMeiKana%%', pCreateMailArg.JiinMeiKana)
			.replace('%%unit%%', pCreateMailArg.unit)
			.replace('%%Other_company%%', pCreateMailArg.Other_company)
			.replace('%%MoshikomiKeii%%', pCreateMailArg.MoshikomiKeii)
			.replace('%%SonotaRenrakuJiko%%', pCreateMailArg.SonotaRenrakuJiko)
            ;
        return theMailAlert;
    }
}