@isTest
public class SimpleOppValidationT {

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
    public static void onOppBeforeUpdate(){
        beginSetUp();

        Account theAccounts = new Account(
                                            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                                            FirstName = '_', LastName = '_'
                                        );
        INSERT theAccounts;

        SimpleYasugo__c theSimple = new SimpleYasugo__c();
        INSERT theSimple;

        Opportunity theOpp = new Opportunity(
                                            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                                            Name = '_',
                                            AccountId = theAccounts.Id,
                                            StageName = '_',
                                            CloseDate = Date.newInstance(2000,1,1),
                                            SimpleYasugoRef__c = theSimple.Id,
                                            KiboShiharaiHouhou__c = '現金'
                                        );
        INSERT theOpp;

        endSetUp();
        Test.startTest();

        theOpp.StageName = '決定';
        update theOpp;

        Test.stopTest();
    }
}