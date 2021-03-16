public class Ctl_ShodanCopy {
	/**
		葬儀転換: 前回お坊さん便商談を変更されたとき、　商談情報をコピーします。
		・相談者（お客様） ・対象者 ・喪主 ・葬儀社
	*/
	public void copySougiSyoudan(List<Opportunity> newList, Map<ID, Opportunity> oldMap){

		List<Opportunity> theTargets = new List<Opportunity>();
		Set<Id> theSourceOppIds = new Set<Id>();
		for(Opportunity aNewOne : newList){
			Opportunity aOldOne = oldMap.get(aNewOne.Id);

			if( aNewOne.RecordTypeId != RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin') ) continue;
			if(aNewOne.SougiSyoudanRef__c == aOldOne.SougiSyoudanRef__c) continue;
			if(aNewOne.SougiSyoudanRef__c == null) continue;
			if(aNewOne.ObosanbinRef__c == null) continue;

			theTargets.add(aNewOne);
			theSourceOppIds.add(aNewOne.SougiSyoudanRef__c);
		}

		if(theTargets.size() == 0) return;

		Map<Id,Opportunity> theSourceOpps = new Map<Id,Opportunity>(
			[
			Select id, 
			RecordTypeId,
			AccountId,
			SimpleYasugoRef__c, 
			SimpleYasugoRef__r.TaishoshaRef__c, 
			SimpleYasugoRef__r.MoshuRef__c, 
			SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__c,
			SogiReviRef__c,
			SogiReviRef__r.TaisyosyaRef__c,
			SogiReviRef__r.Mosyu__c,
			SogiReviRef__r.KetteiSogisya__r.Teikeisaki__c
			from Opportunity where id = :theSourceOppIds
			]
		);

		Map<Id,Obosanbin__c> theObosanbinsToBeUpdated = new Map<Id, Obosanbin__c>();
		for(Opportunity aNewOne : theTargets){
			Opportunity theSourceOpp = theSourceOpps.get(aNewOne.SougiSyoudanRef__c);

			if( theSourceOpp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo') ){
				if( theSourceOpp.SimpleYasugoRef__c == null ) continue;
				aNewOne.AccountId = theSourceOpp.AccountId;
				aNewOne.RyunyumotoService__c = 'シンプルなお葬式';
				aNewOne.TaishosyaRef__c = theSourceOpp.SimpleYasugoRef__r.TaishoshaRef__c;
				aNewOne.MosyuRef__c = theSourceOpp.SimpleYasugoRef__r.MoshuRef__c;

				theObosanbinsToBeUpdated.put( 
					aNewOne.ObosanbinRef__c, 
					new Obosanbin__c( 
						Id = aNewOne.ObosanbinRef__c, 
						Taishosha1Ref__c = theSourceOpp.SimpleYasugoRef__r.TaishoshaRef__c, 
						MoshuRef__c = theSourceOpp.SimpleYasugoRef__r.MoshuRef__c, 
						Sogisha__c = theSourceOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__c
					) 
				);
			}

			if( theSourceOpp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SougiRev') ){
				if( theSourceOpp.SogiReviRef__c == null ) continue;
				aNewOne.AccountId = theSourceOpp.AccountId;
				aNewOne.RyunyumotoService__c = '葬儀レビ';

				theObosanbinsToBeUpdated.put( 
					aNewOne.ObosanbinRef__c, 
					new Obosanbin__c( 
						Id = aNewOne.ObosanbinRef__c, 
						Taishosha1Ref__c = theSourceOpp.SogiReviRef__r.TaisyosyaRef__c, 
						MoshuRef__c = theSourceOpp.SogiReviRef__r.Mosyu__c, 
						Sogisha__c = theSourceOpp.SogiReviRef__r.KetteiSogisya__r.Teikeisaki__c
					) 
				);
			}

		}

		if( theObosanbinsToBeUpdated.size() > 0 ) {
			Ctl_Obosanbin_SyncToOpp.isActive = False;  // Ctl_Obosanbin_SyncToOpp無効化
			Update theObosanbinsToBeUpdated.values();
    		Ctl_Obosanbin_SyncToOpp.isActive = True;
		}
	}	

	/**
		法要リピート : 前回お坊さん便商談を変更されたとき、　商談情報をコピーします。
		・相談者（お客様）・対象者 ・喪主
	*/
	public void copyZennkaiOboOpp(List<Opportunity> newList, Map<ID, Opportunity> oldMap){

		List<Opportunity> theTargets = new List<Opportunity>();
		Set<Id> theSourceOppIds = new Set<Id>();
		for(Opportunity aNewOne : newList){
			Opportunity aOldOne = oldMap.get(aNewOne.Id);

			if(aNewOne.ZennkaiOboOppRef__c != aOldOne.ZennkaiOboOppRef__c && aNewOne.ZennkaiOboOppRef__c != null
				&& aNewOne.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin')
				){
				theTargets.add(aNewOne);
				theSourceOppIds.add(aNewOne.ZennkaiOboOppRef__c);
			}
		}

		if(theSourceOppIds.size() == 0) return;
		
		Map<Id,Opportunity> theSourceOpps = new Map<Id,Opportunity>(
			[
			Select id, 
			  AccountId,
			  RyunyumotoService__c, 
			  ObosanbinRef__c, 
			  ObosanbinRef__r.Taishosha1Ref__c, 
			  ObosanbinRef__r.Taishosha2Ref__c, 
			  ObosanbinRef__r.Taishosha3Ref__c, 
			  ObosanbinRef__r.ZokugaraSodanshaNitottenoTaishosha1__c
			from Opportunity where id = :theSourceOppIds
			]
		);

		Map<Id,Obosanbin__c> theObosanbinsToBeUpdated = new Map<Id, Obosanbin__c>();
		for(Opportunity aNewOne : theTargets){

			if(aNewOne.ObosanbinRef__c == null) continue;
			Opportunity theSourceOpp = theSourceOpps.get(aNewOne.ZennkaiOboOppRef__c);
			if(theSourceOpp == null || theSourceOpp.ObosanbinRef__c == null) continue;

			aNewOne.AccountId = theSourceOpp.AccountId;
			aNewOne.RyunyumotoService__c = this.RyunyumotoServiceMappingInObo.get(theSourceOpp.RyunyumotoService__c);
			aNewOne.TaishosyaRef__c = theSourceOpp.ObosanbinRef__r.Taishosha1Ref__c;
			
			theObosanbinsToBeUpdated.put( 
				aNewOne.ObosanbinRef__c, 
				new Obosanbin__c( 
					Id = aNewOne.ObosanbinRef__c,
				  	Taishosha1Ref__c = theSourceOpp.ObosanbinRef__r.Taishosha1Ref__c,
				  	Taishosha2Ref__c = theSourceOpp.ObosanbinRef__r.Taishosha2Ref__c,
				  	Taishosha3Ref__c = theSourceOpp.ObosanbinRef__r.Taishosha3Ref__c,
				  	ZokugaraSodanshaNitottenoTaishosha1__c = theSourceOpp.ObosanbinRef__r.ZokugaraSodanshaNitottenoTaishosha1__c
				) 
			);
		}

		if( theObosanbinsToBeUpdated.size() > 0 ) {
			Ctl_Obosanbin_SyncToOpp.isActive = False; // Ctl_Obosanbin_SyncToOpp無効化
			Update theObosanbinsToBeUpdated.values();
    		Ctl_Obosanbin_SyncToOpp.isActive = True;
		}
	}	

	private Map<String, String> RyunyumotoServiceMappingInObo = new Map<String,String>{
		'お坊さん便' => 'お坊さん便-リピート',
		'お坊さん便-リピート' => 'お坊さん便-リピート(3回目)',
		'お坊さん便-リピート(3回目)' => 'お坊さん便-リピート(4回目)',
		'お坊さん便-リピート(4回目)' => 'お坊さん便-リピート(4回目)',
		'シンプルなお葬式' => 'シンプルなお葬式-リピート',
		'シンプルなお葬式-リピート' => 'シンプルなお葬式-リピート(3回目)',
		'シンプルなお葬式-リピート(3回目)' => 'シンプルなお葬式-リピート(4回目)',
		'シンプルなお葬式-リピート(4回目)' => 'シンプルなお葬式-リピート(4回目)',
		'葬儀レビ' => '葬儀レビ-リピート',
		'葬儀レビ-リピート' => '葬儀レビ-リピート(3回目)',
		'葬儀レビ-リピート(3回目)' => '葬儀レビ-リピート(4回目)',
		'葬儀レビ-リピート(4回目)' => '葬儀レビ-リピート(4回目)',
		'葬儀社紹介' => '葬儀社紹介',
		'供花配達レビ' => '供花配達レビ',
		'僧侶手配代行' => '僧侶手配代行',
		'Umie' => 'Umie',
		'散骨手配代行' => '僧侶手配代行-リピート',
		'僧侶手配代行-リピート' => '僧侶手配代行-リピート(3回目)',
		'僧侶手配代行-リピート(3回目)' => '僧侶手配代行-リピート(4回目)',
		'僧侶手配代行-リピート(4回目)' => '僧侶手配代行-リピート(4回目)',
		'格安墓石' => '格安墓石',
		'永代供養' => '永代供養',
		'ベスト仏壇' => 'ベスト仏壇',
		'海洋散骨Umie' => '海洋散骨Umie',
		'インターネット検索' => 'インターネット検索',
		'格安のお仏壇' => '格安のお仏壇',
		'格安の墓石' => '格安の墓石'
	};
}