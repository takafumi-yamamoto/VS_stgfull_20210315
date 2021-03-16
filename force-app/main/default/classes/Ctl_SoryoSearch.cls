/**
* クラス名      :   Ctrl_PriorityMunk
* クラス概要     :   僧侶検索画面
* @created  :   2017/11/30 Vinh Hua Quoc
* @modified :
*/
public class Ctl_SoryoSearch {
    public SearchWrapper searchWrapper {get; set;}
    public Account searchJoken {get;set;}
    public List<ResultWraper> resultWraperList {get; set;}
    public String messageInfo {get; set;}
    public Shikugun__c centerShikugun {get; set;}
    public static final Decimal DECIMAL_DEFAULT_LATITUDE = 35.689634;
    public static final Decimal DECIMAL_DEFAULT_LONGITUDE = 139.692101;
    public List<String> shushaGroup = new List<String>{'臨済宗永源寺派','臨済宗円覚寺派','臨済宗興聖寺派','臨済宗建仁寺派','臨済宗建長寺派','臨済宗向嶽寺派','臨済宗相国寺派','臨済宗大徳寺派','臨済宗天龍寺派','臨済宗東福寺派','臨済宗南禅寺派','臨済宗方広寺派','臨済宗妙心寺派','臨済宗佛通寺派','臨済宗國泰寺派'};

    public class SearchWrapper {
        public Boolean radioLookup {get; set;}
        public Boolean radioText {get; set;}
        public String address {get; set;}
        public Decimal latitudeAdress {get; set;}
        public Decimal longitudeAdress {get; set;}
        public Decimal centerLat {get; set;}
        public Decimal centerLon {get; set;}
        public Decimal defLat {get; set;}
        public Decimal defLon {get; set;}
        public SearchWrapper() {
            radioLookup=false;
            radioText = true;
            address = '';
            centerLat = DECIMAL_DEFAULT_LATITUDE;
            centerLon = DECIMAL_DEFAULT_LONGITUDE;
            defLat = DECIMAL_DEFAULT_LATITUDE;
            defLon = DECIMAL_DEFAULT_LONGITUDE;
        }
    }

    /*
    * Ctrl_PriorityMunk
    * コンストラクタ
    * @created: 2017/11/30 Vinh Hua Quoc
    * @modified:
    */
    public Ctl_SoryoSearch() {
        defaultSearchJoken();
    }

    /**
    * clearData
    * データをクリアする
    * @param なし
    * @return なし
    * @created: 2017/11/30 Vinh Hua Quoc
    * @modified:
    */
    public void clearData(){
        defaultSearchJoken();
    }

    /**
    * checkInputValid
    * チェック仕様
    * @param Boolean
    * @return なし
    * @created: 2017/11/30 Vinh Hua Quoc
    * @modified:
    */
    /*public Boolean checkInputValid(){
        //messageInfo = '';
        Boolean isInvalid = false;
        if(searchJoken.SangoJiinMeiFurigana__c.length() == 1){
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'所属山号寺院名(カナ)は2文字以上を入力してください。'));
            messageInfo = '所属山号寺院名(カナ)は2文字以上を入力してください。';
            isInvalid = true;
        }
        else if(searchJoken.LastNameFurigana__pc.length() == 1){
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'僧名(カナ)は2文字以上を入力してください。'));
            messageInfo = '僧名(カナ)は2文字以上を入力してください。';
            isInvalid = true;
        }
        else if(searchJoken.Phone.length() == 1){
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'僧侶連絡先は2文字以上を入力してください。'));
            messageInfo = '僧侶連絡先は2文字以上を入力してください。';
            isInvalid = true;
        }
        if(isInvalid){
            return false;
        }
        return true;
    }*/

