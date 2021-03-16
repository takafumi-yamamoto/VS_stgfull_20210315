@isTest
public class Tes_SeizenKeiyaku {

	static testMethod void testCase(){

		TriggerIsActive__c customSetting = new TriggerIsActive__c(Name = 'defualt',isActive__c = true);
		insert customSetting;
		JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;  
        Id accRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer');
        Account sodansha = new Account(LastName = '相談者',FirstName = 'テスト',RecordTypeId = accRecordTypeId);
        
		sodansha.LastNameFurigana__pc ='defualt';
		sodansha.FirstNameFurigana__pc ='defualt';
		sodansha.Phone='080-0000-0001';
		sodansha.MobilePhone__c='080-0000-0001';
        insert sodansha;


		SeizenKeiyaku__c seizenKeiyaku = new SeizenKeiyaku__c(KeiyakuKaishiBi__c = Date.Today().addMonths(-1));
		insert seizenKeiyaku;


		// サービス商談作成
		Id oppRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Seizenkeiyaku');
		Opportunity opp = new Opportunity(
											Name = 'テスト商談',
											AccountId = sodansha.Id,
											StageName = '問合せ受付',
											CloseDate = date.Today(),
											RecordTypeId = oppRecordTypeId,
											SeizenKeiyakuRef__c = seizenKeiyaku.Id
										);
	    insert opp;


		seizenKeiyaku.KeiyakuKaishiBi__c = Date.Today();
		update seizenKeiyaku;
	}

}