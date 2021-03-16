global class Bat_ObosanJizenSmsCreator1DaysBf implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts,Schedulable {
	
	/** スケジュール起動*/
    global void execute(SchedulableContext sc) {
        Integer theBatchSize = 200;
        Database.executeBatch(new Bat_ObosanJizenSmsCreator1DaysBf(), theBatchSize);
    }
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		List<String> syoriObosanPlan = HouyoPlans.getHoyoPlans();
		return Database.getQueryLocator([
				Select 
					id, 
					SubPhase__c,
					ShodanBangoF__c,
					ObosanbinRef__c,
					ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__c, //窓口僧侶
					ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.MobilePhoneFormula__c  //窓口僧侶連絡先
				FROM Opportunity
				WHERE StageName = '施行待ち'
				AND KakuteibiSyodan__c != null
                AND SubPhase__c = '事前確認連絡1日前（SMS）'
				AND ObosanbinRef__r.MemorialServicePlan__c in :syoriObosanPlan  //お坊さん便-プラン
                AND ObosanbinRef__r.JizenSmsBf1Status__c = null
                AND ObosanbinRef__r.KokubetsuDateTime_Inp__c = TOMORROW
			]);
	}

   	global void execute(Database.BatchableContext BC, List<Opportunity> oppList) {
   		List<JizenKakuninSmsTask__c> jizenkakuninsmstaskList = this.createTasks(oppList);
   		this.createJizenKakuninSmsTaskMsg(jizenkakuninsmstaskList, oppList);
   		this.updateObosanbinStatus(oppList);
	}
	
	global void finish(Database.BatchableContext BC) {}

	private List<JizenKakuninSmsTask__c> createTasks(List<Opportunity> oppList) {
		// 事前確認SMS送信タスクを作成
		List<JizenKakuninSmsTask__c> jizenkakuninsmstaskList = new List<JizenKakuninSmsTask__c>();
		for(Opportunity opp : oppList){
			JizenKakuninSmsTask__c jizenkakuninsmstask = new JizenKakuninSmsTask__c();
			jizenkakuninsmstask.JizenKakuninKbn__c = '1日前';
			jizenkakuninsmstask.OpportunityRef__c = opp.id;    //商談
			jizenkakuninsmstask.AccountRef__c = opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__c;    //取引先
			jizenkakuninsmstask.ShoriStatus__c = 'Created';    //処理ステータス
			jizenkakuninsmstaskList.add(jizenkakuninsmstask);
		}
		insert jizenkakuninsmstaskList;
		return jizenkakuninsmstaskList;
	}

	private List<JizenKakuninSmsTaskMsg__c> createJizenKakuninSmsTaskMsg(List<JizenKakuninSmsTask__c> jizenkakuninsmstaskList, List<Opportunity> oppList) {
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(oppList);
		// メッセージ
		List<JizenKakuninSmsTaskMsg__c> jizenkakuninsmstaskmsgList = new List<JizenKakuninSmsTaskMsg__c>();
        Integer theCounter = 0;
		for(JizenKakuninSmsTask__c task : jizenkakuninsmstaskList){
            theCounter ++;
			Opportunity opp = oppMap.get(task.OpportunityRef__c);
			String phone = opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.MobilePhoneFormula__c;
			Integer sequence = theCounter;
			JizenKakuninSmsTaskMsg__c jizenkakuninsmstaskmsg = new JizenKakuninSmsTaskMsg__c();
			jizenkakuninsmstaskmsg.PhoneNo__c = phone  ;    //PhoneNo
			jizenkakuninsmstaskmsg.ClientTag__c = Bat_ObosanJizenSmsCreator.buildClientTag(sequence, phone, task.Id)  ;    //ClientTag
			jizenkakuninsmstaskmsg.MsgBody__c = getMsgBody();    //MsgBody
			jizenkakuninsmstaskmsg.JizenKakuninSmsTaskRef__c = task.id;
			jizenkakuninsmstaskmsgList.add(jizenkakuninsmstaskmsg);
		}
		insert jizenkakuninsmstaskmsgList;
		return jizenkakuninsmstaskmsgList;
	}

	private void updateObosanbinStatus(List<Opportunity> oppList){
		List<Obosanbin__c> oboList = new List<Obosanbin__c>();
		for(Opportunity opp : oppList){
			Obosanbin__c obo =  new Obosanbin__c(Id = opp.ObosanbinRef__c);
            obo.JizenSmsBf1Status__c = '送信準備';
			oboList.add(obo);
		}
		update oboList;
		update oppList;
	}

    private String getMsgBody(){
        String msg = 'お坊さん便です。ご依頼している法要の前日確認です。\n' +
                     'お勤め宜しくお願い致します。\n' +
                     'ご変更やご不明点御座いましたらご連絡をお願い致します。\n';
        return msg;
    }
}