public class RyoshushoSogiOpro {
	private String mOppId;
	public String mRecordId{get;set;}
	public String mFileName{get; set;}

    public RyoshushoSogiOpro(ApexPages.StandardController controller){
       this.mOppId = controller.getId();
    }

    public PageReference print(){
        RyoshushoSogi__c theRyoshushoSogi = new DocRecordCreation().print(this.mOppId);
		this.mRecordId = theRyoshushoSogi.Id;
		this.mFileName = 
            theRyoshushoSogi.ShodanBango__c + '_葬儀代領収書';
		return null;
    }

	public class DocRecordCreation{
		public RyoshushoSogi__c print(String pOppId){
			RyoshushoSogi__c theRyoshushoSogi = this.createDocRecordByOppId( pOppId );
			INSERT theRyoshushoSogi;
			return theRyoshushoSogi;
		}
		private RyoshushoSogi__c createDocRecordByOppId(String pOppId){
			return this.createDocRecord( this.getOpp(pOppId) );
		}

		private Opportunity getOpp(String pOppId){
			return 
				[
					SELECT Id, ShodanBango__c,
                    RyosyuAtena__c,
                    RyosyuSoufuSakiName__c,
                    RyosyuSoufuPostalCode__c,
                    RyosyuSoufuSakiState__c,
                    RyosyuSoufuSakiCity__c,
                    RyosyuSoufuSakiStreet__c,
                    SimpleYasugoRef__r.TaishoshaRef__r.Name,
                    (
                        SELECT Id,
                        SeikyuHouhou__c, SeikyuKingaku__c, Kessaibi__c
                        FROM KaisyuYoteisOpportunity__r
                    )
					FROM Opportunity
					WHERE Id = :pOppId
					LIMIT 1
				].get(0);
		}

		private RyoshushoSogi__c createDocRecord(Opportunity pOpp){
			Opportunity theOpp = pOpp;

            Decimal amount_total = 0;
            Decimal amount_genkin = 0;
            Decimal amount_cred = 0; 
            Decimal amount_loan = 0;
            for(OkyakusamaSeikyuMeisai__c aSeikyuLine : pOpp.KaisyuYoteisOpportunity__r){
                Decimal theAmount = aSeikyuLine.SeikyuKingaku__c == null ? 0 : aSeikyuLine.SeikyuKingaku__c;

                Boolean isGenkin = 
                    new List<String>{ 'furikomi', 'sousai' }
                    .contains(aSeikyuLine.SeikyuHouhou__c);
                if(isGenkin){ amount_genkin += theAmount; amount_total += theAmount;  }
                    
                Boolean isCred = 
                    new List<String>{ 'orico_credit', 'gmo_credit' }
                    .contains(aSeikyuLine.SeikyuHouhou__c);    
                if(isCred){ amount_cred += theAmount; amount_total += theAmount; }

                Boolean isLoan = 
                    new List<String>{ 'orico_loan' }
                    .contains(aSeikyuLine.SeikyuHouhou__c);    
                if(isLoan){ amount_loan += theAmount; amount_total += theAmount; }
            }

            String theSofuAddress = 
                String.join(new List<String>{
                    String.isBlank(theOpp.RyosyuSoufuSakiState__c) ? '' : theOpp.RyosyuSoufuSakiState__c,
                    String.isBlank(theOpp.RyosyuSoufuSakiCity__c) ? '' : theOpp.RyosyuSoufuSakiCity__c,
                    String.isBlank(theOpp.RyosyuSoufuSakiStreet__c) ? '' : theOpp.RyosyuSoufuSakiStreet__c
                }, '');

			return new RyoshushoSogi__c(
                ShodanBango__c = theOpp.ShodanBango__c,
                Atena__c = theOpp.RyosyuAtena__c,
                Sofusaki_Name__c = theOpp.RyosyuSoufuSakiName__c,
                SofusakiAddr_PostalCode__c = theOpp.RyosyuSoufuPostalCode__c,
                SofusakiAddr_Address__c = theSofuAddress,
                Taishosha_Name__c = theOpp.SimpleYasugoRef__r.TaishoshaRef__r.Name,
                Ryoshugaku_Total__c = amount_total,
                Ryoshugaku_Genkin__c = amount_genkin,
                Ryoshugaku_Cred__c = amount_cred,
                Ryoshugaku_Loan__c = amount_loan
			);
		}
	}
}