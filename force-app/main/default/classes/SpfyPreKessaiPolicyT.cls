@isTest
public class SpfyPreKessaiPolicyT {
    @isTest public static void PreKessaiPolicy_isKessaiOk() {
        Test.startTest();
        Boolean theKessaiOk = new SpfyPreKessaiPolicy.PreKessaiPolicy().isKessaiOk('_', 'pending');
        Test.stopTest();
        System.assertEquals(false, theKessaiOk);
    }
}