public class TaskDao {

    static public List<Task> sltTaskCallById(String id){
        return [select 
                    Id, 
                    Subject, 
                    Description, 
                    WhoId, 
                    WhatId, 
                    ActivityDate, 
                    OwnerId, 
                    RecordType.DeveloperName, 
                    KadenSogisha__c, 
                    KadenSogisha__r.Name, 
                    TaioFukaRiyu__c, 
                    TaioFukaRiyuSonota__c, 
                    Kijitsu__c, 
                    ServiceType__c, 
                    ShiborikomiJoken__c, 
                    YokenSyubetsu__c, 
                    SaisetteiKijitsu__c, 
                    CreatedDate, 
                    CreatedById, 
                    CreatedBy.Name, 
                    LastModifiedDate, 
                    LastModifiedBy.Name, 
                    Claim__c, 
                    IsArchived 
                from Task 
                where WhatId = :id and 
                    TaskSubtype = 'Call' 
                order by Kijitsu__c desc ALL ROWS];
    }

    static public List<Task> sltTaskCallByWhoIdorWhatId(String whoId, String whatId){
        return [select 
                    Id, 
                    Subject, 
                    Description, 
                    WhoId, 
                    WhatId, 
                    ActivityDate, 
                    OwnerId, 
                    RecordType.DeveloperName, 
                    KadenSogisha__c, 
                    KadenSogisha__r.Name, 
                    TaioFukaRiyu__c, 
                    TaioFukaRiyuSonota__c, 
                    Kijitsu__c, 
                    ServiceType__c, 
                    ShiborikomiJoken__c, 
                    YokenSyubetsu__c, 
                    SaisetteiKijitsu__c, 
                    CreatedDate, 
                    CreatedById, 
                    CreatedBy.Name, 
                    LastModifiedDate, 
                    LastModifiedBy.Name, 
                    Claim__c, 
                    WavUrlImg__c, 
                    IsArchived 
                from Task 
                where (WhoId = :whoId AND TaskSubtype = 'Task' AND RecordTypeId = :Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('BizTel').getRecordTypeId()) or 
                        (WhatId = :whatId and TaskSubtype = 'Call')
                order by Kijitsu__c desc ALL ROWS];
    }

    static public List<Task> sltTaskTaskById(Id id){
        return [select 
                    Id, 
                    Subject, 
                    Description, 
                    WhoId, 
                    WhatId, 
                    ActivityDate, 
                    OwnerId, 
                    RecordType.DeveloperName, 
                    Owner.Name, 
                    Status, 
                    Priority, 
                    Kijitsu__c, 
                    ServiceType__c, 
                    ShiborikomiJoken__c, 
                    YokenSyubetsu__c, 
                    SaisetteiKijitsu__c, 
                    CreatedDate, 
                    CreatedById, 
                    CreatedBy.Name, 
                    LastModifiedDate, 
                    LastModifiedBy.Name, 
                    IsArchived 
                from Task 
                where WhatId = :id and 
                    TaskSubtype = 'Task' 
                order by CreatedDate desc ALL ROWS];
    }
}