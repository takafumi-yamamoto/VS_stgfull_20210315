global class NpYosinTorihikiKanogakuBat implements Database.Batchable<sObject> {

	private class AggregateEntity {
		public String accId;
		public String shukeiNenGetsu;
		public Decimal yosinJogenKingaku;
		public Decimal totleSeikyuYoteiKingaku;
		public AggregateEntity(String accId, String shukeiNenGetsu, Decimal yosinJogenKingaku, Decimal totleSeikyuYoteiKingaku) {
			this.accId = accId;
			this.shukeiNenGetsu = shukeiNenGetsu;
			this.yosinJogenKingaku = yosinJogenKingaku == null ? 0 : yosinJogenKingaku;
			this.totleSeikyuYoteiKingaku = totleSeikyuYoteiKingaku == null ? 0 : totleSeikyuYoteiKingaku;
		}
		public void addSeikyuYoteiKingaku(Decimal seikyuYoteiKingaku) {
			if(seikyuYoteiKingaku == null) return;
			this.totleSeikyuYoteiKingaku = this.totleSeikyuYoteiKingaku + seikyuYoteiKingaku;
		}
	}
			
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator([
			SELECT ID FROM Account WHERE RecordType.DeveloperName = 'SoryoAccount' 
				]);
	}

   	global void execute(Database.BatchableContext BC, List<Account> accounts) {
   		try{
	   		List<Opportunity> opps = [SELECT 
					ID, SeikyuZandakaPartnerExp__c, Utiagebi__c, 
					ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__c,
					ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.YosinRef__r.NpYosinJogenKingaku__c
				FROM Opportunity 
				WHERE RecordType.DeveloperName = 'Obosanbin' 
					AND ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__c <> null
					AND Utiagebi__c >= THIS_MONTH
					AND Utiagebi__c <= NEXT_N_MONTHS:5
					AND ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__c in :accounts
					];

			Map<String, AggregateEntity> aggregateResult = new Map<String, AggregateEntity>();
			for(Opportunity opp : opps){
				String accId = opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__c;
				Date utiagebi = opp.Utiagebi__c;
				String shukeiNenGetsu = DateTime.newInstance(utiagebi.year(), utiagebi.month(), utiagebi.day()).format('yyyyMM');
				String key = accId + shukeiNenGetsu;
				Decimal yosinJogenKingaku = opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.YosinRef__r.NpYosinJogenKingaku__c;
				if(aggregateResult.containsKey(key)) {
					aggregateResult.get(key).addSeikyuYoteiKingaku(opp.SeikyuZandakaPartnerExp__c);
				} else {
					aggregateResult.put(key, new AggregateEntity(accId, shukeiNenGetsu, yosinJogenKingaku, opp.SeikyuZandakaPartnerExp__c));
				}
			}

			this.saveAggregateResult(aggregateResult);
   		} catch(Exception e){
            System.debug(e.getMessage());
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20190110-1700-01', 'NpYosinTorihikiKanogakuBat', '与信限度額監視バッチエラー')
                        .putAttr('Exception', e.getMessage())
                        .putAttr('LineNumber', '' + e.getLineNumber())
                        .putAttr('getStackTraceString', e.getStackTraceString())
            );
        }
	}

	private void saveAggregateResult(Map<String, AggregateEntity> aggregateResult) {
		DateTime now = DateTime.now();
		List<YosinTorihikiKanogaku__c> yosinTorihikiKanogakuList = new List<YosinTorihikiKanogaku__c>();
		for(String key : aggregateResult.keySet()) {
			AggregateEntity aggregateEntity = aggregateResult.get(key);
			yosinTorihikiKanogakuList.add(new YosinTorihikiKanogaku__c(
					SyukeiZikkoTime__c = now,   // 集計実行日時
					AccountRef__c = aggregateEntity.accId,		// 僧侶取引先Ref
					ShukeiNenGetsu__c = aggregateEntity.shukeiNenGetsu,		// 集計年月
					YosinJogenKingaku__c = aggregateEntity.yosinJogenKingaku,		// 与信上限金額
					SeikyuYoteiKingaku__c = aggregateEntity.totleSeikyuYoteiKingaku,		// 請求予定金額
					TorihikiKanogaku__c = aggregateEntity.yosinJogenKingaku - aggregateEntity.totleSeikyuYoteiKingaku	// 取引可能額
				));
		}
		if(yosinTorihikiKanogakuList.size() > 0) insert yosinTorihikiKanogakuList;
	}
	
	global void finish(Database.BatchableContext BC) {
	}
}