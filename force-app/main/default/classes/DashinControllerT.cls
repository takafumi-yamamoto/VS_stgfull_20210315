@isTest
private class DashinControllerT {

    @testSetup
    static void setup() {
        DashinTestData.dashin_test_data_init();
    }

    @isTest
    static void test_checkAnkenNaiyo() {

        List<Opportunity> opps = [Select Id, ObosanbinRef__c,  ObosanbinRef__r.MemorialServicePlan__c From Opportunity
                                     Where Name like 'NULL%'];

        Test.StartTest();

        for(Opportunity opp : opps){
            DashinController.AnkenNaiyo ankennaiyo = DashinController.searchAnkenNaiyo(opp.Id);
        }

        Test.StopTest();
    }

    @isTest
    static void test_Hoyo() {

        Test.StartTest();
        List<Opportunity> opps = [Select Id, ObosanbinRef__c,  ObosanbinRef__r.MemorialServicePlan__c From Opportunity
                                     Where Name like '法要_%'];

        DashinController.AnkenNaiyo ankennaiyo = DashinController.searchAnkenNaiyo(opps.get(0).Id);
        System.debug(AnkenNaiyo);


        DashinController.doSearchDashinSaki(json.serialize(new Map<String, String>{'simei_soryo' => ''}), json.serialize(ankennaiyo));


        DashinController.DashIraiRequest req = new DashinController.DashIraiRequest();
        req.ankenNaiyo = ankennaiyo;
        req.dashinSakiList = new List<DashinController.DashinSaki>();
        req.is_repeat = false;
        DashinController.doSendDashinIrai(json.serialize(req));

        Test.StopTest();
    }

    @isTest
    static void test_Kaimyo() {
        Test.StartTest();
        List<Opportunity> opps = [Select Id, ObosanbinRef__c,  ObosanbinRef__r.MemorialServicePlan__c From Opportunity
                                     Where Name like '戒名のみ_%'];

        DashinController.AnkenNaiyo ankennaiyo = DashinController.searchAnkenNaiyo(opps.get(0).Id);
        System.debug(AnkenNaiyo);


        DashinController.doSearchDashinSaki(json.serialize(new Map<String, String>{'simei_soryo' => ''}), json.serialize(ankennaiyo));


        DashinController.DashIraiRequest req = new DashinController.DashIraiRequest();
        req.ankenNaiyo = ankennaiyo;
        req.dashinSakiList = new List<DashinController.DashinSaki>();
        req.is_repeat = false;
        DashinController.doSendDashinIrai(json.serialize(req));

        Test.StopTest();
    }

    @isTest
    static void test_Sogi() {
        Test.StartTest();
        List<Opportunity> opps = [Select Id, ObosanbinRef__c,  ObosanbinRef__r.MemorialServicePlan__c From Opportunity
                                     Where Name like '葬儀_%'];

        DashinController.AnkenNaiyo ankennaiyo = DashinController.searchAnkenNaiyo(opps.get(0).Id);
        System.debug(AnkenNaiyo);


        DashinController.doSearchDashinSaki(json.serialize(new Map<String, String>{'simei_soryo' => ''}), json.serialize(ankennaiyo));


        DashinController.DashIraiRequest req = new DashinController.DashIraiRequest();
        req.ankenNaiyo = ankennaiyo;
        req.dashinSakiList = new List<DashinController.DashinSaki>();
        req.is_repeat = false;
        DashinController.doSendDashinIrai(json.serialize(req));

        Test.StopTest();
    }
}