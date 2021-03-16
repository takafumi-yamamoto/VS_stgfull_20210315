global class  MakeSMSTelephoneInflowSogiFollow implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts  {
    // スケジューラー起動
    global void execute(SchedulableContext sc) {
        Integer theBatchSize = 200;
        Database.executeBatch(new MakeSMSTelephoneInflowSogiFollow(),theBatchSize);
    }

    global List<TelSogiFollowSMSDeliveryMember__c> start(Database.BatchableContext BC){
        
        // 資料送付オブジェクトから取得対象の商談IDを特定
        Date today = Date.today();
        DateTime timetoday = Datetime.newInstance(today, Time.newInstance(0, 0, 0, 0));
        Date afterDay = today.addDays(-5);
        DateTime afterTimeToday = Datetime.newInstance(afterDay, Time.newInstance(0, 0, 0, 0));
        String shiryousoufuQuery = '';
        shiryousoufuQuery = 'SELECT ';
        shiryousoufuQuery = shiryousoufuQuery + ' SofuNichiji__c, ';
        shiryousoufuQuery = shiryousoufuQuery + ' OpportunityRef__c ';
        shiryousoufuQuery = shiryousoufuQuery + ' FROM SogiShiryoSofu__c ';
        shiryousoufuQuery = shiryousoufuQuery + ' WHERE SofuNichiji__c < :timetoday ';
        shiryousoufuQuery = shiryousoufuQuery + ' AND SofuNichiji__c >= :afterTimeToday ';
        List<SogiShiryoSofu__c> shiryousoufuList = new List<SogiShiryoSofu__c>();
        shiryousoufuList = Database.query(shiryousoufuQuery);
        Set<String> OpportunityID1day = new Set<String>();
        Set<String> OpportunityID5day = new Set<String>();
        Set<String> OpportunityIDAllday = new Set<String>();
        for(SogiShiryoSofu__c record : shiryousoufuList){
            Date soufunitiji = record.SofuNichiji__c.date();
            Integer daysdue = soufunitiji.daysBetween(today);
            switch on daysdue {
                when 1 {
                    OpportunityID1day.add(record.OpportunityRef__c);
                }
                when 5 {
                    OpportunityID5day.add(record.OpportunityRef__c);
                }
            }
            OpportunityIDAllday.add(record.OpportunityRef__c);
        }

        // 各フェーズ毎に商談からデータ取得
        ID OpportunityTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
        List<ID> CaseRecordTypeId = new List<ID>();
		CaseRecordTypeId.add(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoOtoiawase').getRecordTypeId());
        List<Opportunity> ListOpp1day = new List<Opportunity>();
        List<Opportunity> ListOpp5dayA = new List<Opportunity>();
        List<Opportunity> ListOpp5dayP = new List<Opportunity>();
        String checkStageName = 'フォロー';
        String taishoushajokyo = '死亡';
        String annaijyokyo = '登録拒否';
        String jjannnaijyokyo = '提出拒否';
        String transPermissionOK = 'OK';
        String transIriguchiName = '電話';
        List<String> itakusakiName = new List<String>();
        itakusakiName.add('トランスコスモス');
        String basequerystr = ''; 
        String query_str1day  = '';
        String query_str5dayA  = '';
        String query_strAlldayP  = '';
		basequerystr   = 'SELECT';
		basequerystr   = basequerystr  + ' Id,';
		basequerystr   = basequerystr  + ' AccountId,';
        basequerystr   = basequerystr  + ' Account.MobilePhone__c ,';
        basequerystr   = basequerystr  + ' Account.MemberSeidoGoannaiJokyo__c, ';
        basequerystr   = basequerystr  + ' Account.MemberTourokuZumi__c ';
        basequerystr   = basequerystr  + ' FROM Opportunity';
        basequerystr   = basequerystr  + ' WHERE RecordTypeId = :OpportunityTypeId ';
        basequerystr   = basequerystr  + ' AND StageName = :checkStageName'; // 死亡以外　フェーズ：フォロー 
        basequerystr   = basequerystr  + ' AND TaishoushaJokyoGenzai__c != :taishoushajokyo'; // 対象者状態:死亡以外
        basequerystr   = basequerystr  + ' AND SmsSofuNg__c = False '; // ご連絡許可情報(連絡手段) SMS NG チェックなし
        basequerystr   = basequerystr  + ' AND ( ( CaseRef__r.RecordTypeId in :CaseRecordTypeId AND Account.Tel_Sogifollow_SmsPermission__c = True ) '
        + 'OR (Iriguchi__c = :transIriguchiName AND JudenItakuSaki__c IN :itakusakiName AND Account.Tcms_SmsPermission__c = :transPermissionOK ) ) ';
        
        query_str1day  = basequerystr  + ' AND Id in :OpportunityID1day'; // 商談ID (送付日から1日経過)
        query_str5dayA = basequerystr  + ' AND Id in :OpportunityID5day'; // 商談ID (送付日から5日経過)
        query_str5dayA = query_str5dayA  + ' AND Account.MemberSeidoGoannaiJokyo__c != :annaijyokyo'; // ご提案活動.メンバー制度ご案内状況 「登録拒否」以外
        query_str5dayA = query_str5dayA  + ' AND Account.MemberTourokuZumi__c = False '; // ご提案活動.事前割メンバー登録済 False or True

        query_strAlldayP = basequerystr  + ' AND Id in :OpportunityIDAllday'; // 商談ID (直近の送付日5日間の商談ID)
        query_strAlldayP = query_strAlldayP  + ' AND Account.MemberTourokuZumi__c = True '; // ご提案活動.事前割メンバー登録済 True

        // 事前準備シートご案内状況：「登録拒否」以外 事前準備シートご提出手段：(空欄）事前準備シート受領日：(空欄） = 取引先.事前準備シート提出済: False 
        query_strAlldayP = query_strAlldayP  + ' AND Account.JizenJizenSheetTeishutsuzumi__c = False ';
        query_strAlldayP = query_strAlldayP  + ' AND SimpleYasugoRef__r.JizenJunbiSheetGoannaiJokyo__c != :annaijyokyo '; // 事前準備シートご案内状況：「登録拒否」以外
        Date kaiinTargetDate = today.addDays(-2);
        query_strAlldayP = query_strAlldayP  + ' AND Account.YorisoKiinKisanbi__c = :kaiinTargetDate';// よりそう会員起算日から２日経過したもの
        System.debug(query_str1day);
        System.debug(query_str5dayA);
        System.debug(query_strAlldayP);
        ListOpp1day = Database.query(query_str1day);
        ListOpp5dayA = Database.query(query_str5dayA);
        ListOpp5dayP = Database.query(query_strAlldayP);

        // 既に送付対象となっている商談があれば除外する
        Map<String, Opportunity> Opp1DayMap = new Map<String, Opportunity>();
        List<String> day1OppIdlist = new List<String>();
        for(Opportunity dayonerecord : ListOpp1day){
            Opp1DayMap.put(dayonerecord.Id,dayonerecord);
            day1OppIdlist.add(dayonerecord.Id);
        }
        Map<String, Opportunity> Opp5DayAMap = new Map<String, Opportunity>();
        List<String> day5AOppIdlist = new List<String>();
        for(Opportunity dayfiveARecord : ListOpp5dayA ){
            Opp5DayAMap.put(dayfiveARecord.Id,dayfiveARecord);
            day5AOppIdlist.add(dayfiveARecord.Id);
        }
        Map<String, Opportunity> Opp5DayPMap = new Map<String, Opportunity>();
        List<String> day5POppIdlist = new List<String>();
        for(Opportunity dayfiveBRecord : ListOpp5dayP ){
            Opp5DayPMap.put(dayfiveBRecord.Id,dayfiveBRecord);
            day5POppIdlist.add(dayfiveBRecord.Id);
        }
        String firstPhase  = '0';
        String secondPhase = 'A';
        String thirdPhase  = 'P';

        List<TelSogiFollowSMSDeliveryMember__c>  check1stData = 
            this.getTelSogiFollowSMSDeliveryMemberData(firstPhase, day1OppIdlist);
        for(TelSogiFollowSMSDeliveryMember__c duplicateData : check1stData){
            Opp1DayMap.remove(duplicateData.Opportunity__c);
        }
        List<TelSogiFollowSMSDeliveryMember__c>  check2ndData = 
            this.getTelSogiFollowSMSDeliveryMemberData(secondPhase, day5AOppIdlist);
        for(TelSogiFollowSMSDeliveryMember__c duplicate2ndData : check2ndData){
            Opp5DayAMap.remove(duplicate2ndData.Opportunity__c);
        }
        List<TelSogiFollowSMSDeliveryMember__c>  check3rdData = 
            this.getTelSogiFollowSMSDeliveryMemberData(thirdPhase, day5POppIdlist);
        for(TelSogiFollowSMSDeliveryMember__c duplicate3rdData : check3rdData){
            Opp5DayPMap.remove(duplicate3rdData.Opportunity__c);
        }

        Set<Opportunity> set1stOpp = this.OpportunitymapToListConvert(Opp1DayMap);
        Set<Opportunity> set2ndOpp = this.OpportunitymapToListConvert(Opp5DayAMap);
        Set<Opportunity> set3rdOpp = this.OpportunitymapToListConvert(Opp5DayPMap);

        // SMS送信対象のデータ作成
        List<TelSogiFollowSMSDeliveryMember__c> retMember = new List<TelSogiFollowSMSDeliveryMember__c>();
        List<TelSogiFollowSMSDeliveryMember__c> retMemberA = new List<TelSogiFollowSMSDeliveryMember__c>();
        List<TelSogiFollowSMSDeliveryMember__c> retMemberB = new List<TelSogiFollowSMSDeliveryMember__c>();
        retMember = this.addTelSogiFollowSMSDeliveryMemberData(set1stOpp,firstPhase,retMember);
        retMember = this.addTelSogiFollowSMSDeliveryMemberData(set2ndOpp,secondPhase,retMember);
        retMember = this.addTelSogiFollowSMSDeliveryMemberData(set3rdOpp,thirdPhase,retMember);

        return retMember;
    }

    global void execute(Database.BatchableContext BC, List<TelSogiFollowSMSDeliveryMember__c> ListOpp) {
        if(ListOpp.size() > 0){
            insert ListOpp;
        }
    }

    global void finish(Database.BatchableContext BC) {
    }

    public String genTelNoKey(String pTelNo){
		if(String.isBlank(pTelNo)) return null;
		String regEx = '[^0-9]';   
		Pattern p = Pattern.compile(regEx);   
		Matcher m = p.matcher(pTelNo);
		String theReplaced = m.replaceAll('').trim();
		return String.isBlank(theReplaced) ? null : theReplaced;
    }

    public Set<Opportunity> OpportunitymapToListConvert (Map<String, Opportunity> Opp) {
        Set<Opportunity> retSet = new Set<Opportunity>();
        for(String oppkey : Opp.keySet()){
            retSet.add(Opp.get(oppkey));
        }
        return retSet;
    }

    public List<TelSogiFollowSMSDeliveryMember__c>  addTelSogiFollowSMSDeliveryMemberData(Set<Opportunity> setOpp,String phase,List<TelSogiFollowSMSDeliveryMember__c> retMember ){
        Date sysdate = Date.today();
        String StrMobilePhone = '090,080,070';
        List<String> ChkMobilePhone = StrMobilePhone.split(',');
        for(Opportunity record : setOpp){
            String MobilePhone = this.genTelNoKey(record.Account.MobilePhone__c);
            if(ChkMobilePhone.indexOf(MobilePhone.left(3)) > -1 
            && MobilePhone.length() == 11){
                TelSogiFollowSMSDeliveryMember__c member = new TelSogiFollowSMSDeliveryMember__c(
                    Tel_SendSogiSmsPhase__c = phase,
                    Opportunity__c = record.Id,
                    Account__c = record.AccountId,
                    AccountID__c = record.AccountId,
                    Tel_SendSogiSmsNumber__c = MobilePhone,
                    Tel_SendSogiSmsStatus__c = '未送信',
                    Tel_SendSogiSmsSchedule__c = sysdate
                );
                retMember.add(member);
            }
        }
        return retMember;
    }
    
    public List<TelSogiFollowSMSDeliveryMember__c> getTelSogiFollowSMSDeliveryMemberData ( String phase , List<String> oppId ){
        String checkDuplicateRecordquery = '';
        checkDuplicateRecordquery = 'SELECT';
        checkDuplicateRecordquery = checkDuplicateRecordquery + ' Tel_SendSogiSmsStatus__c, ';
        checkDuplicateRecordquery = checkDuplicateRecordquery + ' Opportunity__c ';
        checkDuplicateRecordquery = checkDuplicateRecordquery + ' FROM TelSogiFollowSMSDeliveryMember__c ';
        checkDuplicateRecordquery = checkDuplicateRecordquery + ' WHERE Opportunity__c in :oppId';
        checkDuplicateRecordquery = checkDuplicateRecordquery + ' AND Tel_SendSogiSmsPhase__c = :phase';
        return Database.query(checkDuplicateRecordquery);
    }
}