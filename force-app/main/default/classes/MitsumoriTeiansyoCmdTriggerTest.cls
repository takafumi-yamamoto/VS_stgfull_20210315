@isTest
public class MitsumoriTeiansyoCmdTriggerTest {
    @isTest(SeeAllData=true)
    public static void doTest(){

        Map<String, Account> theAccounts = new Map<String, Account>{
            '1' => new Account(Name = '_')
        };
        Insert theAccounts.values();

        Map<String,SimpleYasugo__c> theSimples = new Map<String, SimpleYasugo__c>{
            '1' => new SimpleYasugo__c()
        };
        Insert theSimples.values();

        Map<String,Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                AccountId = theAccounts.get('1').Id,
                Name = '_',
                StageName = '_',
                CloseDate = Date.valueOf('1900-01-01'),
                TaishoushaJokyo__c = '_',
                SimpleYasugoRef__c = theSimples.get('1').Id
            )
        };
        Insert theOpps.values();

        Map<String, MitsumoriTeiansyo__c> theMitsumoris = new Map<String,MitsumoriTeiansyo__c>{
            '1' => new MitsumoriTeiansyo__c(  ShodanRef__c = theOpps.get('1').Id)
        };
        Insert theMitsumoris.values();

        Id theMitsumoriTeiansyoCmdId = 
            new List<MitsumoriTeiansyo__c>(
                [select MitsumoriTeiansyoCmdRef__c from MitsumoriTeiansyo__c where Id = :theMitsumoris.get('1').Id]
            )
            .get(0)
            .MitsumoriTeiansyoCmdRef__c;

        test.startTest();
        Update new MitsumoriTeiansyoCmd__c(
            Id = theMitsumoriTeiansyoCmdId,
            Plans__c = '直葬;火葬式　無宗教プラン',
            SubTitle__c = 'SubTitle__c',
            TokkiJiko__c = 'TokkiJiko__c',
            TsuikaRyokin1_Hinmei__c = 'TsuikaRyokin1_Hinmei__c', TsuikaRyokin1_Kingaku__c = 1,
            TsuikaRyokin2_Hinmei__c = 'TsuikaRyokin2_Hinmei__c', TsuikaRyokin2_Kingaku__c = 2,
            TsuikaRyokin3_Hinmei__c = 'TsuikaRyokin3_Hinmei__c', TsuikaRyokin3_Kingaku__c = 3,
            TsuikaRyokin4_Hinmei__c = 'TsuikaRyokin4_Hinmei__c', TsuikaRyokin4_Kingaku__c = 4,
            TsuikaRyokin5_Hinmei__c = 'TsuikaRyokin5_Hinmei__c', TsuikaRyokin5_Kingaku__c = 5,
            TsuikaRyokin6_Hinmei__c = 'TsuikaRyokin6_Hinmei__c', TsuikaRyokin6_Kingaku__c = 6
        );
        test.stopTest();

        // List<TeianSho__c> theActuals = new List<TeianSho__c>(
        //     [
        //         select Id, 
        //         Plan__c, SubTitle__c, TokkiJiko__c, 
        //         TsuikaRyokin1_Hinmei__c, TsuikaRyokin1_Kingaku__c,
        //         TsuikaRyokin2_Hinmei__c, TsuikaRyokin2_Kingaku__c,
        //         TsuikaRyokin3_Hinmei__c, TsuikaRyokin3_Kingaku__c,
        //         TsuikaRyokin4_Hinmei__c, TsuikaRyokin4_Kingaku__c,
        //         TsuikaRyokin5_Hinmei__c, TsuikaRyokin5_Kingaku__c,
        //         TsuikaRyokin6_Hinmei__c, TsuikaRyokin6_Kingaku__c
        //         from TeianSho__c 
        //         where MitsumoriTeianshoRef__c = :theMitsumoris.get('1').Id
        //     ]
        // );

        // for(TeianSho__c aActual : theActuals){
        //     System.Debug(aActual);
        // }
    }

}