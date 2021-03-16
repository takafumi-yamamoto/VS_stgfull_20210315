public class TerapToiRecBat implements Database.Batchable<sObject>, Schedulable {
    /** スケジュール起動*/
    public void execute(SchedulableContext sc) {
        Integer theBatchSize = 200;
        Database.executeBatch(new TerapToiRecBat(date.today()), theBatchSize);
    }

    private Date toiawaseStartDate;
    private Date toiawaseEndDate;
    private Date toribunRateYmApplyingFor;

    public TerapToiRecBat() {
        this.init(date.today());
    }

    public TerapToiRecBat(Date exeDate) {
        this.init(exeDate);
    }

    private void init(Date exeDate) {
        
        Date tmpStartDate = exeDate.addMonths(-1);
        this.toiawaseStartDate = date.newInstance(tmpStartDate.year(), tmpStartDate.month(), 21);
        this.toiawaseEndDate = date.newInstance(exeDate.year(), exeDate.month(), 20);
        this.toribunRateYmApplyingFor = exeDate.addMonths(1).toStartOfMonth();
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId();
        return Database.getQueryLocator([
                Select 
                    id, 
                    Req_Day__c,
                    ShodanBango__c,
                    Account.Name,
                    ObosanbinRef__r.MemorialServicePlan__c,
                    ObosanbinRef__r.Sogisha__r.Id,
                    ObosanbinRef__r.Sogisha__r.TorihikisakiBango__c
                FROM Opportunity
                WHERE DAY_ONLY(Req_Day__c) >= : this.toiawaseStartDate
                AND DAY_ONLY(Req_Day__c) <= : this.toiawaseEndDate
                AND RecordTypeId = :recordTypeId
                AND RyunyumotoService__c = '定額僧侶手配代行'
                AND ObosanbinRef__r.Sogisha__c <> Null
                AND StageName != '除外'
            ]);
    }

    public void execute(Database.BatchableContext BC, List<Opportunity> oppList) {
        List<TerapToiRec__c> terapToiRecList = new List<TerapToiRec__c>();
        for(Opportunity opp: oppList) {
            terapToiRecList.add(new TerapToiRec__c(
                ToiawaseDate__c = date.newInstance(opp.Req_Day__c.year(), opp.Req_Day__c.month(), opp.Req_Day__c.day()),
                ShodanBango__c = opp.ShodanBango__c,
                SogishaTorihikisakiBango__c = opp.ObosanbinRef__r.Sogisha__r.TorihikisakiBango__c,
                SogishaRef__c = opp.ObosanbinRef__r.Sogisha__r.Id,
                SodanshaName__c = opp.Account.Name,
                HoyoShubetsu__c = opp.ObosanbinRef__r.MemorialServicePlan__c,
                ToribunRateYmApplyingFor__c = this.toribunRateYmApplyingFor,  
                OppRef__c = opp.Id
            ));
        }
        if(terapToiRecList.size() > 0) upsert terapToiRecList ShodanBango__c;
    }

    public void finish(Database.BatchableContext BC) {}
}