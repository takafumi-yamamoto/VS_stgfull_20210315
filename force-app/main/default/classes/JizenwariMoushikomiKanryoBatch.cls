global class JizenwariMoushikomiKanryoBatch implements Database.Batchable<sObject>,Schedulable  {

	public JizenwariMoushikomiKanryoBatch(){}


	/** スケジュール起動*/
	global void execute(SchedulableContext sc) {
	Integer theBatchSize = 200;
	System.debug('### Returned batch process ID: ' + Database.executeBatch(new JizenwariMoushikomiKanryoBatch(), theBatchSize));
	}


	/* 開始メソッド **/
	global Database.QueryLocator start(Database.BatchableContext BC) {

	return getQueryLocator();
	}


	/* 実行メソッド **/
	global void execute(Database.BatchableContext BC, List<Opportunity> opps) {

		List<JizenwariShodan> theJizenwariShodans = new Ctl_JizenwariMoushikomiKanryo().moushikomiKanryo(opps);

        List<Opportunity> theOppsToBeUpdated = new List<Opportunity>();
        List<Jizenwari__c> theJizenwarisToBeUpdated = new List<Jizenwari__c>();
        for(JizenwariShodan aJizenwariShodan : theJizenwariShodans){
            theOppsToBeUpdated.add(aJizenwariShodan.Opp);
            theJizenwarisToBeUpdated.add(aJizenwariShodan.Jizenwari);
        }
        update theOppsToBeUpdated;
        update theJizenwarisToBeUpdated;

    }

	/* 終了メソッド **/
	global void finish(Database.BatchableContext BC) {

	}



	private Database.QueryLocator getQueryLocator() {

		return Database.getQueryLocator
        (
            [
            SELECT Id, StageName, JizenwariRef__c, 
            JizenwariRef__r.KeiyakuStatusCdExp__c, SeikyuZandaka__c, KessaiKingakuGoukei__c, RecordType.DeveloperName
            FROM Opportunity
            WHERE JizenwariRef__c != NULL
            AND StageName IN ('問合せ受付','申込')
            AND SeikyuZandaka__c <= 0 
            AND KessaiKingakuGoukei__c > 0
            AND RecordType.DeveloperName = 'Simple_Jizenwari'
            ]
        );
	}



}