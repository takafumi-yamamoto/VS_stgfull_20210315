@isTest
private class SeireiShiteiCityT{

    @isTest static void testMethod_case1(){
        TodoufuKen__c TodoufuKen1 = new TodoufuKen__c(
            Name = '北海道',
            PKey__c = '北海道',
            KenCode__c = '1'
        );
        insert TodoufuKen1;
        
        Shikugun__c shikugun1 = new Shikugun__c(
            Name = '北海道札幌市中央区',
            TodoufuKenRef__c = TodoufuKen1.id,
            AreaCode__c = '1101',
            ShikugunMei__c = '札幌市中央区',
            ShikugunMeiFurigana__c = 'さっぽろしちゅうおうく'
        );
        insert shikugun1;
        
        Shikugun__c shikugun2 = new Shikugun__c(
            Name = '北海道札幌市北区',
            TodoufuKenRef__c = TodoufuKen1.id,
            AreaCode__c = '1102',
            ShikugunMei__c = '札幌市北区',
            ShikugunMeiFurigana__c = 'さっぽろしきたく'
        );
        insert shikugun2;
    
        Test.startTest();
        
        new SeireiShiteiCity.Provider().getShikuguns(shikugun1.Id, false);
        
        Test.stopTest();
    }
}