    /**
    * searchData
    * 検索アクション
    * @param なし
    * @return なし
    * @created: 2017/11/30 Vinh Hua Quoc
    * @modified:
    */
    public void searchData(){

        resultWraperList = new List<ResultWraper>();
        messageInfo = '';

        centerShikugun.Name = '東京都都庁';
        centerShikugun.Chiriichijouhou__latitude__s = DECIMAL_DEFAULT_LATITUDE;
        centerShikugun.Chiriichijouhou__longitude__s = DECIMAL_DEFAULT_LONGITUDE;
        searchWrapper.centerLat = DECIMAL_DEFAULT_LATITUDE;
        searchWrapper.centerLon = DECIMAL_DEFAULT_LONGITUDE;
        searchWrapper.defLat = DECIMAL_DEFAULT_LATITUDE;
        searchWrapper.defLon = DECIMAL_DEFAULT_LONGITUDE;

        // チェック仕様
        /*if(!checkInputValid()){
            return;
        }*/

        String strQuery = 'SELECT Id,'
                        + 'Name,'
                        + 'Keiyakukaishibi__c,'
                        + 'TokkiJiko__c,'
                        + 'Sokyakujicyuiten__c,'
                        + 'Syushi__c,'
                        + 'Syuha__c,'
                        + 'JiinDenoHoyoKa__c,'
                        + 'Teikeisaki__r.ShozokuSangouSangoJiin__c,'
                        + 'Teikeisaki__r.ShozokuSangouSangoJiin__r.Name,'
                        + 'Teikeisaki__r.ShozokuSangouSangoJiin__r.SangoJiinMeiFurigana__c,'
                        + 'MadoguchiSouryoRenrakuSaki__c,'
                        + 'Teikeisaki__r.Fax,'
                        + 'Teikeisaki__r.Name,'
                        + 'Teikeisaki__r.ShozokuSangouSangoJiin__r.HoujinTanniKubun__c,'
                        + 'HomutaiokanoArea__c,'
                        + 'Teikeisaki__r.Nenrei__c,'
                        + 'Iraisyosofuhouhou__c,'
                        + 'Teikeisaki__r.MailAddress__c,'
                        + 'Teikeisaki__r.Seibetsu__c,'
                        + 'AmazonTaioka__c,'
                        + 'DenwaHoyoKahi__c,'
                        + 'Kaimyojuyonomiirai__c,'
                        + 'Teikeisaki__c,'
                        + '('
                        + '      SELECT Id '
                        + '      FROM KeiyakusSyuKeiyaku__r '
                        + '      WHERE RecordType.DeveloperName = \'ObousanBinJohouSya\' '
                        + '      And KeiyakuJokyo__c = \'契約中\' '
                        + '  ),'
                        //+ 'Teikeisaki__r.PersonContactId,'
                        + 'Teikeisaki__r.BillingLatitude,'
                        + 'Teikeisaki__r.BillingLongitude,'
                        + 'Teikeisaki__r.BillingAddress,'
                        + 'Teikeisaki__r.BillingState,'
                        + 'Teikeisaki__r.BillingCity,'
                        + 'Teikeisaki__r.BillingStreet,'
                        + 'Teikeisaki__r.BillingPostalCode,'
                        + 'Teikeisaki__r.HyokaSouryo__c,'
                        + 'Teikeisaki__r.SouryoClaimNum__c,'
                        + 'DISTANCE(Teikeisaki__r.BillingAddress, GEOLOCATION(:centerShikugun.Chiriichijouhou__latitude__s,:centerShikugun.Chiriichijouhou__longitude__s), \'km\') dist '
                        + ' FROM Keiyaku__c ';

        Date tehaikensakubi = searchJoken.TehaibiKensakuyo__c;

        if(searchWrapper.radioLookup){
            if(String.isNotBlank(searchJoken.ShikugunRef__c)){
                for(Shikugun__c lTempObject : [SELECT Id, Name, Chiriichijouhou__latitude__s, Chiriichijouhou__longitude__s FROM Shikugun__c WHERE Id = :searchJoken.ShikugunRef__c limit 1]){
                    centerShikugun = lTempObject;
                    searchWrapper.centerLat = lTempObject.Chiriichijouhou__latitude__s;
                    searchWrapper.centerLon = lTempObject.Chiriichijouhou__longitude__s;
                    searchWrapper.defLat = lTempObject.Chiriichijouhou__latitude__s;
                    searchWrapper.defLon = lTempObject.Chiriichijouhou__longitude__s;
                }
            }
        }
        else if(searchWrapper.radioText && searchWrapper.address != ''){
            centerShikugun.Name = searchWrapper.address;
            centerShikugun.Chiriichijouhou__latitude__s=searchWrapper.latitudeAdress;
            centerShikugun.Chiriichijouhou__longitude__s=searchWrapper.longitudeAdress;
            searchWrapper.centerLat = searchWrapper.latitudeAdress;
            searchWrapper.centerLon = searchWrapper.longitudeAdress;
            searchWrapper.defLat = searchWrapper.latitudeAdress;
            searchWrapper.defLon = searchWrapper.longitudeAdress;
        }

        String strWhere = 'WHERE RecordType.DeveloperName = \'Obosanbin\' AND KeiyakuJokyo__c = \'契約中\' ';
        // 宗旨
        if(String.isNotBlank(searchJoken.JiinSyusi__c)){
            strWhere += ' AND Syushi__c = \'' + searchJoken.JiinSyusi__c + '\'';
        }
        // 宗派
        if(String.isNotBlank(searchJoken.ShuhaKensakuYo__c)){
            if(searchJoken.ShuhaKensakuYo__c == '臨済宗'){
                strWhere += ' AND Syuha__c = :shushaGroup';
            }
            else{
                strWhere += ' AND Syuha__c = \'' + searchJoken.ShuhaKensakuYo__c + '\'';
            }
        }
        // 所属山号寺院名(カナ)
        if(String.isNotBlank(searchJoken.SangoJiinMeiFurigana__c)){
            strWhere += ' AND SyozokusangojiinmeFurigana__c like \'%' + searchJoken.SangoJiinMeiFurigana__c + '%\'';
        }
        // 窓口僧名(カナ)
        if(String.isNotBlank(searchJoken.LastNameFurigana__pc)){
            strWhere += ' AND MadoguchiSomeiFurigana__c like \'%' + searchJoken.LastNameFurigana__pc + '%\'';
        }
        // 戒名授与のみ依頼
        if(String.isNotBlank(searchJoken.Kaimyojuyonomiirai__c)){
            strWhere += ' AND Kaimyojuyonomiirai__c = \'' + searchJoken.Kaimyojuyonomiirai__c + '\'';
        }
        // 窓口僧侶連絡先
        if(String.isNotBlank(searchJoken.Phone)){
            strWhere += ' AND MadoguchiSouryoRenrakuSaki__c like \'%' + searchJoken.Phone + '%\'';
        }

        strWhere += ' AND ( NOT (Teikeisaki__r.YosinRef__r.NpTorihikiTorokuKahi__c = \'不可\' '
                    + ' OR Teikeisaki__r.YosinRef__r.NpSaikenHoshoStatus__c = \'NG\' ))';

        strQuery += strWhere;
        strQuery += ' Order by Teikeisaki__r.BillingLatitude asc NULLS LAST';

        System.debug('==strQuery==' + strQuery);

        List<Keiyaku__c> searchResultList = database.query(strQuery);
        if(searchResultList.size() == 0){
            messageInfo = '検索結果は0件です。';
        }
        else if(searchResultList.size() > 100){
            messageInfo = '検索結果が多いため100件を表示しています。';
        }

        List<ComparableSoryo> comparableSoryoList = new List<ComparableSoryo>();
        List<ID> teikeisakiIdList = new List<ID>();
        for(Keiyaku__c searchResult : searchResultList){
            if(tehaikensakubi != null){
                teikeisakiIdList.add(searchResult.Teikeisaki__c);
            }
            Location loc1 = Location.newInstance(centerShikugun.Chiriichijouhou__latitude__s,centerShikugun.Chiriichijouhou__longitude__s);
            Location loc2 = Location.newInstance(searchResult.Teikeisaki__r.BillingLatitude,searchResult.Teikeisaki__r.BillingLongitude);
            Decimal distanceValue = Location.getDistance(loc1, loc2, 'km');

            ComparableSoryo temp = new ComparableSoryo(new SoryoWrapper(searchResult, distanceValue));
            comparableSoryoList.add(temp);
        }

        comparableSoryoList.sort();

        Map<ID, Map<ID, List<Event>>> madoguchiSoryoIdMap = new Map <ID, Map<ID, List<Event>>>();
        Map<ID, ID> accountIdMap = new Map<ID, ID>();
        if(tehaikensakubi != null){
            Datetime sDateTime = Datetime.newInstance(tehaikensakubi.Year(), tehaikensakubi.Month(), tehaikensakubi.day() - 1, 24, 0, 0);
            Datetime eDateTime = Datetime.newInstance(tehaikensakubi.Year(), tehaikensakubi.Month(), tehaikensakubi.day(), 23, 59, 59);

            List<Event> sltEventList = [select Id, WhoId, Who.Name, WhatId, AtesakiRef__c, AtesakiRef__r.Name, Subject, StartDateTime, EndDateTime
                                        from Event
                                        where StartDateTime != null and EndDateTime != null and (
                                                (EndDateTime >= :sDateTime and EndDateTime <= :eDateTime) or
                                                (StartDateTime >= :sDateTime and EndDateTime <= :eDateTime) or
                                                (StartDateTime >= :sDateTime and StartDateTime <= :eDateTime) or
                                                (StartDateTime <= :sDateTime and EndDateTime >= :eDateTime))
                                        order by StartDateTime asc];

            List<ID> contactIdList = new List<ID>();
            for(Event sltEvent : sltEventList){
                contactIdList.add(sltEvent.WhoId);
                Map<ID, List<Event>> tempSekoSoryoIdMap = new Map<ID, List<Event>>();
                if(madoguchiSoryoIdMap.containskey(sltEvent.WhoId)){
                    tempSekoSoryoIdMap = madoguchiSoryoIdMap.get(sltEvent.WhoId);
                }

                String sekoSoryoId = '';
                if(sltEvent.AtesakiRef__c != null) sekoSoryoId = sltEvent.AtesakiRef__c;
                else if(sltEvent.WhoId != null) sekoSoryoId = sltEvent.WhoId;
                else continue;

                List<Event> tempSekoSoryoList = new List<Event>();
                if(tempSekoSoryoIdMap.containskey(sekoSoryoId)){
                    tempSekoSoryoList = tempSekoSoryoIdMap.get(sekoSoryoId);
                }
                tempSekoSoryoList.add(sltEvent);
                tempSekoSoryoIdMap.put(sekoSoryoId, tempSekoSoryoList);
                madoguchiSoryoIdMap.put(sltEvent.WhoId, tempSekoSoryoIdMap);
            }
            List<Contact> sltContactList = Dao_Contact.getContactListByContactIdList(contactIdList);
            for(Contact sltContact : sltContactList){
                System.debug('sltContact:' + sltContact);
                accountIdMap.put(sltContact.AccountId, sltContact.Id);
            }
        }

        Integer i = 0;
        for(ComparableSoryo comparableSoryo : comparableSoryoList){
            i++;
            SoryoWrapper soryoWrapper = comparableSoryo.sw;
            ResultWraper temp = new ResultWraper(i, soryoWrapper.keiyaku);
            if(soryoWrapper.distance != null){
                temp.distance = String.valueOf(soryoWrapper.distance.setScale(2)) + 'km';
            }

            // System.debug('soryoWrapper.keiyaku.Teikeisaki__c:' + soryoWrapper.keiyaku.Teikeisaki__c);
            if(accountIdMap.containsKey(soryoWrapper.keiyaku.Teikeisaki__c)){
                String contactId = accountIdMap.get(soryoWrapper.keiyaku.Teikeisaki__c);
                System.debug('contactId:' + contactId);
                if(madoguchiSoryoIdMap.containskey(contactId)){
                    System.debug('contactId:' + contactId);
                    List<EventWraper> soryoScheduleList = new List<EventWraper>();
                    Map<ID, List<Event>> sekoSoryoMap = madoguchiSoryoIdMap.get(contactId);
                    Integer iSeko = 0;
                    for(String sKey : sekoSoryoMap.keySet()){
                        List<Event> tempEventList = sekoSoryoMap.get(sKey);
                        String sekoSoryoId = '';
                        String sekoSoryoName = '';
                        if(tempEventList != null && tempEventList.size() > 0){
                            Event tempEvent = tempEventList.get(0);
                            if(tempEvent.AtesakiRef__c != null){
                                sekoSoryoId = tempEvent.AtesakiRef__c;
                                sekoSoryoName = tempEvent.AtesakiRef__r.Name;
                            }
                            else if(tempEvent.Who != null){
                                sekoSoryoId = tempEvent.WhoId;
                                sekoSoryoName = tempEvent.Who.Name;
                            }
                        }
                        iSeko++;
                        EventWraper eventWraper = new EventWraper();
                        eventWraper.resultIndex = iSeko;
                        eventWraper.sekoSoryoId = sekoSoryoId;
                        eventWraper.sekoSoryoName = sekoSoryoName;
                        eventWraper.eventList = tempEventList;
                        soryoScheduleList.add(eventWraper);
                    }
                    temp.soryoScheduleList = soryoScheduleList;
                }
            }

            resultWraperList.add(temp);
            if(i == 100) break;
        }
    }

