@isTest public class D3wTaskCsvFileT {
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
    
    @isTest public static void Filer_get_csv_data(){
        beginSetUp();
        D3wTask__c a_D3wTask = new D3wTask__c(d3w_work_name__c = '-');
        INSERT a_D3wTask;
        new D3wTaskCsvFile.Filer().set_csv_data(a_D3wTask.Id, 'a-csv-data');
        endSetUp();
        Test.startTest();
        new D3wTaskCsvFile.Filer().get_csv_data(a_D3wTask.Id);
        Test.stopTest();
    }
}