@isTest
public class KrshPubCardCmdTrgT {

    @isTest public static void get_Handler_instane(){
        Test.startTest();
        KrshPubCardCmdTrg.get_Handler_instane(true, 200);
        Test.stopTest();
    }

    @isTest public static void Handler_set_context(){
        Test.startTest();
        new KrshPubCardCmdTrg.Handler().set_context(true, 200);
        Test.stopTest();
    }

    @isTest public static void Handler_onBeforeInsert(){
        Test.startTest();
        new KrshPubCardCmdTrg.Handler().onBeforeInsert(
            new List<KrshPubCardCmd__c>{ new KrshPubCardCmd__c(ShodanBango__c = '1')}
        );
        Test.stopTest(); 
    }
}