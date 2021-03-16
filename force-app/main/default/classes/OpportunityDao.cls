public class OpportunityDao{
    //廃止予定クラス
    private String getQueryBody(){
        return 'SELECT Id, ShodanBango__c, ShodanBangoF__c, Name, RecordTypeId, AccountId, Account.LastName, Account.FirstName, StageName, TorihikiShodanRef__c, CloseDate, TorihikiShodanFlag__c, ObosanbinRef__c, (Select Id, StageName from OpportunitysTorihikiShodan__r) FROM Opportunity WHERE Id != null ';
    }

    public Map<Id,Opportunity> ListToMapById(List<Opportunity> entries){
        Map<Id,Opportunity> mapById = new Map<Id,Opportunity>();
        for(Opportunity aItem : entries)
        {
            mapById.put(aItem.Id, aItem);
        }
        return mapById;
    }

    public List<Opportunity> SelectByAccountId(Id accountId){
        return Database.query(getQueryBody() + 'AND AccountId = :accountId');
    }

    public Opportunity SelectById(Id opportunityId){
        List<Opportunity> entities = Database.query(getQueryBody() + 'AND Id = :opportunityId');
        if(entities.size() > 0){
            return entities.get(0);
        }
        return null;
    }

    public List<Opportunity> SelectBytorihikiShodanId(Id torihikiShodanId){
        return Database.query(getQueryBody() + 'AND TorihikiShodanRef__c = :torihikiShodanId');
    }

    public List<Opportunity> SelectBytorihikiShodanIds(Set<ID> torihikiShodanIds){
        return Database.query(getQueryBody() + 'AND Id = :torihikiShodanIds');
    }

    public Opportunity SelectByCaseId(Id caseId){
        return Database.query(getQueryBody() + 'AND CaseRef__c = :caseId');
    }

    public Map<ID, Opportunity> SelectByObosanbinId(List<Obosanbin__c> obosanbinList){
        Map<ID, Opportunity> obosanbinIdMap = new Map<ID, Opportunity>();
        for(Opportunity opportunity : Database.query(getQueryBody() + 'AND ObosanbinRef__c = :obosanbinList')){
            obosanbinIdMap.put(opportunity.ObosanbinRef__c, opportunity);
        }
        return obosanbinIdMap;
    }

    public static Opportunity sltById(Id id){
        Opportunity rOpp = new Opportunity();
        List<Opportunity> sltOppList = [select 
                                            Id, 
                                            AccountId, 
                                            Account.PersonContactId, 
                                            RecordTypeId, 
                                            RecordType.DeveloperName, 
                                            StageName, 
                                            SubPhase__c, 
                                            Name, 
                                            ShodanBangoF__c 
                                        from Opportunity 
                                        where Id = :id];
        if(sltOppList.size() > 0){
            rOpp = sltOppList.get(0);
        }
        return rOpp;
    }

    public static List<Opportunity> sltByAccountIdShoriStatusNotNull(List<Id> idList){
        return [select 
                    Id, 
                    Name,
                    AccountId,
                    ShodanBangoF__c
                from Opportunity 
                where AccountId = :idList
                and ShoriStatus__c != null];
    }
}