public class WaribikiShohinAdd_201912 {

	@TestVisible
	private Set<String>  setBenefitPlanSet(){
		return new Set<String>{
			'SBG-0003002',
			'SBG-0003003',
			'SBG-0003004',
			'SBG-0003005',
			'SBG-0003006',
			'SBG-0003007',
			'SBG-0003008',
			'SBG-0003009',
			'SBG-0003010',
			'SBG-0003011',
			'SBG-0003012',
			'SBG-0003013'
		};
	}
	private Boolean isBenefitPlan(String shohinBango){ return setBenefitPlanSet().contains(shohinBango); }

    public class Data{
        public Decimal unit_price = 0;
        public String service_id = '';
        public String label_formalname = '';
        public String label = '';
        public String code = '';
        public String waribiki_id = '';
        public String coupon_id = '';
        public String data_kubun = '';
    }

    public String addWaribikiShouhin(String oppCode, String planCode, String butsugu_kibo) {

    	Opportunity opp = [select Id, 
    								AccountId, 
    								Account.MemberTokutenKubunCode__c, 
    								TaishosyaRef__r.MemberTokutenKubunCode__c, 
    								Req_Day__c, 
    								Iriguchi__c,
                                    Pricebook2Id,
                                    ShiryoSeikyuUmuExp__c,
                                    AllianceRef__c,
                                    KiboShiharaiHouhou__c,
                                    Account.JizenwariKekaKikan__c,
                                    TaishosyaRef__r.JizenwariKekaKikan__c,
                                    Account.AcvmJizenJunbiMinDate__c,
                                    TaishosyaRef__r.AcvmJizenJunbiMinDate__c,
                                    AllianceRef__r.Teikeisaki__r.Name,
                                    SurveyDiscountAgreeStatus__c, 
                                    (
                                    	select Id, 
                                    		Product2.k_Service_Id_exp__c, 
                                    		Product2.Name, 
                                    		Product2.NameForCustomerExp__c, 
                                    		Product2.ShohinBango__c, 
                                    		Product2.DataKubun__c, 
                                    		TotalPrice 
                                    	from OpportunityLineItems 
                                    	where Product2.DataKubun__c = '3:クーポン' 
                                    	ORDER BY TotalPrice asc, Product2.Name asc
                                    ) 
							from Opportunity 
							where ShodanBango__c = :oppCode];


		String planShohinBango = planCode;

		WrTkCtxs.ContextData theWaribikiContext = new WrTkCtxs().selectContextDataByOppIds( new List<String>{opp.Id} ).values().get(0);
		if(planShohinBango == 'SBG-0005104') butsugu_kibo = '仏具あり';
		theWaribikiContext.butsuguNashiKibo = butsugu_kibo;
		Set<String> theWaribikiShohinBangos = new WrTks().getWaribikiShohinBangos(theWaribikiContext, planShohinBango);

		List<Data> waribikiList = new List<Data>();
		for(PricebookEntry aPricebookEntry : [
			SELECT Id,
			Product2Id, Product2.ShohinBango__c, Product2.Name, 
			Product2.k_Service_Id_exp__c, Product2.NameForCustomerExp__c, UnitPrice, Product2.DataKubun__c 
			FROM PricebookEntry
			WHERE Product2.ShohinBango__c IN :theWaribikiShohinBangos
			AND Product2.DataKubun__c != '3:クーポン' 
			ORDER BY UnitPrice asc, Product2.Name asc
		]){
			Set<String> theAtobaraiKessaiTesuryo_ShohinBangos = new Set<String>{ 'SBG-0002010','SBG-0002011' };
			if( theAtobaraiKessaiTesuryo_ShohinBangos.contains(aPricebookEntry.Product2.ShohinBango__c) ) continue;

			Data theData = new Data();
			theData.unit_price = aPricebookEntry.UnitPrice;
			theData.service_id = aPricebookEntry.Product2.k_Service_Id_exp__c;
			theData.label_formalname = aPricebookEntry.Product2.Name;
			theData.label = aPricebookEntry.Product2.NameForCustomerExp__c;
			theData.code = aPricebookEntry.Product2.ShohinBango__c;
			theData.data_kubun = aPricebookEntry.Product2.DataKubun__c;
			waribikiList.add(theData);
		}

		for(OpportunityLineItem oppLI : opp.OpportunityLineItems){
			if(oppLI.Product2.ShohinBango__c == 'SBG-0003620' && !isBenefitPlan(planShohinBango)) continue;		//【19.12】よりそうのお葬式 火葬式 直葬プラン に 【19.12】ベネフィット・ワン専用特別割引 は適用しない
			Data couponData = new Data();
			couponData.unit_price = oppLI.TotalPrice;
		    couponData.service_id = oppLI.Product2.k_Service_Id_exp__c;
		    couponData.label_formalname = oppLI.Product2.Name;
		    couponData.label = oppLI.Product2.NameForCustomerExp__c;
		    couponData.code = oppLI.Product2.ShohinBango__c;
		    couponData.data_kubun = oppLI.Product2.DataKubun__c;
		    waribikiList.add(couponData);
		}

		return JSON.serialize(waribikiList);
	}

}