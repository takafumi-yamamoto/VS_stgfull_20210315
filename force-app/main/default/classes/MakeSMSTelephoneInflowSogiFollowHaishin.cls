global class MakeSMSTelephoneInflowSogiFollowHaishin implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts {

        public final static String LF = '\n';
        // スケジューラー起動
        global void execute(SchedulableContext sc) {
            Integer theBatchSize = 200;
            Database.executeBatch(new MakeSMSTelephoneInflowSogiFollowHaishin(),theBatchSize);
        }

        global List<TelSogiFollowSMSDeliveryMember__c> start(Database.BatchableContext BC){
            // 葬儀SMS配信メンバーのデータ取得（取得条件は送付予定日＝システム日付）
            List<TelSogiFollowSMSDeliveryMember__c> listSmsSogifollow = new List<TelSogiFollowSMSDeliveryMember__c>();
            Date DateNow = Date.today();
            String StrSmsSendStatus = '未送信';
            String StrCheckEmail = '%@yoriso.com';
            TelephoneInflowSogi_Sms__mdt TelephoneInflowSogiSmsmdt = [SELECT Id, sms_sendflag__c,sms_sendTest_flag__c FROM TelephoneInflowSogi_Sms__mdt WHERE DeveloperName = :Environments.isSandbox() ? 'dev' : 'prod' limit 1];

            String query_str = '';
            query_str  = 'SELECT';
            query_str  = query_str  + ' Id ,';
            query_str  = query_str  + ' Tel_SendSogiSmsStatus__c ,' ; 
            query_str  = query_str  + ' Tel_SendSogiSmsPhase__c ,'  ;
            query_str  = query_str  + ' Tel_SendSogiSmsNumber__c ,' ;
            query_str  = query_str  + ' Opportunity__r.StageName ,' ;
            query_str  = query_str  + ' Opportunity__r.SmsSofuNg__c ,' ;
            query_str  = query_str  + ' Opportunity__r.TaishoushaJokyoGenzai__c ,' ;
            query_str  = query_str  + ' Opportunity__c, ';
            query_str  = query_str  + ' AccountID__c ,';
            query_str  = query_str  + ' Account__r.JizenJizenSheetTeishutsuzumi__c , ' ;
            query_str  = query_str  + ' Account__r.Tel_Sogifollow_SmsPermission__c , ' ;
            query_str  = query_str  + ' Account__r.MemberSeidoGoannaiJokyo__c , ';
            query_str  = query_str  + ' Account__r.MemberTourokuZumi__c,   ';
            query_str  = query_str  + ' Account__r.Tcms_SmsPermission__c,   ';
            query_str  = query_str  + ' Account__r.YorisoKiinKisanbi__c   ';
            query_str  = query_str  + ' FROM TelSogiFollowSMSDeliveryMember__c ';
            query_str  = query_str  + ' WHERE Tel_SendSogiSmsSchedule__c = :DateNow ';
            query_str  = query_str  + ' AND Tel_SendSogiSmsStatus__c = :StrSmsSendStatus ';

            if(TelephoneInflowSogiSmsmdt.sms_sendTest_flag__c){
                //「sms_sendTest_flag__c」は、本番環境でTESTを行うためのフラグ
                //メールアドレスに'@yoriso.com'が入っているデータのみを処理対象にする
                query_str  = query_str  + ' AND Account__r.YusenMailAddressFormula__c like :StrCheckEmail';
            }

            listSmsSogifollow = Database.query(query_str);

            return listSmsSogifollow;
        }
        global void execute(Database.BatchableContext BC, List<TelSogiFollowSMSDeliveryMember__c> listSmsSogifollow) {
            
            TelephoneInflowSogi_Sms__mdt TelephoneInflowSogiSmsmdt = [SELECT Id, sms_sendflag__c FROM TelephoneInflowSogi_Sms__mdt WHERE DeveloperName = :Environments.isSandbox() ? 'dev' : 'prod' limit 1];
            System.debug(TelephoneInflowSogiSmsmdt.sms_sendflag__c);

            // 配信前にデータの再確認　確認結果条件が変わった物は送信対象外
            Map<String,TelSogiFollowSMSDeliveryMember__c> sendSmsCancelMap = new Map<String,TelSogiFollowSMSDeliveryMember__c>();
            Map<String,TelSogiFollowSMSDeliveryMember__c> sendSmsSogiMap = new Map<String,TelSogiFollowSMSDeliveryMember__c>();
            Datetime sendDate = Datetime.now();
            for(TelSogiFollowSMSDeliveryMember__c SmsSendCandidacy : listSmsSogifollow){
                switch on SmsSendCandidacy.Tel_SendSogiSmsPhase__c {
                    when '0' {
                        // フェーズ０の場合
                        String checkResult = this.cancelZeroPhaseCheck(SmsSendCandidacy);
                        this.createTelSogiFollowSMSDeliveryMember(checkResult,SmsSendCandidacy,sendSmsCancelMap,sendSmsSogiMap,sendDate);
                        
                    }
                    when 'A' {
                        // フェーズAの場合
                        String checkResult = this.createCancelAPhaseCheck(SmsSendCandidacy);
                        this.createTelSogiFollowSMSDeliveryMember(checkResult,SmsSendCandidacy,sendSmsCancelMap,sendSmsSogiMap,sendDate);
                    }
                    when 'B' {
                        // フェーズBの場合
                        String checkResult = this.createCancelBPhaseCheck(SmsSendCandidacy);
                        this.createTelSogiFollowSMSDeliveryMember(checkResult,SmsSendCandidacy,sendSmsCancelMap,sendSmsSogiMap,sendDate);
                    }
                    when 'P' {
                        // フェーズPの場合
                        String checkResult = this.createCancelPPhaseCheck(SmsSendCandidacy);
                        this.createTelSogiFollowSMSDeliveryMember(checkResult,SmsSendCandidacy,sendSmsCancelMap,sendSmsSogiMap,sendDate);
                    }
                }
            }
            if(TelephoneInflowSogiSmsmdt.sms_sendflag__c){
                AccreteSmsApi smsApi = new AccreteSmsApi();
                for(String sogiKey : sendSmsSogiMap.keySet()){
                    TelSogiFollowSMSDeliveryMember__c sendSogiMember = sendSmsSogiMap.get(sogiKey);
                    String message = this.ceateSogiFollowMessage(sendSogiMember.Tel_SendSogiSmsPhase__c);
                    System.debug(sendSogiMember.Tel_SendSogiSmsNumber__c);
                    try {
                        smsApi.smsReg(message,
                        sendSogiMember.Tel_SendSogiSmsNumber__c,
                        sendSogiMember.Opportunity__c);
                    } catch (Exception e) {
                        String strException  = '';
                        strException = 'Exception : ' + e.getMessage() + '\r\n';
                        strException = strException  + 'LineNumber : ' + e.getLineNumber() + '\r\n';
                        strException = strException  + 'getStackTraceString : ' +  e.getStackTraceString() + '\r\n';
                        sendSmsSogiMap.put(
                            sogiKey,
                            new TelSogiFollowSMSDeliveryMember__c(
                                Id = sendSogiMember.Id,
                                AccountID__c = sendSogiMember.AccountID__c,
                                Tel_SendSogiSmsStatus__c = '送信NG',
                                Tel_SendSogiSmsResultMessage__c = strException,
                                Tel_SendSogiSmsDatetime__c = null
                            )
                        );
                    }
                }
            }
            if(sendSmsCancelMap.size() > 0){
				UPSERT sendSmsCancelMap.values() Id;
            }
            if(sendSmsSogiMap.size() > 0){
                UPSERT sendSmsSogiMap.values() Id;
                for(String sogiKey : sendSmsSogiMap.keySet()){
                    TelSogiFollowSMSDeliveryMember__c sendSogiMember = sendSmsSogiMap.get(sogiKey);
                    Opportunity o = OpportunityDao.sltById(sendSogiMember.Opportunity__c);
                    // コンタクトに残す
                    Task t = new Task();
                    t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Tsujo').getRecordTypeId();
                    t.WhoId = o.Account.PersonContactId;
                    t.WhatId = o.Id;
                    t.Status = '完了';
                    t.Subject = '';
                    t.ShiborikomiJoken__c = o.StageName + '：' + this.nullToblank(o.SubPhase__c);
                    t.YokenSyubetsu__c = '電話流入SMS送信';
                    t.TaskSubtype = 'Call';
                    t.Description = this.ceateSogiFollowMessage(sendSogiMember.Tel_SendSogiSmsPhase__c);
                    t.ServiceType__c = 'シンプル安豪';
                    t.OwnerId = UserInfo.getUserId();
                    insert t;
                }
            }
        }
        global void finish(Database.BatchableContext BC) {
        }
        

        public void createTelSogiFollowSMSDeliveryMember(String key,TelSogiFollowSMSDeliveryMember__c SmsSendCandidacy,Map<String,TelSogiFollowSMSDeliveryMember__c> sendSmsCancelMap,Map<String,TelSogiFollowSMSDeliveryMember__c> sendSmsSogiMap,Datetime sendDate){
            switch on key {
                when 'stageName' {
                    sendSmsCancelMap.put(
                        SmsSendCandidacy.AccountID__c,
                        new TelSogiFollowSMSDeliveryMember__c(
                            Id = SmsSendCandidacy.Id,
                            Tel_SendSogiSmsPhase__c = SmsSendCandidacy.Tel_SendSogiSmsPhase__c,
                            AccountID__c = SmsSendCandidacy.AccountID__c,
                            Tel_SendSogiSmsNumber__c = SmsSendCandidacy.Tel_SendSogiSmsNumber__c,
                            Opportunity__c = SmsSendCandidacy.Opportunity__c,
                            Tel_SendSogiSmsStatus__c = '対象外',
                            Tel_SendSogiSmsResultMessage__c = 'SMS送信処理前にフェーズがフォロー以外に更新された'
                        )
                    );
                }
                when 'taishousya' {
                    sendSmsCancelMap.put(
                        SmsSendCandidacy.AccountID__c,
                        new TelSogiFollowSMSDeliveryMember__c(
                            Id = SmsSendCandidacy.Id,
                            Tel_SendSogiSmsPhase__c = SmsSendCandidacy.Tel_SendSogiSmsPhase__c,
                            AccountID__c = SmsSendCandidacy.AccountID__c,
                            Opportunity__c = SmsSendCandidacy.Opportunity__c,
                            Tel_SendSogiSmsNumber__c = SmsSendCandidacy.Tel_SendSogiSmsNumber__c,
                            Tel_SendSogiSmsStatus__c = '対象外',
                            Tel_SendSogiSmsResultMessage__c = 'SMS送信処理前に対象者状態が死亡に更新された'
                        )
                    );
                }
                when 'sogismspermission' {
                    sendSmsCancelMap.put(
                        SmsSendCandidacy.AccountID__c,
                        new TelSogiFollowSMSDeliveryMember__c(
                            Id = SmsSendCandidacy.Id,
                            Tel_SendSogiSmsPhase__c = SmsSendCandidacy.Tel_SendSogiSmsPhase__c,
                            AccountID__c = SmsSendCandidacy.AccountID__c,
                            Opportunity__c = SmsSendCandidacy.Opportunity__c,
                            Tel_SendSogiSmsNumber__c = SmsSendCandidacy.Tel_SendSogiSmsNumber__c,
                            Tel_SendSogiSmsStatus__c = '対象外',
                            Tel_SendSogiSmsResultMessage__c = 'SMS送信処理前に電話流入葬儀フォローSMS許諾またはトラコスSMSパーミッション取得が「なし」として更新された'
                        )
                    );
                }
                when 'smsng' {
                    sendSmsCancelMap.put(
                        SmsSendCandidacy.AccountID__c,
                        new TelSogiFollowSMSDeliveryMember__c(
                            Id = SmsSendCandidacy.Id,
                            Tel_SendSogiSmsPhase__c = SmsSendCandidacy.Tel_SendSogiSmsPhase__c,
                            AccountID__c = SmsSendCandidacy.AccountID__c,
                            Opportunity__c = SmsSendCandidacy.Opportunity__c,
                            Tel_SendSogiSmsNumber__c = SmsSendCandidacy.Tel_SendSogiSmsNumber__c,
                            Tel_SendSogiSmsStatus__c = '対象外',
                            Tel_SendSogiSmsResultMessage__c = 'SMS送信処理前にSMSNGが「有」として更新された'
                        )
                    );
                }
                when 'SeidoGoannaiJyokyo'{
                    sendSmsCancelMap.put(
                        SmsSendCandidacy.AccountID__c,
                        new TelSogiFollowSMSDeliveryMember__c(
                            Id = SmsSendCandidacy.Id,
                            Tel_SendSogiSmsPhase__c = SmsSendCandidacy.Tel_SendSogiSmsPhase__c,
                            AccountID__c = SmsSendCandidacy.AccountID__c,
                            Opportunity__c = SmsSendCandidacy.Opportunity__c,
                            Tel_SendSogiSmsNumber__c = SmsSendCandidacy.Tel_SendSogiSmsNumber__c,
                            Tel_SendSogiSmsStatus__c = '対象外',
                            Tel_SendSogiSmsResultMessage__c = 'SMS送信処理前にメンバー制度ご案内状況が「登録拒否」として更新された'
                        )
                    );
                }
                when 'MemberTourokuZumi'{
                    sendSmsCancelMap.put(
                        SmsSendCandidacy.AccountID__c,
                        new TelSogiFollowSMSDeliveryMember__c(
                            Id = SmsSendCandidacy.Id,
                            Tel_SendSogiSmsPhase__c = SmsSendCandidacy.Tel_SendSogiSmsPhase__c,
                            AccountID__c = SmsSendCandidacy.AccountID__c,
                            Opportunity__c = SmsSendCandidacy.Opportunity__c,
                            Tel_SendSogiSmsNumber__c = SmsSendCandidacy.Tel_SendSogiSmsNumber__c,
                            Tel_SendSogiSmsStatus__c = '対象外',
                            Tel_SendSogiSmsResultMessage__c = 'SMS送信処理前に事前割メンバー登録済が「有」として更新された'
                        )
                    );
                }
                when 'JizenJizenSheetTeishutsuzumi'{
                    sendSmsCancelMap.put(
                        SmsSendCandidacy.AccountID__c,
                        new TelSogiFollowSMSDeliveryMember__c(
                            Id = SmsSendCandidacy.Id,
                            Tel_SendSogiSmsPhase__c = SmsSendCandidacy.Tel_SendSogiSmsPhase__c,
                            AccountID__c = SmsSendCandidacy.AccountID__c,
                            Opportunity__c = SmsSendCandidacy.Opportunity__c,
                            Tel_SendSogiSmsNumber__c = SmsSendCandidacy.Tel_SendSogiSmsNumber__c,
                            Tel_SendSogiSmsStatus__c = '対象外',
                            Tel_SendSogiSmsResultMessage__c = 'SMS送信処理前に事前準備シートご案内状況が「無」として更新された'
                        )
                    );
                }
                when 'Yorisokaiin'{
                    sendSmsCancelMap.put(
                        SmsSendCandidacy.AccountID__c,
                        new TelSogiFollowSMSDeliveryMember__c(
                            Id = SmsSendCandidacy.Id,
                            Tel_SendSogiSmsPhase__c = SmsSendCandidacy.Tel_SendSogiSmsPhase__c,
                            AccountID__c = SmsSendCandidacy.AccountID__c,
                            Opportunity__c = SmsSendCandidacy.Opportunity__c,
                            Tel_SendSogiSmsNumber__c = SmsSendCandidacy.Tel_SendSogiSmsNumber__c,
                            Tel_SendSogiSmsStatus__c = '対象外',
                            Tel_SendSogiSmsResultMessage__c = 'SMS送信処理前によりそう会員起算日がNULLとなった'
                        )
                    );
                }
                when 'clear' {
                    sendSmsSogiMap.put(
                        SmsSendCandidacy.AccountID__c,
                        new TelSogiFollowSMSDeliveryMember__c(
                            Id = SmsSendCandidacy.Id,
                            Tel_SendSogiSmsPhase__c = SmsSendCandidacy.Tel_SendSogiSmsPhase__c,
                            AccountID__c = SmsSendCandidacy.AccountID__c,
                            Opportunity__c = SmsSendCandidacy.Opportunity__c,
                            Tel_SendSogiSmsNumber__c = SmsSendCandidacy.Tel_SendSogiSmsNumber__c,
                            Tel_SendSogiSmsStatus__c = '送信OK',
                            Tel_SendSogiSmsResultMessage__c = '送信成功',
                            Tel_SendSogiSmsMessage__c = this.ceateSogiFollowMessage(SmsSendCandidacy.Tel_SendSogiSmsPhase__c),
                            Tel_SendSogiSmsDatetime__c = sendDate
                        )
                    );
                }
            }

        }
        public String cancelZeroPhaseCheck(TelSogiFollowSMSDeliveryMember__c SmsSendCandidacy){
            if(SmsSendCandidacy.Opportunity__r.StageName != 'フォロー'){
                // SMS送信時にフェーズがフォロー以外に変更された
                return 'stageName';
            }else if( SmsSendCandidacy.Opportunity__r.TaishoushaJokyoGenzai__c == '死亡' ){
                // 対象者状態が死亡に変更された
                return 'taishousya';

            }else  if(SmsSendCandidacy.Account__r.Tel_Sogifollow_SmsPermission__c != true 
            && SmsSendCandidacy.Account__r.Tcms_SmsPermission__c != 'OK'){
                // 電話流入葬儀フォローSMS許諾 または　トラコスSMSパーミッション取得が変更された
                return 'sogismspermission';
            }else if(SmsSendCandidacy.Opportunity__r.SmsSofuNg__c == True ){
                // SMS NGが変更された。
                return 'smsng';
            }else{
                return 'clear';
            }
        }

        public String createCancelAPhaseCheck (TelSogiFollowSMSDeliveryMember__c SmsSendCandidacy) {
            String checkResult = this.cancelZeroPhaseCheck(SmsSendCandidacy);
            if(checkResult != 'clear'){
                return checkResult;
            }
            if(SmsSendCandidacy.Account__r.MemberSeidoGoannaiJokyo__c == '提出拒否'){
                return 'SeidoGoannaiJyokyo';

            }else if(SmsSendCandidacy.Account__r.MemberTourokuZumi__c == True){
                return 'MemberTourokuZumi';

            }else{
                return 'clear';
            }
        }
        public String createCancelBPhaseCheck (TelSogiFollowSMSDeliveryMember__c SmsSendCandidacy) {
            String checkResult = this.cancelZeroPhaseCheck(SmsSendCandidacy);
            if(checkResult != 'clear'){
                return checkResult;
            }
            if(SmsSendCandidacy.Account__r.MemberTourokuZumi__c == False){
               return 'MemberTourokuZumi';
            }else if(SmsSendCandidacy.Account__r.JizenJizenSheetTeishutsuzumi__c == True ){
                return 'JizenJizenSheetTeishutsuzumi';
            }else{
                return 'clear';
            }
        }

        public String createCancelPPhaseCheck (TelSogiFollowSMSDeliveryMember__c SmsSendCandidacy) {
            String checkResult = this.cancelZeroPhaseCheck(SmsSendCandidacy);
            if(checkResult != 'clear'){
                return checkResult;
            }
            if(SmsSendCandidacy.Account__r.MemberSeidoGoannaiJokyo__c == '提出拒否'){
                return 'SeidoGoannaiJyokyo';
            }else if(SmsSendCandidacy.Account__r.JizenJizenSheetTeishutsuzumi__c == True ){
                return 'JizenJizenSheetTeishutsuzumi';
            }else if(SmsSendCandidacy.Account__r.YorisoKiinKisanbi__c == null){
               return 'Yorisokaiin';
            }else{
                return 'clear';
            }
        }

        public String ceateSogiFollowMessage (String phase) {
            switch on phase {
                when '0' {
                    return 'よりそうお葬式です。資料ご請求頂きありがとうございます。資料を送付させて頂きました。ご不明点等が御座いましたらお気軽にお問い合わせ下さい。'+ LF+LF+'【よりそうお葬式】0120-541-590'+ LF +'http://ux0.jp/Sc327O'+ LF +'※本SMSは送信専用となります。';
                }
                when 'A' {
                    return 'よりそうお葬式です。最大1.1万円の割引（税込）の割引が受けられる「よりそう会員制度（無料）」のご案内です。'+LF+LF+
                    '先々の不安があり、お葬式の事を早めに考えておきたい。そんな方を応援するために生まれたよりそう会員制度です。'+LF+LF
                    +'詳細は同封されておりますパンフレットを確認頂くか、お気軽に弊社までお問い合わせください。【よりそうお葬式】0120-541-590 ';
                }
                when 'B' {
                    return 'よりそうお葬式です。万が一の際、慌てることのないように「事前アンケート」のご案内です。'+LF+LF
                    +'事前アンケートとはお葬式の「仮予約」のようなサービスです。記入しておくと、お電話一本でお葬式の手配からお式までがスムーズに進みます。'+LF+LF
                    +'詳細は同封されておりますパンフレットを確認頂くか、お気軽に弊社までお問い合わせください。【よりそうお葬式】0120-541-590 ';
                }
                when 'P'{
                    return 'よりそうお葬式です。よりそう会員登録（無料）頂いたお客様限定へ「葬儀用ブーケ無料贈呈」のご案内です。'+LF+LF
                    +'本メッセージ受信から14日以内に事前アンケート記入を完了されたお客様へ 「よりそうお葬式」でお葬式を上げられる際に「お悔やみ・お供えの花」を無料でお贈り致します' +LF + LF
                    +'※一部適用条件がございます。お電話での受付も承っておりますのでお気軽に専門相談員までお電話ください。【よりそうお葬式】0120-541-590';
                }
                when else{
                    return '';
                }
            }
        }

        public String nullToblank(String value){
            if(value == null){
                return '';
            }
            return value;
        }

}