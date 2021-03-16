public class IhaiGenkoOpro {
	private String mOppId;
	public String mIhaiGengoId{get;set;}
	public String mFileName{get; set;}

    public IhaiGenkoOpro(ApexPages.StandardController controller){
       this.mOppId = controller.getId();
    }

    public PageReference print(){
		IhaiGenko__c theIhaiGenko = new IhaiGenkoCreation().print(this.mOppId);
		this.mIhaiGengoId = theIhaiGenko.Id;
		this.mFileName = 
			theIhaiGenko.ShodanBango__c + '_位牌原稿';
		return null;
    }

	public class IhaiGenkoCreation{
		public IhaiGenko__c print(String pOppId){
			IhaiGenko__c theIhaiGenko = this.createIhaiGenkoByOppId( pOppId );
			INSERT theIhaiGenko;
			return theIhaiGenko;
		}
		private IhaiGenko__c createIhaiGenkoByOppId(String pOppId){
			return this.createIhaiGenko( this.getOpp(pOppId) );
		}

		private Opportunity getOpp(String pOppId){
			return 
				[
					SELECT Id, ShodanBango__c,
					Account.Id,
					Account.Name,
					Account.LastNameFurigana__pc, Account.FirstNameFurigana__pc,
					Account.BillingPostalCode,
					Account.BillingState, Account.BillingCity, Account.BillingStreet,
					Account.MobilePhone__c, Account.Phone,
					BestButsudanRef__c,
					BestButsudanRef__r.Syuha__c,
					BestButsudanRef__r.TaishoshaRef__c,
					BestButsudanRef__r.TaishoshaRef__r.Name,
					BestButsudanRef__r.TaishoshaRef__r.Age__pc,
					BestButsudanRef__r.TaishoshaRef__r.PersonDeathDate__pc,
					BestButsudanRef__r.TaishoshaRef__r.Syuha__c
					FROM Opportunity
					WHERE Id = :pOppId
					LIMIT 1
				].get(0);
		}

		private IhaiGenko__c createIhaiGenko(Opportunity pOpp){
			Opportunity theOpp = pOpp;

			String theCustNameKana = String.join(
				new List<String>{ 
					theOpp.Account.LastNameFurigana__pc,  
					theOpp.Account.FirstNameFurigana__pc
				},
				' '
			);

			return new IhaiGenko__c(
				ShodanBango__c = theOpp.ShodanBango__c,
				CustName__c = theOpp.Account.Name,
				CustNameKana__c = theCustNameKana,
				CustMobile__c = theOpp.Account.MobilePhone__c,
				CustPhone__c = theOpp.Account.Phone,
				CustAddrZipCode__c = theOpp.Account.BillingPostalCode,
				CustAddrState__c = theOpp.Account.BillingState,
				CustAddrCity__c = theOpp.Account.BillingCity,
				CustAddrStreet__c = theOpp.Account.BillingStreet,
				Shuha__c = theOpp.BestButsudanRef__r.Syuha__c,
				Taishosha_Name__c = theOpp.BestButsudanRef__r.TaishoshaRef__r.Name,
				Taishosha_DeathDate__c = theOpp.BestButsudanRef__r.TaishoshaRef__r.PersonDeathDate__pc,
				Taishosha_Age__c = theOpp.BestButsudanRef__r.TaishoshaRef__r.Age__pc
			);
		}
	}
}