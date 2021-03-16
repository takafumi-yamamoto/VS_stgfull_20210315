public class TaskOperation {

    @AuraEnabled
    public static String auraGetHikitsugiTask(String recordId) {
        String msg = '';
        AggregateResult result = [select count(Id) cnt from Task where WhatId = :recordId and TaskSubtype = 'Task' and Status != '完了'];
        System.debug('cnt' + result.get('cnt'));
        if(Integer.valueOf(result.get('cnt')) > 0){
            msg = '未完了の引継ぎタスクがあります！';
        }
        return msg;
    }

    @AuraEnabled
    public static String auraGetUserId() {
        return UserInfo.getUserId();
    }

    public class defaultCallValue {
        @AuraEnabled public Task t = new Task();
        @AuraEnabled public Opportunity opp = new Opportunity();
        @AuraEnabled public List<String> shiborikomiJokenSltList = new List<String>();
        @AuraEnabled public Map<String, List<String>> shiborikomiYokenSyubetsuListMap = new Map<String, List<String>>();
    }

    public class defaultTaskValue {
        @AuraEnabled public Task t = new Task();
        @AuraEnabled public Opportunity opp = new Opportunity();
    }

    public class editCallValue {
        @AuraEnabled public Boolean isSonotaService = false;
        @AuraEnabled public List<Task> tList = new List<Task>();
        @AuraEnabled public List<String> shiborikomiJokenSltList = new List<String>();
        @AuraEnabled public Map<String, List<String>> shiborikomiYokenSyubetsuListMap = new Map<String, List<String>>();
    }

    public class editTaskValue {
        @AuraEnabled public Boolean isSonotaService = false;
        @AuraEnabled public List<Task> tList = new List<Task>();
    }

    @AuraEnabled
    public static defaultCallValue auraGetDefaultCallValue(String recordId) {

        Opportunity o = OpportunityDao.sltById(recordId);
        Map<String, List<String>> yokenShubetsuListMap = getYokenShubetsuListMap(o.RecordType.DeveloperName);

        defaultCallValue val = new defaultCallValue();
        val.t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Tsujo').getRecordTypeId();
        val.t.WhoId = o.Account.PersonContactId;
        val.t.WhatId = o.Id;
        val.t.Status = '完了';
        val.t.Subject = '';
        val.t.TaskSubtype = 'Call';
        val.opp = o;
        val.t.ServiceType__c = getServiceType(o.RecordType.DeveloperName);
        val.shiborikomiYokenSyubetsuListMap = yokenShubetsuListMap;
        val.shiborikomiJokenSltList = new List<String>(yokenShubetsuListMap.keySet());
        val.t.OwnerId = UserInfo.getUserId();
        return val;
    }

    @AuraEnabled
    public static defaultTaskValue auraGetDefaultTaskValue(String recordId) {

        Opportunity o = OpportunityDao.sltById(recordId);
        defaultTaskValue val = new defaultTaskValue();
        val.t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Tsujo').getRecordTypeId();
        val.t.WhoId = o.Account.PersonContactId;
        val.t.WhatId = o.Id;
        val.t.Status = '未対応';
        val.t.Subject = '参照';
        val.t.TaskSubtype = 'Task';
        val.t.OwnerId = null;
        val.t.Kijitsu__c = null;
        val.t.ActivityDate = null;
        return val;
    }

    @AuraEnabled
    public static editCallValue auraGetCallHistorys(String recordId) {

        Opportunity o = OpportunityDao.sltById(recordId);
        Map<String, List<String>> yokenShubetsuListMap = getYokenShubetsuListMap(o.RecordType.DeveloperName);

        editCallValue val = new editCallValue();
        if(o.RecordType.DeveloperName == 'Obosanbin' || o.RecordType.DeveloperName == 'KakuyasuButsudan' || o.RecordType.DeveloperName == 'PerpetualMemorial' || o.RecordType.DeveloperName == 'KaiyoUmie'){
            val.isSonotaService = true;
        }
        val.shiborikomiYokenSyubetsuListMap = yokenShubetsuListMap;
        val.shiborikomiJokenSltList = new List<String>(yokenShubetsuListMap.keySet());
        val.tList = TaskDao.sltTaskCallById(recordId);
        return val;
    }

    @AuraEnabled
    public static editTaskValue auraGetTaskHistorys(String recordId) {

        Opportunity o = OpportunityDao.sltById(recordId);
        Map<String, List<String>> yokenShubetsuMapList = getYokenShubetsuListMap(o.RecordType.DeveloperName);

        editTaskValue val = new editTaskValue();
        if(o.RecordType.DeveloperName == 'KakuyasuButsudan' || o.RecordType.DeveloperName == 'PerpetualMemorial' || o.RecordType.DeveloperName == 'KaiyoUmie'){
            val.isSonotaService = true;
        }
        val.tList = TaskDao.sltTaskTaskById(recordId);
        return val;
    }

    @AuraEnabled
    public static Map<String, String> auraGetTaskOwner(String userId) {
        User sltUser = [select Id, Name, LastName, FirstName from User where Id = :userId];
        return new Map<String, String>{'val' => sltUser.Id, 'text' => sltUser.Name, 'objName' => 'User'};
    }

    @AuraEnabled
    public static Task auraCallSave(Task pSaveTask) {
        insert pSaveTask;
        return pSaveTask;
    }

    @AuraEnabled
    public static Task auraTaskSave(Task pSaveTask) {
        if(pSaveTask.Kijitsu__c == null){
            pSaveTask.Kijitsu__c = null;
            pSaveTask.ActivityDate = null;
        }
        String ownerId = pSaveTask.OwnerId;
        if(ownerId == null || ownerId == ''){
            pSaveTask.OwnerId = Dao_User.getInstance().selectByProfileName('SysAdmin').Id;
        }
        insert pSaveTask;
        return pSaveTask;
    }

    @AuraEnabled
    public static Task auraUpdateTask(Task pUpdateTask) {
        String ownerId = pUpdateTask.OwnerId;
        if(ownerId == null || ownerId == ''){
            pUpdateTask.OwnerId = Dao_User.getInstance().selectByProfileName('SysAdmin').Id;
        }
        update pUpdateTask;
        return pUpdateTask;
    }

    @AuraEnabled
    public static Task auraDelTask(Task pDeleteTask) {
        // 所有者が異なると削除ができないためログインユーザ(=作成者)で更新する
        pDeleteTask.OwnerId = UserInfo.getUserId();
        update pDeleteTask;

        delete pDeleteTask;
        return pDeleteTask;
    }

    public static String getServiceType(String rtDeveloperName){
        String serviceType = '';
        switch on rtDeveloperName {
            when 'SimpleYasugo' {
                serviceType = 'シンプル安豪';
            }   
            when 'Obosanbin' {
                serviceType = 'お坊さん便';
            }
            when 'KakuyasuButsudan' {
                serviceType = 'ベスト仏壇';
            }
            when 'PerpetualMemorial' {
                serviceType = '永代供養';
            }
            when 'KaiyoUmie' {
                serviceType = '海洋散骨';
            }
            when else {

            }
        }
        
        return serviceType;
    }

    public static Map<String, List<String>> getYokenShubetsuListMap(String rtDevName){
        Map<String, List<String>> yokenShubetsuListMap = new Map<String, List<String>>();
        List<ContactShiborikomiJoken__mdt> contactShiborikomiJokenList = [select ServiceType__c, ShiborikomiJoken__c, ShiborikomiJokenHyojijun__c, (Select YokenShubetsu__c, YokenShubetsuHyojijun__c from YokenShubetsusShiborikomiJoken__r where Muko__c = false) from ContactShiborikomiJoken__mdt where Muko__c = false and ServiceType__c = :rtDevName order by ShiborikomiJokenHyojijun__c];
        for(ContactShiborikomiJoken__mdt contactShiborikomiJoken : contactShiborikomiJokenList){
            List<String> tempYokenShubetsuList = new List<String>();
            List<ContactYokenShubetsu__mdt> tempYokenShubetsuSortList = contactShiborikomiJoken.YokenShubetsusShiborikomiJoken__r;
            tempYokenShubetsuSortList.sort();
            for(ContactYokenShubetsu__mdt yokenShubetsu : tempYokenShubetsuSortList){
                tempYokenShubetsuList.add(yokenShubetsu.YokenShubetsu__c);
            }
            yokenShubetsuListMap.put(contactShiborikomiJoken.ShiborikomiJoken__c, tempYokenShubetsuList);
        }
        return yokenShubetsuListMap;
    }

    @AuraEnabled
    public static String auraSetPhase(String recordId) {
        Opportunity o = OpportunityDao.sltById(recordId);
        String subPhase = o.SubPhase__c;
        if(subPhase != null && subPhase != 'null'){
            if(subPhase.indexOf('-') > 0){
                subPhase = subPhase.substring(0, subPhase.indexOf('-'));
            }
            subPhase = '：' + subPhase;
        }
        else{
            subPhase = '';
        }
        return o.StageName + subPhase;
    }
}