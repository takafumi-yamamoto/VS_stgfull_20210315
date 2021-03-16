@isTest
public class KrshTesRyoMeiTrgT {
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

	@isTest static void newInsert(){
		beginSetUp();
		KrshSzkSdnStsRec__c theStsRec = new KrshSzkSdnStsRec__c(
			Krsh_KanriBango__c = 'K1',
			Stage__c = '完了',
			KanryoDate__c = Date.newInstance(2000,1,1)
		);
		INSERT theStsRec;
        endSetUp();

		Test.startTest();
		INSERT New KrshTesRyoMei__c(
			KrshSzkSdnStsRecRef__c = theStsRec.Id
		);
		Test.stopTest();
	}

	@isTest static void logicalDelete(){
		beginSetUp();
		KrshSzkSdnStsRec__c theStsRec = new KrshSzkSdnStsRec__c(
			Krsh_KanriBango__c = 'K1',
			Stage__c = '完了',
			KanryoDate__c = Date.newInstance(2000,1,1)
		);
		INSERT theStsRec;
		KrshTesRyoMei__c theTesRyoMei = 
			New KrshTesRyoMei__c(
				KrshSzkSdnStsRecRef__c = theStsRec.Id
			);
		INSERT theTesRyoMei;
        endSetUp();

		Test.startTest();
		UPDATE New KrshTesRyoMei__c(
			Id = theTesRyoMei.Id,
			IsDeleted__c = true
		);
		Test.stopTest();
	}
}