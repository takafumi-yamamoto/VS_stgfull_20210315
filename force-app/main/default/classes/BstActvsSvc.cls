public without sharing  class BstActvsSvc {

    public class get_activities_req{
        @AuraEnabled public String opp_id {get;set;}
    }
    public class get_activities_res{
        @AuraEnabled public List<ActivityItem> activity_items = new List<ActivityItem>();
    }
    public class ActivityItem{
        @AuraEnabled public String entity_id;
        @AuraEnabled public String date_time;
        @AuraEnabled public String subject;
        @AuraEnabled public String descr;  
        @AuraEnabled public String opp_id;
        @AuraEnabled public String shodan_bango;
    }

    //@AuraEnabled(cacheable=true)
    @AuraEnabled
    public static get_activities_res get_activities(get_activities_req p_req){

        get_activities_res a_res = new get_activities_res();

        String the_opp_id = p_req.opp_id;

        Opportunity the_opp = [ SELECT Id, AccountId, Account.RecordType.DeveloperName FROM Opportunity WHERE Id = :the_opp_id LIMIT 1 ].get(0);
        if( the_opp.AccountId == null ) return a_res;
        if( the_opp.Account.RecordType.DeveloperName == 'null' ) return a_res;

        Set<String> the_opp_ids = new Set<String>();
        for(Opportunity a_opp : [
            SELECT Id
            FROM Opportunity 
            WHERE AccountId = :the_opp.AccountId
            AND RecordType.DeveloperName = 'KakuyasuButsudan'
            ORDER BY Req_Day__c DESC
            LIMIT 100
        ]){
            the_opp_ids.add(a_opp.Id);
        }

        List<Task> the_tasks = [
            SELECT Id, CreatedDate, Subject, Description,
            TYPEOF What
                WHEN Opportunity THEN Id, ShodanBango__c, StageName
            END
            FROM Task 
            WHERE WhatId IN :the_opp_ids
            AND What.Type = 'Opportunity'
            ORDER BY CreatedDate DESC
            LIMIT 20
        ];

        for(Task aTask : the_tasks){
            ActivityItem a_activity_item = new ActivityItem();
            Opportunity a_opp = aTask.What;
            a_activity_item.opp_id = a_opp.Id;
            a_activity_item.shodan_bango = a_opp.ShodanBango__c;
            a_activity_item.entity_id = aTask.Id;
            a_activity_item.subject = aTask.Subject;
            a_activity_item.date_time = aTask.CreatedDate.format('yyyy/MM/dd HH:mm:ss');
            a_activity_item.descr = aTask.Description;
            a_res.activity_items.add(a_activity_item);
        }

        return a_res;
    }

}