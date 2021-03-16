public class TesuryoTekiyoCurrentChanger implements Database.Batchable<sObject>, Schedulable{

    /*Implements Schedulable Begin*/
    private final Integer BATCH_SIZE = 100;

    public void execute(SchedulableContext ctx) {
        Database.executeBatch( new TesuryoTekiyoCurrentChanger(), BATCH_SIZE);
    }
    /*Implements Schedulable End*/


    /*Implements Database.Batchable<sObject> Begin*/
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            [ SELECT id, KeiyakuRef__c from TesuryoTekiyo__c where TekiyoKaishiBi__c = :Date.Today() ]
        );
    }
    
    public void execute(Database.BatchableContext bc, List<TesuryoTekiyo__c> targetRecords) {
        this.processBatch(targetRecords);
    }

    public void processBatch(List<TesuryoTekiyo__c> pTesuryoTekiyos){

        Set<Id> theKeiyakuIds = new Set<Id>();
        for(TesuryoTekiyo__c aTesuryoTekiyo : pTesuryoTekiyos){
            theKeiyakuIds.add(aTesuryoTekiyo.KeiyakuRef__c);
        }
        this.changeCurrent( new List<Id>(theKeiyakuIds) );
    }

    public void finish(Database.BatchableContext bc) {}
    /*Implements Database.Batchable<sObject> End*/

    public void subscribeOnTesuryoTekiyoAfterUpdated(List<TesuryoTekiyo__c> pNewOnes, Map<Id, TesuryoTekiyo__c> pOldOnes){
        Set<Id> theKeiyakuIdsToBeProcessed = new Set<Id>();
        for(TesuryoTekiyo__c aNewOne : pNewOnes){
            TesuryoTekiyo__c aOldOne = pOldOnes.get(aNewOne.Id);
            if(aNewOne.ShoninStatus__c != aOldOne.ShoninStatus__c) theKeiyakuIdsToBeProcessed.add( aNewOne.KeiyakuRef__c );
        }
        this.changeCurrent( new List<Id>( theKeiyakuIdsToBeProcessed ) );
    }

    public void changeCurrent(List<id> pKeiyakuIds){

        Map<Id, Keiyaku__c> theMapOfKeiyakuIdToKeiyaku = new Map<Id, Keiyaku__c>(
            [
                select 
                Id, KyuTesuryoTaioFlag__c,
                (
                    select 
                    Id,
                    TekiyoKaishiBi__c,
                    ShoninStatus__c,
                    isKyuTesuryoTaioExp__c
                    from Keiyaku_TesuryoTekiyos__r
                    where ShoninStatus__c = '承認済' and TekiyoKaishiBi__c != null and TekiyoKaishiBi__c <= :Date.Today()
                    order by TekiyoKaishiBi__c desc
                    limit 1
                )
                from Keiyaku__c
                where Id = :pKeiyakuIds
            ]
        );

        Map<Id,TesuryoTekiyo__c> theMapOfKeiyakuIdToCurrentTesuryoTekiyo = new Map<Id,TesuryoTekiyo__c>();
        for(Keiyaku__c aKeiyaku : theMapOfKeiyakuIdToKeiyaku.values() ){
            for( TesuryoTekiyo__c aTesuryoTekiyo : aKeiyaku.Keiyaku_TesuryoTekiyos__r ){
                TesuryoTekiyo__c theCurrentTesuryoTekiyo = theMapOfKeiyakuIdToCurrentTesuryoTekiyo.get(aKeiyaku.Id);
                if(theCurrentTesuryoTekiyo == null || aTesuryoTekiyo.TekiyoKaishiBi__c >= theCurrentTesuryoTekiyo.TekiyoKaishiBi__c) {
                    theMapOfKeiyakuIdToCurrentTesuryoTekiyo.put( aKeiyaku.Id, aTesuryoTekiyo);
                }
            }
        }

        List<Keiyaku__c> theKeiyakusToBeUpdated = new List<Keiyaku__c>();
        for( Keiyaku__c aKeiyaku : theMapOfKeiyakuIdToKeiyaku.values() ){
            TesuryoTekiyo__c aTesuryoTekiyo = theMapOfKeiyakuIdToCurrentTesuryoTekiyo.get(aKeiyaku.Id);
            Boolean theIsKyuTesuryoTaio = aTesuryoTekiyo != null && aTesuryoTekiyo.isKyuTesuryoTaioExp__c;

            if( aKeiyaku.KyuTesuryoTaioFlag__c != theIsKyuTesuryoTaio ){
                aKeiyaku.KyuTesuryoTaioFlag__c = theIsKyuTesuryoTaio;
                theKeiyakusToBeUpdated.add(aKeiyaku);
            }
        }

        Update theKeiyakusToBeUpdated;
    }
}