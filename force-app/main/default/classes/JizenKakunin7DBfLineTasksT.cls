@isTest
private class JizenKakunin7DBfLineTasksT {

    @testSetup
    static void setup() {
        JizenKakuninTaskTestData.init();
    }

    @isTest
    static void myUnitTest() {

        Test.StartTest();
        List<Opportunity> opps = [Select Id, ObosanbinRef__c,  ObosanbinRef__r.MemorialServicePlan__c From Opportunity
                                     Where Name like '法要_%'];
        //insert OpportunityLineItem
        Product2 prod =  [SELECT id FROM Product2 Where IsActive = true LIMIT 1];
        PriceBookEntry pbe = [SELECT Id, UnitPrice FROM PricebookEntry LIMIT 1];
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opps[0].Id
            , PricebookEntryId = pbe.Id
            , Quantity = 5
            , TotalPrice = pbe.UnitPrice * 5
        );
        insert oli;
        // insert new List<Sobject>{oli, oli2, oli3};

        opps[0].StageName = '施行待ち';
        opps[0].KakuteibiSyodan__c = Datetime.now().addDays(-1);
        opps[0].SubPhase__c = '事前確認連絡7日前（システム）';
        update opps[0];

        Keiyaku__c keiyaku = [Select Id, KeiyakuBango__c, Teikeisaki__c from Keiyaku__c Limit 1];
        update new Account(Id=keiyaku.Teikeisaki__c, IsOboStLineAcnt__c=true);

        update new Obosanbin__c(Id=opps[0].ObosanbinRef__c,
            KokubetsuDateTime_Inp__c = Datetime.now().addDays(1),
            ObosanbinKeiyakuMadoguchi__c = keiyaku.Id
            );

        JizenKakunin7DBfLineTask__c task = new JizenKakunin7DBfLineTask__c(
                        AccountRef__c = keiyaku.Teikeisaki__c,
                        Msg__c = 'Test Only',
                        OppRef__c = opps[0].id,
                        ShoriStatus__c = 'Created'
            );
        insert task;

        JizenKakunin7DBfLineTasks.run();

        task.ShoriStatus__c = 'Created';
        task.Msg__c = 'Test Only2';
        update task;
        Test.StopTest();

    }
}