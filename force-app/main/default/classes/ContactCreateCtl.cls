public class ContactCreateCtl {

    public class defaultCallValue {
        @AuraEnabled public Task t = new Task();
        @AuraEnabled public Opportunity opp = new Opportunity();
        @AuraEnabled public List<String> shiborikomiJokenSltList = new List<String>();
        @AuraEnabled public Map<String, List<String>> shiborikomiYokenSyubetsuListMap = new Map<String, List<String>>();
    }

    public class defaultVOCValue {
        @AuraEnabled public VOC__c voc = new VOC__c();
    }

    public class HasshinsakiFromObj {
        @AuraEnabled public Map<String, String> selItem = new Map<String, String>();
        @AuraEnabled public String sonota = '';
    }

    public class HasshinsakiToObj {
        @AuraEnabled public Map<String, String> selItem = new Map<String, String>();
        @AuraEnabled public String sonota = '';
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
    public static defaultVOCValue auraGetDefaultVOCValue(String recordId, String vocType) {
        defaultVOCValue vocVal = new defaultVOCValue();
        VOC__c vTemp = new VOC__c();
        vTemp.TaishoOpportunityRef__c = recordId;
        vTemp.VOCType__c = vocType;
        vTemp.OwnerId = UserInfo.getUserId();
        vocVal.voc = vTemp;
        return vocVal;
    }
    
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

    @AuraEnabled
    public static HasshinsakiFromObj auraGetHasshinsakiFromValue(String recordId, String hasshinsakiFrom){
        HasshinsakiFromObj h = new HasshinsakiFromObj();

        if(hasshinsakiFrom == 'パートナー(葬儀社)' || hasshinsakiFrom == 'パートナー(僧侶)' || hasshinsakiFrom == 'パートナー(永代供養墓寺院)' || hasshinsakiFrom == 'パートナー(散骨業者)'){
            Opportunity o = [select Id, RecordType.DeveloperName, 
                                    SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Id, SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name, 
                                    ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__c, ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.Id, ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.Name, 
                                    EitaiKuyoRef__r.KetteiJiin__c, EitaiKuyoRef__r.KetteiJiin__r.Teikeisaki__r.Id, EitaiKuyoRef__r.KetteiJiin__r.Teikeisaki__r.Name, 
                                    KaiyoSankotsuUmieRef__r.IkotsuSoufusakiRef__c, KaiyoSankotsuUmieRef__r.IkotsuSoufusakiRef__r.Teikeisaki__r.Id, KaiyoSankotsuUmieRef__r.IkotsuSoufusakiRef__r.Teikeisaki__r.Name 
                                from Opportunity where Id = :recordId];
            Map<String, String> selItemMap = new Map<String, String>();
            if(hasshinsakiFrom == 'パートナー(葬儀社)' && o.RecordType.DeveloperName == 'SimpleYasugo' && o.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c != null){
                selItemMap.put('val', o.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Id);
                selItemMap.put('text', o.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name);
                selItemMap.put('objName', 'Account');
            }
            else if(hasshinsakiFrom == 'パートナー(永代供養墓寺院)' && o.RecordType.DeveloperName == 'PerpetualMemorial' && o.EitaiKuyoRef__r.KetteiJiin__c != null){
                selItemMap.put('val', o.EitaiKuyoRef__r.KetteiJiin__r.Teikeisaki__r.Id);
                selItemMap.put('text', o.EitaiKuyoRef__r.KetteiJiin__r.Teikeisaki__r.Name);
                selItemMap.put('objName', 'Account');
            }
            else if(hasshinsakiFrom == 'パートナー(散骨業者)' && o.RecordType.DeveloperName == 'KaiyoUmie' && o.KaiyoSankotsuUmieRef__r.IkotsuSoufusakiRef__c != null){
                selItemMap.put('val', o.KaiyoSankotsuUmieRef__r.IkotsuSoufusakiRef__r.Teikeisaki__r.Id);
                selItemMap.put('text', o.KaiyoSankotsuUmieRef__r.IkotsuSoufusakiRef__r.Teikeisaki__r.Name);
                selItemMap.put('objName', 'Account');
            }
            h.selItem = selItemMap;
        }
        System.debug('h:' + h);
        return h;
    }

    @AuraEnabled
    public static HasshinsakiToObj auraGetHasshinsakiToValue(String recordId, String hasshinsakiTo){
        HasshinsakiToObj h = new HasshinsakiToObj();

        if(hasshinsakiTo == 'パートナー(葬儀社)' || hasshinsakiTo == 'パートナー(僧侶)' || hasshinsakiTo == 'パートナー(永代供養墓寺院)' || hasshinsakiTo == 'パートナー(散骨業者)'){
            Opportunity o = [select Id, RecordType.DeveloperName, 
                                    SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Id, SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name, 
                                    ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__c, ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.Id, ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.Name, 
                                    EitaiKuyoRef__r.KetteiJiin__c, EitaiKuyoRef__r.KetteiJiin__r.Teikeisaki__r.Id, EitaiKuyoRef__r.KetteiJiin__r.Teikeisaki__r.Name, 
                                    KaiyoSankotsuUmieRef__r.IkotsuSoufusakiRef__c, KaiyoSankotsuUmieRef__r.IkotsuSoufusakiRef__r.Teikeisaki__r.Id, KaiyoSankotsuUmieRef__r.IkotsuSoufusakiRef__r.Teikeisaki__r.Name 
                                from Opportunity where Id = :recordId];
            Map<String, String> selItemMap = new Map<String, String>();
            if(hasshinsakiTo == 'パートナー(葬儀社)' && o.RecordType.DeveloperName == 'SimpleYasugo' && o.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c != null){
                selItemMap.put('val', o.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Id);
                selItemMap.put('text', o.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name);
                selItemMap.put('objName', 'Account');
            }
            else if(hasshinsakiTo == 'パートナー(永代供養墓寺院)' && o.RecordType.DeveloperName == 'PerpetualMemorial' && o.EitaiKuyoRef__r.KetteiJiin__c != null){
                selItemMap.put('val', o.EitaiKuyoRef__r.KetteiJiin__r.Teikeisaki__r.Id);
                selItemMap.put('text', o.EitaiKuyoRef__r.KetteiJiin__r.Teikeisaki__r.Name);
                selItemMap.put('objName', 'Account');
            }
            else if(hasshinsakiTo == 'パートナー(散骨業者)' && o.RecordType.DeveloperName == 'KaiyoUmie' && o.KaiyoSankotsuUmieRef__r.IkotsuSoufusakiRef__c != null){
                selItemMap.put('val', o.KaiyoSankotsuUmieRef__r.IkotsuSoufusakiRef__r.Teikeisaki__r.Id);
                selItemMap.put('text', o.KaiyoSankotsuUmieRef__r.IkotsuSoufusakiRef__r.Teikeisaki__r.Name);
                selItemMap.put('objName', 'Account');
            }
            h.selItem = selItemMap;
        }
        System.debug('h:' + h);
        return h;
    }

    @AuraEnabled
    public static Task auraCallSave(Task pSaveTask) {
        insert pSaveTask;
        return pSaveTask;
    }

    @AuraEnabled
    public static defaultVOCValue auraVocSave(VOC__c pSaveVoc){
        System.debug('pSaveVoc:' + pSaveVoc);
        insert pSaveVoc;

        defaultVOCValue vocVal = new defaultVOCValue();
        vocVal.voc = pSaveVoc;
        return vocVal;
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
}