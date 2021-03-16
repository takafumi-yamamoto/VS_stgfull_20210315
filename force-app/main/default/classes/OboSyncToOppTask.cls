public class OboSyncToOppTask implements Queueable{

    private Id f_TaskId = null;
    public OboSyncToOppTask(Id pTaskId){ this.f_TaskId = pTaskId; }

    public void execute(QueueableContext context) {
        this.runTask( this.f_TaskId );
    }

    public void runTask(Id pTaskId){

        List<OboSyncToOppTask__c> theTasks = [
            SELECT 
            Id, ObosanbinRef__c
            FROM OboSyncToOppTask__c 
            WHERE Id = :pTaskId
            Limit 1
        ];

        if(theTasks.size() <= 0) return;
        OboSyncToOppTask__c theTask = theTasks.get(0);
        if(theTask.ObosanbinRef__c == null) return;

        List<Obosanbin__c> theObosanbins = [
            SELECT 
            Id, 
            Taishosha1Ref__c, MoshuRef__c,
            MemorialServicePlan__c,
            ObosanbinKeiyakuMadoguchi__c, ObosanbinKeiyakuSekotanto__c,
            (
                SELECT Id,
                TaishosyaRef__c, MosyuRef__c, KetteiPlanName__c, KetteiSakiRef__c, SekouTantoRef__c
                FROM OpportunitiesObosanbin__r
            )
            FROM Obosanbin__c 
            WHERE Id = :theTask.ObosanbinRef__c
            LIMIT 1
        ];

        if(theObosanbins.size() <= 0) { theTask.ShoriStatus__c = 'Completed'; Update theTask; return; }
        Obosanbin__c theObosanbin = theObosanbins.get(0);
        if(theObosanbin.OpportunitiesObosanbin__r.size() <= 0) { theTask.ShoriStatus__c = 'Completed'; Update theTask; return; }
        Opportunity theOpp = theObosanbin.OpportunitiesObosanbin__r.get(0);

        Boolean theOppToBeUpdated = false;

        if(theOpp.TaishosyaRef__c != theObosanbin.Taishosha1Ref__c) { theOpp.TaishosyaRef__c = theObosanbin.Taishosha1Ref__c; theOppToBeUpdated = true; }
        if(theOpp.MosyuRef__c != theObosanbin.MoshuRef__c) { theOpp.MosyuRef__c = theObosanbin.MoshuRef__c; theOppToBeUpdated = true; }
        if(theOpp.KetteiPlanName__c != theObosanbin.MemorialServicePlan__c) { theOpp.KetteiPlanName__c = theObosanbin.MemorialServicePlan__c; theOppToBeUpdated = true; }
        if(theOpp.KetteiSakiRef__c != theObosanbin.ObosanbinKeiyakuMadoguchi__c) { theOpp.KetteiSakiRef__c = theObosanbin.ObosanbinKeiyakuMadoguchi__c; theOppToBeUpdated = true; }
        if(theOpp.SekouTantoRef__c != theObosanbin.ObosanbinKeiyakuSekotanto__c) { theOpp.SekouTantoRef__c = theObosanbin.ObosanbinKeiyakuSekotanto__c; theOppToBeUpdated = true; }

        if(theOppToBeUpdated){
            Update theOpp;
        }
        theTask.ShoriStatus__c = 'Completed'; Update theTask; return;
    }
}