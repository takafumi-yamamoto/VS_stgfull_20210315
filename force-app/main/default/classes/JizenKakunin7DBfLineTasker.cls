global class JizenKakunin7DBfLineTasker implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts,Schedulable {
	/** スケジュール起動*/
	global void execute(SchedulableContext sc) {
		Integer theBatchSize = 200;
		Database.executeBatch(new JizenKakunin7DBfLineTasker(), theBatchSize);
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		List<String> syoriObosanPlan = HouyoPlans.getHoyoPlans();
		return Database.getQueryLocator([
				Select 
					id, 
					ObosanbinRef__r.KokubetsuDateTime_Inp__c,
					Account.lastname,
					ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__c //窓口僧侶
				FROM Opportunity
				WHERE StageName = '施行待ち'
				AND KakuteibiSyodan__c != null
				AND SubPhase__c = '事前確認連絡7日前（システム）'
				AND ObosanbinRef__r.MemorialServicePlan__c in :syoriObosanPlan  //お坊さん便-プラン
				// AND ObosanbinRef__r.JizenSmsBf7Status__c = null
				AND ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.IsOboStLineAcnt__c = True
				AND ObosanbinRef__r.KokubetsuDateTime_Inp__c = NEXT_N_DAYS:7
				AND ObosanbinRef__r.KokubetsuDateTime_Inp__c > TOMORROW
			]);
	}

   	global void execute(Database.BatchableContext BC, List<Opportunity> oppList) {
		// 事前確認7DBLine送信タスクを作成
		List<JizenKakunin7DBfLineTask__c> jizenkakunin7dblinetaskList = new List<JizenKakunin7DBfLineTask__c>();
		for(Opportunity opp : oppList){
			JizenKakunin7DBfLineTask__c jizenKakunin7DBfLineTask = new JizenKakunin7DBfLineTask__c(
																					AccountRef__c = opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__c,
																					Msg__c = getMsgBody(opp.Account.lastname, opp.ObosanbinRef__r.KokubetsuDateTime_Inp__c),
																					OppRef__c =	opp.id,
																					ShoriStatus__c = 'Created'
																				);
			jizenkakunin7dblinetaskList.add(jizenKakunin7DBfLineTask);
		}
		insert jizenkakunin7dblinetaskList;
	}
	
	global void finish(Database.BatchableContext BC) {}

	private String getMsgBody(String lastname, Datetime houyobi){
		String msg = 'お坊さん便です。ご依頼している法要の1週間前のご確認です。\n' +
					 '{LASTNAME}様からのご依頼で{HOUYOUBI}の法要です。\n' +
					 'こちらは送信専用となりますので、\nご変更・ご不明点ありましたらお坊さん便コールセンター03-5348-6053までお電話お願い致します。';
		String houyobiStr = '';
		if(houyobi != null) houyobiStr = houyobi.format('yyyy/MM/dd HH:mm');
		return msg.replace('{LASTNAME}', lastname).replace('{HOUYOUBI}', houyobiStr);
	}

}