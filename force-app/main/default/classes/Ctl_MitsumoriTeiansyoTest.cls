@isTest
public class Ctl_MitsumoriTeiansyoTest {

    @isTest(SeeAllData=true)
    public static void TemplateService(){

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

        Map<String, MitsumoriTeianshoTemplate__c> theTemplates = new Map<String, MitsumoriTeianshoTemplate__c>{
            '1' => new MitsumoriTeianshoTemplate__c( HosokuSetsumei__c = 'HosokuSetsumei__c' )
        };
        Insert theTemplates.values();

        Map<String, TeianshoTemplate__c> theLines = new Map<String, TeianshoTemplate__c>{
            '1' =>
            new TeianshoTemplate__c(
                MitsumoriTeianshoTemplateRef__c = theTemplates.get('1').Id,
                SubTitle__c = 'SubTitle__c',
                Plan__c = '直葬',
                TokkiJiko__c = 'TokkiJiko__c',
                TsuikaRyokin1_Hinmei__c = 'TsuikaRyokin1_Hinmei__c', TsuikaRyokin1_Kingaku__c = 1,
                TsuikaRyokin2_Hinmei__c = 'TsuikaRyokin2_Hinmei__c', TsuikaRyokin2_Kingaku__c = 2
            )
        };
        Insert theLines.values();

        Map<String, MitsumoriTeiansyo__c> theMitsumoris = new Map<String,MitsumoriTeiansyo__c>{
            '1' => new MitsumoriTeiansyo__c(  ShodanRef__c = theOpps.get('1').Id,   Cmd_TemplateRef__c = theTemplates.get('1').Id )
        };

        test.startTest();
        Insert theMitsumoris.values();
        test.stopTest();

        // MitsumoriTeiansyo__c theActual = 
        //     new List<MitsumoriTeiansyo__c>(
        //         [
        //             select Id,HosokuSetsumei__c,
        //             (
        //                 select Id, 
        //                 Plan__c, SubTitle__c, TokkiJiko__c, 
        //                 TsuikaRyokin1_Hinmei__c, TsuikaRyokin1_Kingaku__c,
        //                 TsuikaRyokin2_Hinmei__c, TsuikaRyokin2_Kingaku__c
        //                 from Teianshos__r
        //             )
        //             from MitsumoriTeiansyo__c 
        //             where Id = :theMitsumoris.get('1').Id
        //         ]
        //     ).get(0);

        // System.Debug(theActual);
        // System.Debug(theActual.Teianshos__r.get(0));
    }
}