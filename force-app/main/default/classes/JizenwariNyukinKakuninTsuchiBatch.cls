global class JizenwariNyukinKakuninTsuchiBatch implements Database.Batchable<sObject>,Schedulable  {

	public JizenwariNyukinKakuninTsuchiBatch(){}


	/** スケジュール起動*/
	global void execute(SchedulableContext sc) {
	Integer theBatchSize = 200;
	System.debug('### Returned batch process ID: ' + Database.executeBatch(new JizenwariNyukinKakuninTsuchiBatch(), theBatchSize));
	}


	/* 開始メソッド **/
	global Database.QueryLocator start(Database.BatchableContext BC) {

		System.debug('---JizenwariNyukinKakuninTsuchiBatch開始---');

		return getQueryLocator();
	}


	/* 実行メソッド **/
	global void execute(Database.BatchableContext BC, List<Jizenwari__c> jizenwariList) {

		JizenwariMailSoshinHantei__c customSetting = JizenwariMailSoshinHantei__c.getValues('default');
		new Ctl_JizenwariNyukinKakuninTsuchi().processingOfNyukinKakuninTsuchi(jizenwariList, customSetting.MoushikomiKanryoBiHanteiHizuke__c);
    }

	/* 終了メソッド **/
	global void finish(Database.BatchableContext BC) {

	}



	private Database.QueryLocator getQueryLocator() {

		return Database.getQueryLocator(
		                  [
		                    SELECT 
		                        id,
		                        KeiyakuSha__c,
								NyukinKakuninTsuchiBi__c
		                    From 
		                      Jizenwari__c
		                    Where
		                      (
		                      		KeiyakuStatusCdExp__c = 'Active'
		                    	OR
		                      		KeiyakuStatusCdExp__c = 'Activating'
		                      )
		                    AND
		                    	KeiyakuSha__c != null
		                    AND
		                    	NyukinKakuninTsuchiBi__c = null
		                    AND
		                    	KeiyakuSha__r.MemberKubunCode__c != 'NotMember'
		                  ]
		                );
	}
}