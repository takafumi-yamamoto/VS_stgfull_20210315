@isTest
private class DashinSoryoLookupT {

    @testSetup
    static void setup() {
        DashinTestData.dashin_test_data_init();
    }

    @isTest
    static void myUnitTest() {
        String searchText = [Select id, KeiyakuBango__c From Keiyaku__c limit 1].get(0).KeiyakuBango__c;
        DashinSoryoLookup.searchDB(3, searchText);
    }
}