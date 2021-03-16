@isTest 
public class AffiCaseCreTaskT {

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


	@isTest static void withNoParent(){

		beginSetUp();
		AffiCaseCreTask.Data theAffData = new AffiCaseCreTask.Data();
		theAffData.gaclient_id = '_';
		theAffData.mailshori_id = '1';
		theAffData.parent_mailshori_id = 'none';
		theAffData.toiawase_date = '2000-01-01';
		theAffData.cust_name_sei = '_';
		theAffData.cust_name_mei = '_';
		theAffData.cust_name_sei_kana = '_';
		theAffData.cust_name_mei_kana = '_';
		theAffData.mail_address = '';
		theAffData.tel_no = '08000000000';
		theAffData.postal_code = '_';
		theAffData.state = '_';
		theAffData.city = '_';
		theAffData.street = '_';
		theAffData.cust_comment = '_';
		theAffData.service = '_';

		AffiCaseCreTask__c theTask = new AffiCaseCreTask__c(
			data__c = JSON.serialize(theAffData),
			parent_mailshori_id__c = 'none'
		);
		INSERT theTask;

		endSetUp();
		Test.startTest();
		new AffiCaseCreTask(theTask.Id).runTask(theTask.Id);
		Test.stopTest();
	}

	@isTest static void withParent(){

		beginSetUp();
		INSERT New Case(
			Status = '_',
			parent_mailshori_id__c = 'parent001'
		);

		AffiCaseCreTask.Data theAffData = new AffiCaseCreTask.Data();
		theAffData.gaclient_id = '_';
		theAffData.mailshori_id = 'child001';
		theAffData.parent_mailshori_id = 'parent001';
		theAffData.toiawase_date = '2000-01-01';
		theAffData.cust_name_sei = '_';
		theAffData.cust_name_mei = '_';
		theAffData.cust_name_sei_kana = '_';
		theAffData.cust_name_mei_kana = '_';
		theAffData.mail_address = '';
		theAffData.tel_no = '08000000000';
		theAffData.postal_code = '_';
		theAffData.state = '_';
		theAffData.city = '_';
		theAffData.street = '_';
		theAffData.cust_comment = '_';
		theAffData.service = '_';

		AffiCaseCreTask__c theTask = new AffiCaseCreTask__c(
			data__c = JSON.serialize(theAffData),
			parent_mailshori_id__c = 'parent001'
		);
		INSERT theTask;

		endSetUp();
		Test.startTest();
		new AffiCaseCreTask(theTask.Id).runTask(theTask.Id);
		Test.stopTest();
	}
}