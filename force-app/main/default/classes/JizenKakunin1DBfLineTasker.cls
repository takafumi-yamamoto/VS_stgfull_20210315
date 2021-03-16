global class JizenKakunin1DBfLineTasker implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts,Schedulable {
	/** スケジュール起動*/
	global void execute(SchedulableContext sc) {
		Integer theBatchSize = 200;
		Database.executeBatch(new JizenKakunin1DBfLineTasker(), theBatchSize);
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		List<String> syoriObosanPlan = HouyoPlans.getHoyoPlans();
		return Database.getQueryLocator([
				Select 
					id, 
					ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__c //窓口僧侶
				FROM Opportunity
				WHERE StageName = '施行待ち'
				AND KakuteibiSyodan__c != null
				AND SubPhase__c = '事前確認連絡1日前（システム）'
				AND ObosanbinRef__r.MemorialServicePlan__c in :syoriObosanPlan  //お坊さん便-プラン
				AND ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.IsOboStLineAcnt__c = True
				AND ObosanbinRef__r.KokubetsuDateTime_Inp__c = TOMORROW
			]);
	}

   	global void execute(Database.BatchableContext BC, List<Opportunity> oppList) {
		// 事前確認1DBLine送信タスクを作成
		List<JizenKakunin1DBfLineTask__c> jizenkakunin7dblinetaskList = new List<JizenKakunin1DBfLineTask__c>();
		for(Opportunity opp : oppList){
			JizenKakunin1DBfLineTask__c jizenKakunin1DBfLineTask = new JizenKakunin1DBfLineTask__c(
																					AccountRef__c = opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__c,
																					Msg__c = getMsgBody(),
																					OppRef__c =	opp.id,
																					ShoriStatus__c = 'Created'
																				);
			jizenkakunin7dblinetaskList.add(jizenKakunin1DBfLineTask);
		}
		insert jizenkakunin7dblinetaskList;
	}
	
	global void finish(Database.BatchableContext BC) {}

    private String getMsgBody(){
        String msg = 'お坊さん便です。ご依頼している法要の前日確認です。\n' +
                     'お勤め宜しくお願い致します。\n' +
                     'ご変更やご不明点御座いましたらご連絡をお願い致します。\n';
        return msg;
    }

}