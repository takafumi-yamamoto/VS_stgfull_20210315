public class ContactHistoryCtl {

    public class editCallValue {
        @AuraEnabled public Boolean isSonotaService = false;
        @AuraEnabled public List<ContactHistory> tList = new List<ContactHistory>();
        @AuraEnabled public List<String> shiborikomiJokenSltList = new List<String>();
        @AuraEnabled public Map<String, List<String>> shiborikomiYokenSyubetsuListMap = new Map<String, List<String>>();
    }

    public class ContactHistory{
            ContactHistory(
                        String objectType,
                        DateTime activitydate, 
                        Task ta,
                        VOC__c vo){
            this.objectType = objectType;
            this.activitydate = activitydate;
            this.ta = ta;
            this.vo = vo;
        }

        @AuraEnabled String objectType{get;set;}
        @AuraEnabled DateTime activitydate{get;set;}
        @AuraEnabled Task ta{get;set;}
        @AuraEnabled Voc__c vo{get;set;}
    }

    public class HasshinmotoFromObj {
        @AuraEnabled public Map<String, String> selItem = new Map<String, String>();
        @AuraEnabled public String sonota = '';
    }

    public class HasshinsakiToObj {
        @AuraEnabled public Map<String, String> selItem = new Map<String, String>();
        @AuraEnabled public String sonota = '';
    }

    @AuraEnabled
    public static String auraGetUserId() {
        return UserInfo.getUserId();
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

        for(Task t : TaskDao.sltTaskCallById(recordId)){
        	ContactHistory c = new ContactHistory(
                                                    'Task',
        											t.CreatedDate, 
                                                    t,
                                                    null);
        	System.debug('c:' + c);
        	val.tList.add(c);
        }

        for(VOC__c v : [select Id, Name, Naiyo__c, VOCType__c, Keiro__c, HasshinmotoFrom__c, TaishoPartnerMeiFromRef__r.Id, TaishoPartnerMeiFromRef__r.Name, TaishoPartnerMeiFromSonota__c, HasshinsakiTo__c, CreatedBy.Id, CreatedBy.Name, CreatedDate, LastModifiedBy.Name, LastModifiedDate, OwnerId, TaishoRepMeiRef__r.Id, TaishoRepMeiRef__r.Name, TaishoPartnerMeiRef__r.Id, TaishoPartnerMeiRef__r.Name, Sonota__c from VOC__c where TaishoOpportunityRef__c = :recordId]){
            ContactHistory c = new ContactHistory(
                                                    'VOC',
                                                    v.CreatedDate, 
                                                    null,
                                                    v);
            System.debug('c:' + c);
            val.tList.add(c);
        }
        val.tList = sortContactHistory(val.tList);

        return val;
    }

    @AuraEnabled
    public static Task auraUpdateTask(Task pUpdateTask) {
    	System.debug('pUpdateTask:' + pUpdateTask);
        String ownerId = pUpdateTask.OwnerId;
        if(ownerId == null || ownerId == ''){
            ownerId = Dao_User.getInstance().selectByProfileName('SysAdmin').Id;
        }

        pUpdateTask.OwnerId = ownerId;

        update pUpdateTask;
        return pUpdateTask;
    }

    @AuraEnabled
    public static VOC__c auraUpdateVOC(VOC__c pUpdateVOC) {
        System.debug('pUpdateVOC:' + pUpdateVOC);

        update pUpdateVOC;
        return pUpdateVOC;
    }

    @AuraEnabled
    public static Task auraDelTask(Task pDeleteTask) {
        // 所有者が異なると削除ができないためログインユーザ(=作成者)で更新する
        pDeleteTask.OwnerId = UserInfo.getUserId();
        update pDeleteTask;

        delete pDeleteTask;
        return pDeleteTask;
    }

    @AuraEnabled
    public static VOC__c auraDelVOC(VOC__c pDeleteVOC) {
        System.debug('pDeleteVOC:' + pDeleteVOC);
        // 所有者が異なると削除ができないためログインユーザ(=作成者)で更新する
        pDeleteVOC.OwnerId = UserInfo.getUserId();
        update pDeleteVOC;

        delete pDeleteVOC;
        return pDeleteVOC;
    }

    @AuraEnabled
    public static HasshinmotoFromObj auraGetHasshinmotoFromValue(String recordId, String hasshinsakiTomotoFrom){
        HasshinmotoFromObj h = new HasshinmotoFromObj();

        if(hasshinsakiTomotoFrom == 'パートナー(葬儀社)' || hasshinsakiTomotoFrom == 'パートナー(僧侶)'){
            Opportunity o = [select Id, RecordType.DeveloperName, 
                                    SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Id, SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name, 
                                    ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__c, ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.Id, ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.Name, 
                                    EitaiKuyoRef__r.KetteiJiin__c, EitaiKuyoRef__r.KetteiJiin__r.Teikeisaki__r.Id, EitaiKuyoRef__r.KetteiJiin__r.Teikeisaki__r.Name, 
                                    KaiyoSankotsuUmieRef__r.IkotsuSoufusakiRef__c, KaiyoSankotsuUmieRef__r.IkotsuSoufusakiRef__r.Teikeisaki__r.Id, KaiyoSankotsuUmieRef__r.IkotsuSoufusakiRef__r.Teikeisaki__r.Name 
                                from Opportunity where Id = :recordId];
            Map<String, String> selItemMap = new Map<String, String>();
            if(hasshinsakiTomotoFrom == 'パートナー(葬儀社)' && o.RecordType.DeveloperName == 'SimpleYasugo' && o.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c != null){
                selItemMap.put('val', o.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Id);
                selItemMap.put('text', o.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name);
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
    public static HasshinmotoFromObj auraSetSelItemFromMap(String objId, String objName, String objType){
        HasshinmotoFromObj h = new HasshinmotoFromObj();

        Map<String, String> selItemMap = new Map<String, String>();
        selItemMap.put('val', objId);
        selItemMap.put('text', objName);
        selItemMap.put('objName', objType);
        h.selItem = selItemMap;

        return h;
    }

    @AuraEnabled
    public static HasshinsakiToObj auraSetSelItemMap(String objId, String objName, String objType){
        HasshinsakiToObj h = new HasshinsakiToObj();

        Map<String, String> selItemMap = new Map<String, String>();
        selItemMap.put('val', objId);
        selItemMap.put('text', objName);
        selItemMap.put('objName', objType);
        h.selItem = selItemMap;

        return h;
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

    public static List<ContactHistory> sortContactHistory(List<ContactHistory> chList){
        for(Integer i = 0; i < chList.size() - 1; i++){
            for(Integer j = chList.size() - 1; j > i; j--){
                ContactHistory chTemp1 = chList.get(j - 1);
                ContactHistory chTemp2 = chList.get(j);
                if(chTemp1.activitydate < chTemp2.activitydate){
                    ContactHistory chTemp3 = chTemp1;
                    chList.set(j - 1, chTemp2);
                    chList.set(j, chTemp3);
                }
            }
        }

        return chList;
    }

}