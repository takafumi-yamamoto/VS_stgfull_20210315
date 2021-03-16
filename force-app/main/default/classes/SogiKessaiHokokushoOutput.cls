public class SogiKessaiHokokushoOutput {
	
	private Opportunity opportunity;
	public String errMsg {get;set;}
    public String sogiKessaiHokokushoId {get;set;}
    public String opportunityNunber {get;set;}

    public SogiKessaiHokokushoOutput(ApexPages.StandardController controller){

        opportunity = [select Id, 
        					ShodanBangoF__c, 
							KiboShiharaiHouhou__c, 
							SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name, 
							SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Fax, 
							SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Phone,
							SimpleYasugoRef__r.TaishoshaRef__r.LastName, 
							SimpleYasugoRef__r.TaishoshaRef__r.FirstName, 
							SimpleYasugoRef__r.TaishoshaRef__r.LastNameFurigana__pc, 
							SimpleYasugoRef__r.TaishoshaRef__r.FirstNameFurigana__pc, 
							(
								select Id, 
										SeikyuHouhou__c, 
										SeikyuKingaku__c 
								from KaisyuYoteisOpportunity__r 
								where SeikyuHouhou__c in ('orico_loan', 'orico_credit', 'gmo_credit')
							)
						from Opportunity
						where Id = :controller.getId()
					];

		errMsg = '';
		if( opportunity.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Fax == null ) errMsg = '葬儀社のFAXを入力してください。';
		if( opportunity.KaisyuYoteisOpportunity__r.size() == 0 ) errMsg = 'お客様請求明細を登録してください。';
    }

    public PageReference createSogiKessaiHokokusho(){
    	
        SogiKessaiHokokusho__c sogikessaiHokokusho = new SogiKessaiHokokusho__c();
        sogikessaiHokokusho.KessaiKingaku__c = getKessaiKingaku();
		sogikessaiHokokusho.KojinSeiKanji__c = opportunity.SimpleYasugoRef__r.TaishoshaRef__r.LastName;
		sogikessaiHokokusho.KojinMeiKanji__c = opportunity.SimpleYasugoRef__r.TaishoshaRef__r.FirstName;
		sogikessaiHokokusho.KojinSeiKana__c = opportunity.SimpleYasugoRef__r.TaishoshaRef__r.LastNameFurigana__pc;
		sogikessaiHokokusho.KojinMeiKana__c = opportunity.SimpleYasugoRef__r.TaishoshaRef__r.FirstNameFurigana__pc;
		sogikessaiHokokusho.KokyakuID__c = opportunity.ShodanBangoF__c;
		sogikessaiHokokusho.Sakuseibi__c = date.today();
		sogikessaiHokokusho.ShodanRef__c = opportunity.Id;
		sogikessaiHokokusho.SeikyusakiFAX__c = opportunity.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Fax;
		sogikessaiHokokusho.SeikyusakiTEL__c = opportunity.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Phone;
		sogikessaiHokokusho.SeikyusakiAtena__c = opportunity.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name;
		sogikessaiHokokusho.KiboShiharaiHoho__c = getShiharaiHoho();
        insert sogikessaiHokokusho;

        sogiKessaiHokokushoId = sogikessaiHokokusho.Id;
        opportunityNunber = opportunity.ShodanBangoF__c;

        return null;
    }

    private Decimal getKessaiKingaku(){

    	Decimal kessaiKingaku = 0;
    	for(OkyakusamaSeikyuMeisai__c aOkyakusamaSeikyuMeisai : opportunity.KaisyuYoteisOpportunity__r) kessaiKingaku += aOkyakusamaSeikyuMeisai.SeikyuKingaku__c;
    	return kessaiKingaku;
    }

    private String getShiharaiHoho(){

    	String shiharaiHoho = '';
    	for(OkyakusamaSeikyuMeisai__c aOkyakusamaSeikyuMeisai : opportunity.KaisyuYoteisOpportunity__r) {
    		if( aOkyakusamaSeikyuMeisai.SeikyuHouhou__c == 'orico_loan' ) shiharaiHoho = 'ローン';
    		if( aOkyakusamaSeikyuMeisai.SeikyuHouhou__c == 'orico_credit' ) shiharaiHoho = 'カード';
    		if( aOkyakusamaSeikyuMeisai.SeikyuHouhou__c == 'gmo_credit' ) shiharaiHoho = 'カード';
    	}

    	return shiharaiHoho;
    }
}