@isTest
public class OboCrossSellTrgT {
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
    
    @isTest public static void get_Handler_instane(){
        Test.startTest();
        OboCrossSellTrg.get_Handler_instane(true,1);
        Test.stopTest();
    }

    @isTest public static void Handler_set_context(){
        Test.startTest();
        new OboCrossSellTrg.Handler().set_context(true,1);
        Test.stopTest();
    }

    @isTest public static void Handler_onBeforeInsert(){
        beginSetUp();
        endSetUp();
        Test.startTest();
        INSERT new OboCrossSell__c(
            OrderDate__c = Date.newInstance(2020,1,1),
            CrossSellStatus__c = '受注'
        );
        Test.stopTest();
    }
    @isTest public static void Handler_onBeforeUpdate(){
        beginSetUp();
        OboCrossSell__c the_OboCrossSell = new OboCrossSell__c(
            OrderDate__c = Date.newInstance(2020,1,1),
            CrossSellStatus__c = '受注'
        );
        INSERT the_OboCrossSell;

        endSetUp();
        Test.startTest();
        UPDATE new OboCrossSell__c( Id = the_OboCrossSell.Id, OrderDate__c = Date.newInstance(2020,1,2) );
        Test.stopTest();
    }
}