@isTest
public class ShisetsuAutoNumberingsTest {
    @isTest(SeeAllData=true)
    public static void assingAutoNumberOnShisetsuBeforeInsert(){

        Map<String,Shisetsu__c> theShisetsus = new Map<String,Shisetsu__c>{
            '1' => new Shisetsu__c(Name = '1'),
            '2' => new Shisetsu__c(Name = '2')
        };

        test.startTest();
        Insert theShisetsus.values();
        test.stopTest();

        List<Shisetsu__c> theActuals = new List<Shisetsu__c>(
            [
                select id, name, SeqNo__c, KasobaKeisaiJohoId__c, SaijoKeisaiJohoId__c
                from Shisetsu__c
                where Id = : SobjectsExtension.collectIds( theShisetsus.values() )
            ]
        );

        for(Shisetsu__c aActual : theActuals){
            System.Debug(aActual);
        }
    }
}