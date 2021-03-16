public class NebikiShoninOpportunity {

	//処理対象のレコードタイプID格納プロパティ
	public Id SimpleYasugoRecordTypeId;
	public Id ObosanbinRecordTypeId;
	public Id KakuyasuButsudanRecordTypeId;
	public Id KaiyoUmieRecordTypeId;
	public Id PerpetualMemorialRecordTypeId;

	//処理対象のレコードタイプIDのList格納プロパティ
	public List<Id> listRecordTypeId;

	//処理対象のレコードタイプ別の値引き承認申請を行うための金額設定用プロパティ
	public Decimal SimpleYasugoShoninNebikikingaku;
	public Decimal ObosanbinShoninNebikikingaku;
	public Decimal KakuyasuButsudanShoninNebikikingaku;
	public Decimal KaiyoUmieShoninNebikikingaku;
	public Decimal PerpetualMemorialShoninNebikikingaku;

	public NebikiShoninOpportunity() {

		SimpleYasugoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
		ObosanbinRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId();
		KakuyasuButsudanRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('KakuyasuButsudan').getRecordTypeId();
		KaiyoUmieRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('KaiyoUmie').getRecordTypeId();
		PerpetualMemorialRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('PerpetualMemorial').getRecordTypeId();

		listRecordTypeId = new List<Id>();
		listRecordTypeId.add(SimpleYasugoRecordTypeId);
		listRecordTypeId.add(ObosanbinRecordTypeId);
		listRecordTypeId.add(KakuyasuButsudanRecordTypeId);
		listRecordTypeId.add(KaiyoUmieRecordTypeId);
		listRecordTypeId.add(PerpetualMemorialRecordTypeId);

		SimpleYasugoShoninNebikikingaku = Decimal.valueOf(-16500);
		ObosanbinShoninNebikikingaku = Decimal.valueOf(-5000);
		KakuyasuButsudanShoninNebikikingaku = Decimal.valueOf(-5000);
		KaiyoUmieShoninNebikikingaku = Decimal.valueOf(-5000);
		PerpetualMemorialShoninNebikikingaku = Decimal.valueOf(-5000);

	}

	public void OnBeforeUpdate(List<Opportunity> newList, Map<ID, Opportunity> oldMap){
	
		List<Opportunity> ListOpp = new List<Opportunity>();
		List<Opportunity> ListObosanbinOpp = new List<Opportunity>();
		List<Opportunity> ListNonObosanbinOpp = new List<Opportunity>();
		List<AggregateResult> groupedResults = new List<AggregateResult>();
		List<AggregateResult> groupedObosanbin = new List<AggregateResult>();
		Map<Id,Decimal> MapTotalPrice = new Map<Id,Decimal>();

		for(Opportunity sNewOpp :newList){
			if(listRecordTypeId.contains(sNewOpp.RecordTypeId)){
				if(sNewOpp.RecordTypeId == ObosanbinRecordTypeId){
					ListObosanbinOpp.add(sNewOpp);
				}else{
					ListNonObosanbinOpp.add(sNewOpp);
				}
				ListOpp.add(sNewOpp);
			}
		}
		
		if(ListNonObosanbinOpp.size() > 0){
			groupedResults = [SELECT OpportunityId, SUM(TotalPrice) TPrice FROM OpportunityLineItem WHERE OpportunityId in :ListNonObosanbinOpp AND Product2.ShohinBango__c = 'SBG-0000214' GROUP BY OpportunityId];
		}

		if(ListObosanbinOpp.size() > 0){
			groupedObosanbin = [SELECT Syodan__c, SUM(Kingaku__c) Kingaku FROM PatnerUriage__c WHERE Syodan__c in :ListObosanbinOpp AND Syohin__r.ShohinBango__c = 'SBG-0000188' GROUP BY Syodan__c];
		}

		if(groupedResults.size() > 0){
			for(AggregateResult ar :groupedResults){
				MapTotalPrice.put((Id)ar.get('OpportunityId') ,(Decimal)ar.get('TPrice'));
			}
		}

		if(groupedObosanbin.size() > 0){
			for(AggregateResult arObo :groupedObosanbin){
				MapTotalPrice.put((Id)arObo.get('Syodan__c') ,(Decimal)arObo.get('Kingaku'));
			}
		}

		if(MapTotalPrice.size() > 0){
			for(Opportunity sOpp :ListOpp){
				if(MapTotalPrice.containsKey(sOpp.Id)){
					if(sOpp.RecordTypeId == SimpleYasugoRecordTypeId){
						if(MapTotalPrice.get(sOpp.Id) < SimpleYasugoShoninNebikikingaku){
							UpdateNebikiKingaku(sOpp,MapTotalPrice.get(sOpp.Id));
						}else{
							UpdateNebikiKingakuNashi(sOpp);
						}
					}else if(sOpp.RecordTypeId == ObosanbinRecordTypeId){
						if(MapTotalPrice.get(sOpp.Id) < ObosanbinShoninNebikikingaku){
							UpdateNebikiKingaku(sOpp,MapTotalPrice.get(sOpp.Id));
						}else{
							UpdateNebikiKingakuNashi(sOpp);
						}
					}else if(sOpp.RecordTypeId == KakuyasuButsudanRecordTypeId){
						if(MapTotalPrice.get(sOpp.Id) < KakuyasuButsudanShoninNebikikingaku){
							UpdateNebikiKingaku(sOpp,MapTotalPrice.get(sOpp.Id));
						}else{
							UpdateNebikiKingakuNashi(sOpp);
						}
					}else if(sOpp.RecordTypeId == KaiyoUmieRecordTypeId){
						if(MapTotalPrice.get(sOpp.Id) < KaiyoUmieShoninNebikikingaku){
							UpdateNebikiKingaku(sOpp,MapTotalPrice.get(sOpp.Id));
						}else{
							UpdateNebikiKingakuNashi(sOpp);
						}
					}else if(sOpp.RecordTypeId == PerpetualMemorialRecordTypeId){
						if(MapTotalPrice.get(sOpp.Id) < PerpetualMemorialShoninNebikikingaku){
							UpdateNebikiKingaku(sOpp,MapTotalPrice.get(sOpp.Id));
						}else{
							UpdateNebikiKingakuNashi(sOpp);
						}
					}else{
					}
				}
			}
		}
	}

	//承認申請が必要な場合の処理
	public void UpdateNebikiKingaku(Opportunity sOpp, Decimal ShoninNebikikingaku){
		sOpp.NebikiKingaku__c = ShoninNebikikingaku;
		if(String.isBlank(sOpp.NebikiShoninStatus__c)){
			sOpp.NebikiShoninStatus__c = '未申請';
		}
	}

	//承認申請が必要ない場合の処理
	public void UpdateNebikiKingakuNashi(Opportunity sOpp){
		sOpp.NebikiKingaku__c = 0;
		sOpp.NebikiShoninStatus__c = '';
	}
}