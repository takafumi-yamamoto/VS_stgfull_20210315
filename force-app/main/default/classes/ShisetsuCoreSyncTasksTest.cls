@isTest
public class ShisetsuCoreSyncTasksTest {
    @isTest(seeAllData=true)
    public static void scheduleTasksOnShisetsuAfterUpdate(){

        Shikugun__c theShikugun = [
            select id from Shikugun__c limit 1
        ].get(0);

        Map<String, Shisetsu__c> theShisetsus = new Map<String, Shisetsu__c>{
            '1' => new Shisetsu__c(
                Name = '_',
                ShisetsuShubetsu__c = '斎場',
                Shikugun__c = theShikugun.Id,
                ShokaiKinshi__c = false,
                Street__c = 'テスト町１－１'
            )
        };
        Insert theShisetsus.values();

        update new Shisetsu__c(
            Id = theShisetsus.get('1').Id,
            SimpleKeisai__c = true
        );
    }

    @isTest(seeAllData=true)
    public static void scheduleTasksOnShisetsuAfterDelete(){

        Shikugun__c theShikugun = [
            select id from Shikugun__c limit 1
        ].get(0);

        Map<String, Shisetsu__c> theShisetsus = new Map<String, Shisetsu__c>{
            '1' => new Shisetsu__c(
                Name = '_',
                ShisetsuShubetsu__c = '斎場',
                Shikugun__c = theShikugun.Id,
                ShokaiKinshi__c = false,
                Street__c = 'テスト町１－１'
            )
        };
        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200) );
        Insert theShisetsus.values();

        Test.startTest();
        Delete theShisetsus.get('1');
        Test.stopTest();
    }

    @isTest(seeAllData=true)
    public static void SendingToCore(){

        Map<String, ShisetsuCoreSyncTask__c> theTasks = new Map<String,ShisetsuCoreSyncTask__c>{
            '1' => new ShisetsuCoreSyncTask__c( EndPoint__c = '<test endpoint>', MessageBody__c = '<test message>' )
        };
        Insert theTasks.values();

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200) );

        Test.startTest();
        new ShisetsuCoreSyncTasks.SendingToCore( theTasks.get('1').Id ).run();
        Test.stopTest();
        
    }
}