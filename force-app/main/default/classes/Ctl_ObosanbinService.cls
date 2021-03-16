public class Ctl_ObosanbinService {

    //お坊さん便日程Dao
    public class ObosanbinNittei {
        // Frontのパラメータからオブジェクトに転換
        public List<ObosanbinNittei__c> FrontToObosanbinNittei(Case theCase, List<Api_V1_ObousanbinMoushikomi.Tsuika_nitteis> tsuika_nitteis){
            if(tsuika_nitteis == null) return new List<ObosanbinNittei__c>();
            List<ObosanbinNittei__c> obosanbinnitteiList = new List<ObosanbinNittei__c>();
            for(Api_V1_ObousanbinMoushikomi.Tsuika_nitteis front_nittei : tsuika_nitteis){

                ObosanbinNittei__c obosanbinnittei = new ObosanbinNittei__c();
                obosanbinnittei.case__c = theCase.Id ;    //プラン名
                obosanbinnittei.plan_name__c = front_nittei.plan_name ;    //プラン名
                obosanbinnittei.yotei_date__c = Com_Utility.toDate(front_nittei.yotei_date);    //予定日
                obosanbinnittei.jizen_tsuchi_yotei_date__c = Com_Utility.toDate(front_nittei.jizen_tsuchi_yotei_date) ;    //事前通知予定日
                obosanbinnitteiList.add(obosanbinnittei);
            }
            insert obosanbinnitteiList;
            return obosanbinnitteiList;
        }

    }

    //サービス商談作成 
    public class ObosanbinWebYouyaku {

        public ObosanbinWebYouyaku(){
        }

        public void start(String josnStr){
            Api_V1_ObousanbinMoushikomi.Data theData = null;

            theData = (Api_V1_ObousanbinMoushikomi.Data)JSON.deserialize(josnStr, Api_V1_ObousanbinMoushikomi.Data.class);

            // ケース作成
            Case newCase = this.FrontToObosanbinCase(theData);
            // お坊さん便日程作成
            List<ObosanbinNittei__c> obousanbinNittei = new Ctl_ObosanbinService.ObosanbinNittei().FrontToObosanbinNittei(newCase, theData.tsuika_nitteis);
            // 商談作成
            this.CaseToServiceOpportunity(newCase, obousanbinNittei);
            
        }

        // case 作成
        private Case FrontToObosanbinCase(Api_V1_ObousanbinMoushikomi.Data theData) {
            // ケース作成
            Case newCase = new Case();
            //レコードタイプID
            newCase.RecordTypeId         = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','ObousanbinNetYoyaku');
 
            newCase.Status               = '新規';
            newCase.Origin               = 'Web';            
            // ga_client_id
            newCase.GaClientId__c        = theData.gaclient_id;
            //メール処理Id
            newCase.uniq_id__c           = theData.mail_syori_id;
            //問合せ日
            newCase.ToiawaseDate__c      = Com_Utility.toDateTime(theData.toiawase_date);      
            //入口
            newCase.Entrance__c          = theData.iriguchi_name;
            //申込者姓
            newCase.LastName__c          = theData.customer_sei;
            //申込者名
            newCase.FirstName__c         = theData.customer_mei;
            //申込者姓(カナ)
            newCase.LastNameKana__c      = theData.customer_sei_kana;
            //申込者名(カナ)
            newCase.FirstNameKana__c     = theData.customer_mei_kana;            
            //電話番号            
            if(Com_Utility.isMobile(theData.customer_tel)) {
                newCase.KeitaiDenwa__c       = theData.customer_tel;
            }
            else{
                newCase.TelNo__c             = theData.customer_tel;
            }            
            //申込者メールアドレス
            newCase.MailAddress__c       = theData.customer_mail; 
            //申込者住所.郵便番号
            newCase.PostalCode__c       = theData.customer_postal_code;
            //申込者住所.都道府県
            newCase.State__c       = theData.customer_state;
            //申込者住所.市区郡
            newCase.City__c       = theData.customer_city;
            //申込者住所.町名番地
            newCase.Street__c       = theData.customer_street;
            //資料送付先住所.郵便番号
            newCase.ShiryohassosakiZipCode__c       = theData.siryo_sofu_postal_code;
            //資料送付先住所.都道府県
            newCase.ShiryohassosakiState__c       = theData.siryo_sofu_state;
            //資料送付先住所.市区郡
            newCase.ShiryohassosakiCity__c       = theData.siryo_sofu_city;
            //資料送付先住所.町名番地
            newCase.ShiryohassosakiStreet__c       = theData.siryo_sofu_street;
            //対象者姓
            newCase.TaishoshaSei__c       = theData.taisyosya_sei;
            //対象者名
            newCase.TaishoshaMei__c       = theData.taisyosya_mei;
            //対象者姓(カナ)
            newCase.TaishoshaSeiFurigana__c       = theData.taisyosya_sei_kana;
            //対象者名(カナ)
            newCase.TaishoshaMeiFurigana__c       = theData.taisyosya_mei_kana;
            //対象者生年月日
            newCase.TaishoshaSeinengappi__c       = Com_Utility.toDate(theData.taisyosya_birthday);        
            //対象者逝去日
            newCase.TaishoushaBotsunengappi__c       = Com_Utility.toDate(theData.taisyosya_seikyodate);      
            //対象者続柄
            newCase.ZokugaraSodanshaNitottenoTaishosha__c       = theData.taisyosya_zokugara;      
            //対象者宗派
            newCase.Shuha__c       = theData.taisyosya_syuha;
            //対象者その他宗派
            newCase.SonotanoSyukyoSyuha__c       = theData.taisyosya_sonotasyuha;
            //菩提寺有無
            newCase.TaishoshaBodaijinoUmu__c       = Api_V1_ItemValueMaster.getTaisyosyaBodaijiUmu(theData.taisyosya_bodaiji_umu);
            //法要場所.名称
            newCase.HoyobashoMei__c       = theData.hoyo_basyo_name;
            //法要場所.郵便番号
            newCase.HoyobashoZipCode__c       = theData.hoyo_basyo_postal_code;
            //法要場所.都道府県
            newCase.HoyobashoState__c       = theData.hoyo_basyo_state;
            //法要場所.市区郡
            newCase.HoyobashoCity__c       = theData.hoyo_basyo_city;
            //法要場所.町名
            newCase.HoyobashoTyoumei__c       = theData.hoyo_basyo_tyoumei;
            //法要場所.番地
            newCase.HoyobashoStreet__c       = theData.hoyo_basyo_street;
            //法要場所2.名称
            newCase.TsuikahoyobashoMei__c       = theData.hoyo_basyo2_name;
            //法要場所2.郵便番号
            newCase.TsuikahoyobashoZipCode__c       = theData.hoyo_basyo2_postal_code;
            //法要場所2.都道府県
            newCase.TsuikahoyobashoState__c       = theData.hoyo_basyo2_state;
            //法要場所2.市区郡
            newCase.TsuikahoyobashoCity__c       = theData.hoyo_basyo2_city;
            //法要場所2.町名番地
            newCase.TsuikahoyobashoStreet__c       = theData.hoyo_basyo2_street;
            //第一希望.日付
            newCase.HoyoKiboDate1__c       = Com_Utility.toDate(theData.hoyo_date1);       
            //第一希望.時間
            newCase.HoyoKiboTime1__c       = theData.hoyo_hour1;
            //第一希望.分
            newCase.HoyoKiboMinute1__c       = theData.hoyo_minute1;
            //第二希望.日付
            newCase.HoyoKiboDate2__c       = Com_Utility.toDate(theData.hoyo_date2);                
            //第二希望.時間
            newCase.HoyoKiboTime2__c       = theData.hoyo_hour2;
            //第二希望.分
            newCase.HoyoKiboMinute2__c       = theData.hoyo_minute2;
            //第三希望.日付
            newCase.HoyoKiboDate3__c       = Com_Utility.toDate(theData.hoyo_date3);         
            //第三希望.時間
            newCase.HoyoKiboTime3__c       = theData.hoyo_hour3;
            //第三希望.分
            newCase.HoyoKiboMinute3__c       = theData.hoyo_minute3;
            //お坊さん便.法事法要
            newCase.HojiHoyo__c       = Api_V1_ItemValueMaster.getHojiHoyo(theData.hoyo);
            //お坊さん便.その他法要
            newCase.SonotanoHoyo__c       = theData.sonota_hoyo;    
            //お坊さん便.追加法要    
            newCase.TsuikaHoyo__c       = theData.tsuika_hoyo;
            //お坊さん便.戒名授与希望
            newCase.KaimyoHomeijuyo__c       = Api_V1_ItemValueMaster.getKaimyoHomeijuyo(theData.kaimyo_kibo);
            //お坊さん便.希望戒名
            newCase.KaimyoPlan__c       = Api_V1_ItemValueMaster.getKaimyoPlan(theData.kaimyo_plan); 
            //お客様コメント  
            newCase.OkyakusamaCommnet__c       = theData.customer_comment; 
            //確認連絡の希望有無
            newCase.KakuninRenrakuNoKiboUmu__c       = Api_V1_ItemValueMaster.getKakuninRenrakuNoKiboUmu(theData.kakunin_renraku_kibo);
            //利用回数
            newCase.Riyokaisu__c       = Api_V1_ItemValueMaster.getRiyokaisu(theData.riyokaisu); 
            //お盆セット
            newCase.Obonset__c       = Api_V1_ItemValueMaster.getObonsetMap(theData.obonset);
            //商品送付先
            newCase.ProductPlaceSelect__c       = theData.productPlaceSelect; 
            //  【メール用】複数予約プラン
            newCase.FukusuHoyo__c = theData.getFukusuHoyo();
            //  メンバー登録希望
            newCase.MemberTourokuKibo__c       = Api_V1_ItemValueMaster.getMemberTourokuKibo(theData.member_touroku_kibo);
            //式場
            newCase.ShikijoName__c = theData.saijo;
            //式場.郵便番号
            newCase.ShikijoZipCode__c = theData.saijo_postal_code;
            //式場.都道府県
            newCase.ShikijoState__c = theData.saijo_state;
            //式場.市区郡
            newCase.ShikijoCity__c = theData.saijo_city;
            //式場場所.町名
            newCase.ShikijoTyoumei__c       = theData.saijo_tyoumei;
            //式場.番地
            newCase.ShikijoStreet__c = theData.saijo_street;
            //火葬日
            if(theData.kaso_date != null && theData.kaso_hour != null && theData.kaso_minute != null){
                newCase.KasoDateTime_Inp__c = createDateTime(theData.kaso_date, theData.kaso_hour, theData.kaso_minute);
            }
            //通夜日時
            if(theData.tsuya_date != null && theData.tsuya_hour != null && theData.tsuya_minute != null){
                newCase.TsuyaDateTime_Inp__c = createDateTime(theData.tsuya_date, theData.tsuya_hour, theData.tsuya_minute);
            }
            //告別式日時
            if(theData.kokubetsu_date != null && theData.kokubetsu_hour != null && theData.kokubetsu_minute != null){
               newCase.KokubetsushikiNichiji__c = createDateTime(theData.kokubetsu_date, theData.kokubetsu_hour, theData.kokubetsu_minute);
            }
            //初七日有無
            newCase.Shonanoka__c = theData.syonanoka_umu;
            //火葬場名
            newCase.Kasoba__c = theData.kaso_place;
            
            // 希望支払い方法
            if(theData.kibo_shiharai_hoho == 'genkin') newCase.ShiharaiHouhou__c = '現金';
            if(theData.kibo_shiharai_hoho == 'credit') newCase.ShiharaiHouhou__c = 'クレジットカード決済';
            if(theData.kibo_shiharai_hoho == 'atobarai') newCase.ShiharaiHouhou__c = 'おきもち後払い';
            
 			// 資料送付先 メールマガジン
            if(theData.mailmagazine == '1'){
	            newCase.PermissionFlag__c                    = TRUE ;
            }

            // トリガ停止
            Trg_Case.isActive = false;
            this.BeforeCaseInsert(newCase);
            insert newCase;
            this.OnAfterInsert(newCase);
            Trg_Case.isActive = true;

            return newCase;
        }

        private void BeforeCaseInsert(Case aCase){
            List<Case> newList = new List<Case>{aCase};
            new Ctl_Case().CaseInitialize(newList, null);
            new Ctl_Account().searchForExistenceOfAccount(newList);
            new Ctl_Account().searchForExistenceTaishoshaOfAccount(newList);
        }

        private void OnAfterInsert(Case aCase){
            // case to 会員登録
            List<Case> newList = new List<Case>{aCase};
            new Ctl_Account.MemberTouroku().onCaseAfterInsert(newList);
        }

        // 商談作成(商談商品、お客様請求明細作成)
        public List<opportunity> CaseToServiceOpportunity(Case aCase, List<ObosanbinNittei__c> obousannitteis){
            Case theCase = this.ReloadCase(aCase);
            if(theCase == null) return null;
            if(theCase.RecordTypeId != RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','ObousanbinNetYoyaku')) return null;

            // サービス商談
            List<opportunity> insOppLst = new List<opportunity>();
            Opportunity serviceOpp = new Ctl_Opportunity().CaseToServiceOpportunity(theCase, AccountDaos.GetInstance().GetDefualtAccount());
            serviceOpp.KetteiPlanName__c = theCase.HojiHoyo__c;
            insOppLst.add(serviceOpp);
            INSERT insOppLst;

            List<OpportunityLineItem> theLineItemsToInsert = new List<OpportunityLineItem>();
            { //自動追加する商談商品の作成
                List<SrthShohinResolving.ShohinLine> theShohinLines = 
                    new SrthShohinResolving().getShohinLines(
                        new SrthShohinResolving.Request()
                            .setRiyokaisu(theCase.Riyokaisu__c).setHojiHoyo(theCase.HojiHoyo__c).setKaimyoPlan(theCase.KaimyoPlan__c)
                    );
                for(SrthShohinResolving.ShohinLine aLine : theShohinLines){
                    PriceBookDao.PriceBookEnt thePriceBookEnt = PriceBookDao.instance().getEntry(serviceOpp.Pricebook2Id, aLine.shohinCode);
                    if(thePriceBookEnt == null) continue;
                    theLineItemsToInsert.add(
                        new OpportunityLineItem(
                            OpportunityId = serviceOpp.Id, Product2Id = thePriceBookEnt.product2Id, Quantity = 1, UnitPrice = thePriceBookEnt.unitPrice
                        )
                    );
                }
            }
            INSERT theLineItemsToInsert;

            return insOppLst;
        }

        private Case ReloadCase(Case aCase){
            List<Case> reloadedList = Dao_Case.SearchByIds(new List<Id>{aCase.Id});
            if(reloadedList.size() > 0) return reloadedList[0];
            return null;
        }

        private DateTime createDateTime(String kasoDate, String kasoTime, String kasoMinute){

          List<String> strKasoDates = String.valueOf(kasoDate).split('-', 0);

          Integer intYear   = Integer.valueOf(strKasoDates.get(0));
          Integer intMonth  = Integer.valueOf(strKasoDates.get(1));
          Integer intDate   = Integer.valueOf(strKasoDates.get(2));
          Integer intHour   = Integer.valueOf(kasoTime);
          Integer intMinute = Integer.valueOf(kasoMinute);
          Integer intSecond = 0;
          
          DateTime changedKasoDate = DateTime.newInstance(intYear, intMonth, intDate, intHour, intMinute, intSecond);

          return changedKasoDate;
        }
    }

    public class CaseToShodanTaskProcessor{

        public void sendStartRequest(){
            Asyncs_Broker.requestStart( CaseToShodanTaskProcessor.Class.toString() );
        }

        public void subscriveOnAyncBrokerOnRunRequested(string pRequestName){
            if(pRequestName == CaseToShodanTaskProcessor.Class.toString() ){ 
                new CaseToShodanTaskProcessor().start();
            }
        }

        public void start(){
            List<ObouYoyakuCaseToShodanTask__c> theTasks = new List<ObouYoyakuCaseToShodanTask__c>(
                [
                    select Id
                    from ObouYoyakuCaseToShodanTask__c 
                    where ShoriStatus__c = 'Created'
                    limit 20
                    for update
                ]
            );
            for(ObouYoyakuCaseToShodanTask__c aTask : theTasks){ aTask.ShoriStatus__c = 'Running'; } 
            Update theTasks;

            for(ObouYoyakuCaseToShodanTask__c aTask : theTasks){ System.enqueueJob( new CaseToShodanTaskJob(aTask.Id) ); }

            List<ObouYoyakuCaseToShodanTask__c> theTaskLeft = new List<ObouYoyakuCaseToShodanTask__c>(
                [
                    select Id
                    from ObouYoyakuCaseToShodanTask__c 
                    where ShoriStatus__c = 'Created'
                    limit 1
                ]
            );
            if( theTaskLeft.size() >= 1 ) this.sendStartRequest();
        }
    }

    public class CaseToShodanTaskJob implements Queueable {

        private Id f_TaskId;
        public CaseToShodanTaskJob(Id pTaskId){ this.f_TaskId = pTaskId; }

        public void run(){
            List<ObouYoyakuCaseToShodanTask__c> theTasks = 
                new List<ObouYoyakuCaseToShodanTask__c>(
                    [
                        select Id, CaseRef__c, data__c from ObouYoyakuCaseToShodanTask__c where Id = :this.f_TaskId limit 1
                    ]
                );

            if(theTasks.size() <= 0) return; 

            ObouYoyakuCaseToShodanTask__c theTask = theTasks.get(0);

            if(String.isBlank(theTask.data__c)){
                theTask.ShoriStatus__c = 'Completed';
                Update theTask;
                return;
            }

            try{
                new Ctl_ObosanbinService.ObosanbinWebYouyaku().start(theTask.data__c);

                theTask.ShoriStatus__c = 'Completed';
                Update theTask;
            }catch(Exception e){
                theTask.ShoriStatus__c = 'Faulted';
                Update theTask;
                //write log

                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, Datetime.now().format('yyyyMMdd-HHmm-ss'), 'Ctl_ObosanbinService.CaseToShodanTaskJob().start()', 'お坊さん便ネット予約失敗')
                            .putAttr('TaskId', theTask.Id)
                            .putAttr('Exception', e.getMessage())
                            .putAttr('LineNumber', '' + e.getLineNumber())
                            .putAttr('TypeName', e.getTypeName())
                            .putAttr('Cause', '' + e.getCause())
                );
            }
        }

        //implements Queable begin
        public void execute(QueueableContext context) { this.run(); }
        //implements Queable end
    }
}