    public void reloadMap(){return;}

    /**
    * クラス名      :   ResultWraper
    * クラス概要     :   僧侶検索結果
    * @created  :   2017/11/30 Vinh Hua Quoc
    * @modified :
    */
    public class ResultWraper {
        public Integer resultIndex {get;set;}
        public Keiyaku__c keiyaku {get; set;}
        public String distance {get; set;}
        public Double lat {get;set;}
        public Double lon {get;set;}
        public Boolean clickFlg {get; set;}
        public Integer johouSyaSuu {get; set;}
        public List<EventWraper> soryoScheduleList {get; set;}
        public ResultWraper(Integer resultIndex, Keiyaku__c keiyaku) {
            this.resultIndex = resultIndex;
            this.keiyaku = keiyaku;
            this.distance = '';
            this.lat = keiyaku.Teikeisaki__r.BillingLatitude;
            this.lon = keiyaku.Teikeisaki__r.BillingLongitude;
            this.clickFlg = false;
            this.soryoScheduleList = new List<EventWraper>();
            this.johouSyaSuu = keiyaku.KeiyakusSyuKeiyaku__r.size();
        }
    }

    public class EventWraper {
        public Integer resultIndex {get;set;}
        public String sekoSoryoId {get; set;}
        public String sekoSoryoName {get; set;}
        public List<Event> eventList {get; set;}
        public EventWraper() {
            this.resultIndex = null;
            this.sekoSoryoId = '';
            this.sekoSoryoName = '';
            this.eventList = new List<Event>();
        }
    }

