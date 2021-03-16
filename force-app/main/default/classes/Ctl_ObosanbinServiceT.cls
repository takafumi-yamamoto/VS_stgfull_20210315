@isTest
public class Ctl_ObosanbinServiceT {
     private static void beginSetUp(){
          Utility_Common.isMimicExecAsDataIkouProfile = true;
     }
	private static void endSetUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
            FirstName = '_', LastName = '_'
        );
		Utility_Common.isMimicExecAsDataIkouProfile = false;
	}

	@isTest
	public static void FrontToObosanbinNittei(){

		Api_V1_ObousanbinMoushikomi.Tsuika_nitteis theNittei = new Api_V1_ObousanbinMoushikomi.Tsuika_nitteis();
		theNittei.plan_name = '_';
		theNittei.yotei_date = '2020-01-01';
		theNittei.jizen_tsuchi_kibo = '_';
		theNittei.jizen_tsuchi_yotei_date = '2020-01-01';

		Test.startTest();
			new Ctl_ObosanbinService.ObosanbinNittei().FrontToObosanbinNittei( new Case(), new List<Api_V1_ObousanbinMoushikomi.Tsuika_nitteis>{theNittei} );
		Test.stopTest();
	}

	@isTest
	public static void ObosanbinWebYouyaku_start(){
		beginSetUp();
		endSetUp();
		Api_V1_ObousanbinMoushikomi.Data theYoyakuData = new Api_V1_ObousanbinMoushikomi.Data();
		Test.startTest();
			new Ctl_ObosanbinService.ObosanbinWebYouyaku().start( JSON.Serialize(theYoyakuData) );
		Test.stopTest();
	}

	@isTest
	public static void CaseToShodanTaskJob_run(){
		beginSetUp();
		
		Api_V1_ObousanbinMoushikomi.Data theYoyakuData = new Api_V1_ObousanbinMoushikomi.Data();
		ObouYoyakuCaseToShodanTask__c theTask = new ObouYoyakuCaseToShodanTask__c(
			data__c = JSON.Serialize(theYoyakuData)
		);
		INSERT theTask;
		endSetUp();
		Test.startTest();
			new Ctl_ObosanbinService.CaseToShodanTaskJob(theTask.Id).run();
		Test.stopTest();
	}
}