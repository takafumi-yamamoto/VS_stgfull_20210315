public class OboStSynVer {

	public void OnAccountAfterUpdate(List<Account> pNewOnes, Map<ID, Account> pOldOnes){
		List<Id> theTargetAccountIds = new List<Id>();
		for(Account aNewOne : pNewOnes){
			if(aNewOne.RecordTypeId != Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId()) continue;
			Account aOldOne = pOldOnes.get(aNewOne.Id);
			if(this.isStockInfoChangedOnAccount(aNewOne, aOldOne)) theTargetAccountIds.add(aNewOne.Id);
		}
		if(theTargetAccountIds.size() == 0) return;

		List<Keiyaku__c> theActiveObouKeiyakus = [
			SELECT id, KeiyakuBango__c 
			FROM Keiyaku__c 
			WHERE Teikeisaki__c = :theTargetAccountIds
			AND RecordType.DeveloperName = 'Obosanbin'
			AND KeiyakuJokyo__c = '契約中'
		];

		Set<String> theKeiyakuBangosToBeVersionUp = new Set<String>();
		for(Keiyaku__c aKeiyaku : theActiveObouKeiyakus){ theKeiyakuBangosToBeVersionUp.add(aKeiyaku.KeiyakuBango__c); }
		this.updateVersions(theKeiyakuBangosToBeVersionUp);
	}

	private Boolean isStockInfoChangedOnAccount(Account pNewOne, Account pOldOne){
		if(pNewOne.Name != pOldOne.Name) return true;
		if(pNewOne.MobilePhone__c != pOldOne.MobilePhone__c) return true; //携帯1-携帯電話番号
		if(pNewOne.Seinengappi__c != pOldOne.Seinengappi__c) return true; //生年月日
		if(pNewOne.BillingPostalCode != pOldOne.BillingPostalCode) return true;
		if(pNewOne.BillingState != pOldOne.BillingState) return true;
		if(pNewOne.BillingCity != pOldOne.BillingCity) return true;
		if(pNewOne.BillingStreet != pOldOne.BillingStreet) return true;
		if(pNewOne.BillingLatitude != pOldOne.BillingLatitude) return true;
		if(pNewOne.ShozokuSangouSangoJiin__c != pOldOne.ShozokuSangouSangoJiin__c) return true; //所属山号寺院
		if(pNewOne.PartnerHyokaRef__c != pOldOne.PartnerHyokaRef__c) return true; //パートナー評価
		return false;
	}

	public void OnAccountBeforeDelete(List<Account> pOldOnes){
		List<Id> theTargetAccountIds = new List<Id>();
		for(Account aOldOne : pOldOnes){
			if(aOldOne.RecordTypeId != Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId()) continue;
			theTargetAccountIds.add(aOldOne.Id);
		}
		if(theTargetAccountIds.size() == 0) return;

		List<Keiyaku__c> theActiveObouKeiyakus = [
			SELECT id, KeiyakuBango__c 
			FROM Keiyaku__c 
			WHERE Teikeisaki__c = :theTargetAccountIds
			AND RecordType.DeveloperName = 'Obosanbin'
			AND KeiyakuJokyo__c = '契約中'
		];

		Set<String> theKeiyakuBangosToBeVersionUp = new Set<String>();
		for(Keiyaku__c aKeiyaku : theActiveObouKeiyakus){ theKeiyakuBangosToBeVersionUp.add(aKeiyaku.KeiyakuBango__c); }
		this.updateVersions(theKeiyakuBangosToBeVersionUp);
	}

	public void OnPartnerKeiyakuAfterUpdate(List<Keiyaku__c> pNewOnes, Map<ID, Keiyaku__c> pOldOnes){
		List<Keiyaku__c> theObouKeiyakuTargets = new List<Keiyaku__c>();
		List<Keiyaku__c> theJohoKeiyakuTargets = new List<Keiyaku__c>();

		for(Keiyaku__c aNewOne : pNewOnes){
			Keiyaku__c aOldOne = pOldOnes.get(aNewOne.Id);
			if(this.isStockInfoChangedOnPartnerKeiyaku(aNewOne, aOldOne)) theObouKeiyakuTargets.add(aNewOne);
			if(this.isStockInfoChangedOnPartnerKeiyakuJohouSya(aNewOne, aOldOne)) theJohoKeiyakuTargets.add(aNewOne);
		}

		Set<String> theKeiyakuBangosToBeVersionUp = new Set<String>();
		for(Keiyaku__c aKeiyaku : theObouKeiyakuTargets){
			theKeiyakuBangosToBeVersionUp.add(aKeiyaku.KeiyakuBango__c);
		}
		if(theJohoKeiyakuTargets.size() > 0) {
			Set<Id> theSyukeiyakuIds = new Set<Id>();
			for(Keiyaku__c aJohoKeiyaku : theJohoKeiyakuTargets){ theSyukeiyakuIds.add( aJohoKeiyaku.SyuKeiyakuRef__c); }
			List<Keiyaku__c> theShuKeiyakus = [
				select Id, KeiyakuBango__c
				from Keiyaku__c
				where Id = :theSyukeiyakuIds
				AND RecordType.DeveloperName = 'Obosanbin'
				AND KeiyakuJokyo__c = '契約中'
			];
			for(Keiyaku__c aSyuKeiyaku : theShuKeiyakus){ theKeiyakuBangosToBeVersionUp.add( aSyuKeiyaku.KeiyakuBango__c); }
		}

		this.updateVersions(theKeiyakuBangosToBeVersionUp);
	}
	private Boolean isStockInfoChangedOnPartnerKeiyaku(Keiyaku__c pNewOne, Keiyaku__c pOldOne){
		if(pNewOne.RecordTypeId != Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId()) return false;
		if(pNewOne.KeiyakuJokyo__c != pOldOne.KeiyakuJokyo__c) return true; // 契約状況
		if(pNewOne.Kaimyojuyonomiirai__c != pOldOne.Kaimyojuyonomiirai__c) return true; // 戒名授与のみ依頼
		if(pNewOne.AmazonTaioka__c != pOldOne.AmazonTaioka__c) return true; // Amazon対応可
		if(pNewOne.TeigakuTehaiTaioKahi__c != pOldOne.TeigakuTehaiTaioKahi__c) return true; // 対応不可プラン
		if(pNewOne.TaioufukaDay__c != pOldOne.TaioufukaDay__c) return true; // 対応不可曜日
		return false;
	}
	private Boolean isStockInfoChangedOnPartnerKeiyakuJohouSya(Keiyaku__c pNewOne, Keiyaku__c pOldOne){
		if(pNewOne.RecordTypeId != Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('ObousanBinJohouSya').getRecordTypeId()) return false;
		if(pNewOne.KeiyakuJokyo__c != pOldOne.KeiyakuJokyo__c) return true; // 契約状況
		return false;
	}

	public void OnPartnerKeiyakuAfterInsert(List<Keiyaku__c> pNewOnes){
		List<Keiyaku__c> theObouKeiyakuTargets = new List<Keiyaku__c>();
		List<Keiyaku__c> theJohoKeiyakuTargets = new List<Keiyaku__c>();

		for(Keiyaku__c aNewOne : pNewOnes){

			if( aNewOne.RecordTypeId == Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId() ){
				if(aNewOne.KeiyakuJokyo__c == '契約中') theObouKeiyakuTargets.add(aNewOne);
			}
			if( aNewOne.RecordTypeId == Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('ObousanBinJohouSya').getRecordTypeId() ){
				if(aNewOne.KeiyakuJokyo__c == '契約中') theJohoKeiyakuTargets.add(aNewOne);
			}
		}

		Set<String> theKeiyakuBangosToBeVersionUp = new Set<String>();
		for(Keiyaku__c aKeiyaku : theObouKeiyakuTargets){
			theKeiyakuBangosToBeVersionUp.add(aKeiyaku.KeiyakuBango__c);
		}
		if(theJohoKeiyakuTargets.size() > 0) {
			Set<Id> theSyukeiyakuIds = new Set<Id>();
			for(Keiyaku__c aJohoKeiyaku : theJohoKeiyakuTargets){ theSyukeiyakuIds.add( aJohoKeiyaku.SyuKeiyakuRef__c); }
			List<Keiyaku__c> theShuKeiyakus = [
				select Id, KeiyakuBango__c
				from Keiyaku__c
				where Id = :theSyukeiyakuIds
				AND RecordType.DeveloperName = 'Obosanbin'
				AND KeiyakuJokyo__c = '契約中'
			];
			for(Keiyaku__c aSyuKeiyaku : theShuKeiyakus){ theKeiyakuBangosToBeVersionUp.add( aSyuKeiyaku.KeiyakuBango__c); }
		}

		this.updateVersions(theKeiyakuBangosToBeVersionUp);
	}

	public void OnPartnerKeiyakuBeforeDelete(List<Keiyaku__c> pOldOnes){
		List<Keiyaku__c> theObouKeiyakuTargets = new List<Keiyaku__c>();
		List<Keiyaku__c> theJohoKeiyakuTargets = new List<Keiyaku__c>();

		for(Keiyaku__c aNewOne : pOldOnes){
			if(aNewOne.RecordTypeId == Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId()){
				theObouKeiyakuTargets.add(aNewOne);
			} 
			if(aNewOne.RecordTypeId == Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('ObousanBinJohouSya').getRecordTypeId()){
				theJohoKeiyakuTargets.add(aNewOne);
			}
		}

		Set<String> theKeiyakuBangosToBeVersionUp = new Set<String>();
		for(Keiyaku__c aKeiyaku : theObouKeiyakuTargets){
			theKeiyakuBangosToBeVersionUp.add(aKeiyaku.KeiyakuBango__c);
		}
		if(theJohoKeiyakuTargets.size() > 0) {
			Set<Id> theSyukeiyakuIds = new Set<Id>();
			for(Keiyaku__c aJohoKeiyaku : theJohoKeiyakuTargets){ theSyukeiyakuIds.add( aJohoKeiyaku.SyuKeiyakuRef__c); }
			List<Keiyaku__c> theShuKeiyakus = [
				select Id, KeiyakuBango__c
				from Keiyaku__c
				where Id = :theSyukeiyakuIds
				AND RecordType.DeveloperName = 'Obosanbin'
				AND KeiyakuJokyo__c = '契約中'
			];
			for(Keiyaku__c aSyuKeiyaku : theShuKeiyakus){ theKeiyakuBangosToBeVersionUp.add( aSyuKeiyaku.KeiyakuBango__c); }
		}

		this.updateVersions(theKeiyakuBangosToBeVersionUp);
	}
	// パートナー評価の更新
	public void OnPartnerHyokaAfterUpdate(List<PartnerHyoka__c> newList, Map<ID, PartnerHyoka__c> oldMap){
		Set<PartnerHyoka__c> partnerHyokaSet = new Set<PartnerHyoka__c>();
		for(PartnerHyoka__c aNewOne : newList){
			PartnerHyoka__c aOldOne = oldMap.get(aNewOne.Id);
			if(aNewOne.ServiceRank__c != aOldOne.ServiceRank__c){ //ご出仕ランク
				partnerHyokaSet.add(aNewOne);
			}
		}
		if(partnerHyokaSet.size() == 0) return;

		List<Keiyaku__c> theActiveObouKeiyakus = [
			SELECT id, KeiyakuBango__c, Teikeisaki__c 
			FROM Keiyaku__c 
			WHERE Teikeisaki__r.PartnerHyokaRef__c =: partnerHyokaSet
			AND RecordType.DeveloperName = 'Obosanbin'
			AND KeiyakuJokyo__c = '契約中'
		];

		Set<String> theKeiyakuBangosToBeVersionUp = new Set<String>();
		for(Keiyaku__c aKeiyaku : theActiveObouKeiyakus){ theKeiyakuBangosToBeVersionUp.add(aKeiyaku.KeiyakuBango__c); }
		this.updateVersions(theKeiyakuBangosToBeVersionUp);
	}
	
	//　スケジュール新規
	public void OnPartnerEventAfterInsert(List<Event> newEventList){
		List<Id> contactIds = new List<Id>();
		for(Event evt: newEventList){
			if(evt.WhoId != null) contactIds.add(evt.WhoId);
		}
		List<Contact> theConstacts = [SELECT Id, accountId FROM Contact WHERE account.RecordType.DeveloperName = 'SoryoAccount' and id =: contactIds];
		if(theConstacts.size() == 0 ) return;

		List<Id> theAccountIds = new List<Id>();
		for(Contact aContact : theConstacts){ theAccountIds.add(aContact.accountId); }

		List<Keiyaku__c> theActiveObouKeiyakus = [
			SELECT id, KeiyakuBango__c, Teikeisaki__c 
			FROM Keiyaku__c 
			WHERE Teikeisaki__c =: theAccountIds
			AND RecordType.DeveloperName = 'Obosanbin'
			AND KeiyakuJokyo__c = '契約中'
		];
		Set<String> theKeiyakuBangosToBeVersionUp = new Set<String>();
		for(Keiyaku__c aKeiyaku : theActiveObouKeiyakus){ theKeiyakuBangosToBeVersionUp.add(aKeiyaku.KeiyakuBango__c); }
		this.updateVersions(theKeiyakuBangosToBeVersionUp);
	}

	//　スケジュール更新
	public void OnPartnerEventAfterUpdated(List<Event> newEventList, Map<ID, Event> oldEventMap){
		List<Id> contactIds = new List<Id>();
		for(Event evt: newEventList){
			if(evt.WhoId != null) contactIds.add(evt.WhoId);
		}
		List<Contact> theConstacts = [SELECT Id, accountId FROM Contact WHERE account.RecordType.DeveloperName = 'SoryoAccount' and id =: contactIds];
		if(theConstacts.size() == 0 ) return;

		List<Id> theAccountIds = new List<Id>();
		for(Contact aContact : theConstacts){ theAccountIds.add(aContact.accountId); }

		List<Keiyaku__c> theActiveObouKeiyakus = [
			SELECT id, KeiyakuBango__c, Teikeisaki__c 
			FROM Keiyaku__c 
			WHERE Teikeisaki__c =: theAccountIds
			AND RecordType.DeveloperName = 'Obosanbin'
			AND KeiyakuJokyo__c = '契約中'
		];
		Set<String> theKeiyakuBangosToBeVersionUp = new Set<String>();
		for(Keiyaku__c aKeiyaku : theActiveObouKeiyakus){ theKeiyakuBangosToBeVersionUp.add(aKeiyaku.KeiyakuBango__c); }
		this.updateVersions(theKeiyakuBangosToBeVersionUp);
	}
	
	public void OnPartnerEventAfterDeleted(List<Event> oldEventList){
		List<Id> contactIds = new List<Id>();
		for(Event evt: oldEventList){
			if(evt.WhoId != null) contactIds.add(evt.WhoId);
		}
		List<Contact> theConstacts = [SELECT Id, accountId FROM Contact WHERE account.RecordType.DeveloperName = 'SoryoAccount' and id =: contactIds];
		if(theConstacts.size() == 0 ) return;

		List<Id> theAccountIds = new List<Id>();
		for(Contact aContact : theConstacts){ theAccountIds.add(aContact.accountId); }

		List<Keiyaku__c> theActiveObouKeiyakus = [
			SELECT id, KeiyakuBango__c, Teikeisaki__c 
			FROM Keiyaku__c 
			WHERE Teikeisaki__c =: theAccountIds
			AND RecordType.DeveloperName = 'Obosanbin'
			AND KeiyakuJokyo__c = '契約中'
		];
		Set<String> theKeiyakuBangosToBeVersionUp = new Set<String>();
		for(Keiyaku__c aKeiyaku : theActiveObouKeiyakus){ theKeiyakuBangosToBeVersionUp.add(aKeiyaku.KeiyakuBango__c); }
		this.updateVersions(theKeiyakuBangosToBeVersionUp);
	}

	public void updateVersions( Set<String> pKeiyakuBangos){
		List<OboStSynVersion__c> theOboStSynVersions = new List<OboStSynVersion__c>();
		Long theVersionNumber = Long.valueOf(DateTime.now().format('yyyyMMddHHmmss'));
		for(String aKeiyakuBango : pKeiyakuBangos){
			theOboStSynVersions.add(
				new OboStSynVersion__c( KeiyakuBango__c = aKeiyakuBango, LastVersion__c = theVersionNumber )
			);
		}
		if(theOboStSynVersions.size() > 0) Upsert theOboStSynVersions KeiyakuBango__c;
	}

	// NP与信更新
	public void OnYosinAfterUpdated(List<Yosin__c> newList, Map<ID, Yosin__c> oldMap){
		Set<Yosin__c> yosinSet = new Set<Yosin__c>();
		for(Yosin__c aNewOne : newList){
			Yosin__c aOldOne = oldMap.get(aNewOne.Id);
			if(aNewOne.NpTorihikiTorokuKahi__c != aOldOne.NpTorihikiTorokuKahi__c ||
				aNewOne.NpSaikenHoshoStatus__c != aOldOne.NpSaikenHoshoStatus__c
			){
				yosinSet.add(aNewOne);
			}
		}
		if(yosinSet.size() == 0) return;

		List<Keiyaku__c> theActiveObouKeiyakus = [
			SELECT id, KeiyakuBango__c, Teikeisaki__c 
			FROM Keiyaku__c 
			WHERE Teikeisaki__r.YosinRef__c =: yosinSet
			AND RecordType.DeveloperName = 'Obosanbin'
			AND KeiyakuJokyo__c = '契約中'
		];

		Set<String> theKeiyakuBangosToBeVersionUp = new Set<String>();
		for(Keiyaku__c aKeiyaku : theActiveObouKeiyakus){ theKeiyakuBangosToBeVersionUp.add(aKeiyaku.KeiyakuBango__c); }
		this.updateVersions(theKeiyakuBangosToBeVersionUp);
	}
}