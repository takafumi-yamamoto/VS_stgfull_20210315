@isTest
public class TcmsTaioRkImpDataTrgT {
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

    public class IValidationOnBefore_Stub implements TcmsTaioRkImpDataValids.IValidationOnBefore{
        public void validate( TcmsTaioRkImpData__c aNewOne ){ return; }
    }
    @isTest public static void Handler_set_context(){
        Test.startTest();
        new TcmsTaioRkImpDataTrg.Handler( new IValidationOnBefore_Stub() ).set_context(true,1);
        Test.stopTest();
    }

    @isTest public static void Handler_onBeforeInsert(){
        Test.startTest();
        new TcmsTaioRkImpDataTrg.Handler( new IValidationOnBefore_Stub() ).onBeforeInsert( new List<TcmsTaioRkImpData__c>{ new TcmsTaioRkImpData__c(TcmsSeqNo__c = '1') });
        Test.stopTest();
    }

    @isTest public static void Handler_onBeforeUpdate(){
        beginSetUp();
        TcmsTaioRkImpData__c the_TcmsTaioRkImpData = new TcmsTaioRkImpData__c(TcmsSeqNo__c = '1');
        INSERT the_TcmsTaioRkImpData;
        endSetUp();
        Test.startTest();
        new TcmsTaioRkImpDataTrg.Handler( new IValidationOnBefore_Stub() ).onBeforeUpdate( 
            new List<TcmsTaioRkImpData__c>{ the_TcmsTaioRkImpData },
            new Map<Id, TcmsTaioRkImpData__c>{ the_TcmsTaioRkImpData.Id => the_TcmsTaioRkImpData }
        );
        Test.stopTest();
    }

    @isTest public static void get_Handler_instane(){
        Test.startTest();
        TcmsTaioRkImpDataTrg.get_Handler_instane(true, 1);
        Test.stopTest();
    }
}