    public void defaultSearchJoken(){
        searchJoken = new Account();
        searchWrapper = new SearchWrapper();
        centerShikugun = new Shikugun__c();
        centerShikugun.Name = '東京都都庁';
        centerShikugun.Chiriichijouhou__latitude__s = 35.689634;
        centerShikugun.Chiriichijouhou__longitude__s = 139.692101;
        resultWraperList = new List<ResultWraper>();
        messageInfo = '';
    }

    public Integer pClickIndex {get; set;}
    public Decimal pLat {get; set;}
    public Decimal pLon {get; set;}

    public void moveCenterPosition(){
        searchWrapper.centerLat = pLat;
        searchWrapper.centerLon = pLon;

        Integer clickIndex = pClickIndex - 1;
        List<ResultWraper> resultWraperTempList = new List<ResultWraper>();
        ResultWraper tempResultWraper = resultWraperList.get(clickIndex);
        tempResultWraper.resultIndex = 1;
        tempResultWraper.clickFlg = true;

        resultWraperTempList.add(tempResultWraper);
        resultWraperList.remove(clickIndex);
        Integer i = 2;
        for(ResultWraper resultWraper : resultWraperList){
            resultWraper.resultIndex = i;
            resultWraperTempList.add(resultWraper);
            i++;
        }

        resultWraperList = resultWraperTempList;
    }
}