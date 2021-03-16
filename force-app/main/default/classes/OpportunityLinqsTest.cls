@isTest
public class OpportunityLinqsTest {

    @isTest
    public static void ListToMapBySimpleYasugoRef(){

        List<SimpleYasugo__c> theRevis = new List<SimpleYasugo__c>{
            new SimpleYasugo__c(),
            new SimpleYasugo__c()
        };
        insert theRevis;

        List<Opportunity> theOpps = new List<Opportunity>{
            new Opportunity( Name = '01', SimpleYasugoRef__c = theRevis.get(0).Id ),
            new Opportunity( Name = '02', SimpleYasugoRef__c = theRevis.get(1).Id  )
        };

        Map<Id, Opportunity> theActual = OpportunityLinqs.ListToMapBySimpleYasugoRef(theOpps);

        System.Debug(theActual);
    }
    @isTest
    public static void ListToMapByObouRef(){

        List<Obosanbin__c> theRevis = new List<Obosanbin__c>{
            new Obosanbin__c(),
            new Obosanbin__c()
        };
        insert theRevis;

        List<Opportunity> theOpps = new List<Opportunity>{
            new Opportunity( Name = '01', ObosanbinRef__c = theRevis.get(0).Id ),
            new Opportunity( Name = '02', ObosanbinRef__c = theRevis.get(1).Id  )
        };

        Map<Id, Opportunity> theActual = OpportunityLinqs.ListToMapByObouRef(theOpps);

        System.Debug(theActual);
    }
    @isTest
    public static void ListToMapByEitaiKuyoRef(){

        List<EitaiKuyo__c> theEitaiKuyos = new List<EitaiKuyo__c>{
            new EitaiKuyo__c(),
            new EitaiKuyo__c()
        };
        insert theEitaiKuyos;

        List<Opportunity> theOpps = new List<Opportunity>{
            new Opportunity( Name = '01', EitaiKuyoRef__c = theEitaiKuyos.get(0).Id ),
            new Opportunity( Name = '02', EitaiKuyoRef__c = theEitaiKuyos.get(1).Id  )
        };

        Map<Id, Opportunity> theActual = OpportunityLinqs.ListToMapByEitaiKuyoRef(theOpps);

        System.Debug(theActual);
    }

    @isTest
    public static void ListToMapByUmieRef(){

        List<KaiyoSankotsuUmie__c> theUmies = new List<KaiyoSankotsuUmie__c>{
            new KaiyoSankotsuUmie__c(),
            new KaiyoSankotsuUmie__c()
        };
        insert theUmies;

        List<Opportunity> theOpps = new List<Opportunity>{
            new Opportunity( Name = '01', KaiyoSankotsuUmieRef__c = theUmies.get(0).Id ),
            new Opportunity( Name = '02', KaiyoSankotsuUmieRef__c = theUmies.get(1).Id  )
        };

        Map<Id, Opportunity> theActual = OpportunityLinqs.ListToMapByUmieRef(theOpps);

        System.Debug(theActual);
    }

    @isTest
    public static void ListToMapByBestButsudanRef(){

        List<BestButsudan__c> theBestButsudans = new List<BestButsudan__c>{
            new BestButsudan__c(),
            new BestButsudan__c()
        };
        insert theBestButsudans;

        List<Opportunity> theOpps = new List<Opportunity>{
            new Opportunity( Name = '01', BestButsudanRef__c = theBestButsudans.get(0).Id ),
            new Opportunity( Name = '02', BestButsudanRef__c = theBestButsudans.get(1).Id  )
        };

        Map<Id, Opportunity> theActual = OpportunityLinqs.ListToMapByBestButsudanRef(theOpps);

        System.Debug(theActual);
    }

    @isTest
    public static void ListToMapByReviRef(){

        List<SougiRev__c> theRevis = new List<SougiRev__c>{
            new SougiRev__c(),
            new SougiRev__c()
        };
        insert theRevis;

        List<Opportunity> theOpps = new List<Opportunity>{
            new Opportunity( Name = '01', SogiReviRef__c = theRevis.get(0).Id ),
            new Opportunity( Name = '02', SogiReviRef__c = theRevis.get(1).Id  )
        };

        Map<Id, Opportunity> theActual = OpportunityLinqs.ListToMapByReviRef(theOpps);

        System.Debug(theActual);
    }
}