@isTest
private class Sogsok_TsuikaHinBunrui_201101T {
    
    @isTest static void testMethod_case1(){

        Test.startTest();

        Sogsok_TsuikaHinBunrui_201101.getEntries();
        Map<String, String> BindToSimpleShohinCd =  Sogsok_TsuikaHinBunrui_201101.BindToSimpleShohinCd;
        Sogsok_TsuikaHinBunrui_201101.getShohinCdToProductMap();
        Sogsok_TsuikaHinBunrui_201101.getProduct('SBG-0002010');
        Sogsok_TsuikaHinBunrui_201101.tryGetKeyFromShohinCd('SBG-0002010');
        
        Test.stopTest();
    }
}