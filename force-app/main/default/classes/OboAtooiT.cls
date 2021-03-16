@isTest
public class OboAtooiT {
    private static void setUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
    }

    @isTest
    public static void doTest(){
        setUp();

        Map<String, Obosanbin__c> theObosanbins = new Map<String, Obosanbin__c>{
            '1' => new Obosanbin__c()
        };

        Insert theObosanbins.get('1');

        theObosanbins.get('1').AtooiKekka__c = '受注';
        Update theObosanbins.get('1');
    }
}