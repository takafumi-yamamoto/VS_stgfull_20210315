public class Ctl_Opportunity {

  public void OpportunityInitialize(List<Opportunity> newList, Map<ID, Opportunity> oldMap, Map<ID, Account> accountMap){

    Set<Id> oppKetteiIdSet = new Set<Id>();

    for(Opportunity opportunity : newList){
      if(opportunity.RyosyuAtenaIsSodansha__c && (oldMap == null || !oldMap.get(opportunity.Id).RyosyuAtenaIsSodansha__c)){
        Account account = accountMap.get(opportunity.AccountId);
        String atena = account.LastName;
        if(account.FirstName != null && account.FirstName != ''){
          atena += ' ' + account.FirstName;
        }
        opportunity.RyosyuAtena__c = atena;
        opportunity.RyosyuSoufuPostalCode__c = account.BillingPostalCode;
        opportunity.RyosyuSoufuSakiState__c = account.BillingState;
        opportunity.RyosyuSoufuSakiCity__c = account.BillingCity;
        opportunity.RyosyuSoufuSakiStreet__c = account.BillingStreet;
      }

      if(opportunity.SiryoSoufuSakiIsSoudansya__c && (oldMap == null || !oldMap.get(opportunity.Id).SiryoSoufuSakiIsSoudansya__c)){
        Account account = accountMap.get(opportunity.AccountId);
        String atena = account.LastName;
        if(account.FirstName != null && account.FirstName != ''){
          atena += ' ' + account.FirstName;
        }
        opportunity.ShiryoSoufuSakiAtena__c = atena;
        opportunity.ShiryoSoufuSakiAtenaKana__c = account.NameFurigana__c;
        opportunity.ShiryoSoufuSakiPostalCode__c = account.BillingPostalCode;
        opportunity.ShiryoSoufuSakiState__c = account.BillingState;
        opportunity.ShiryoSoufuSakiCity__c = account.BillingCity;
        opportunity.ShiryoSoufuSakiStreet__c = account.BillingStreet;
        opportunity.ShiryoSoufuSakiMailAddress__c = account.MailAddress__c;
      }

      if(oldMap == null){
        if(String.isBlank(opportunity.RyosyuSoufuSakiName__c)) opportunity.RyosyuSoufuSakiName__c = opportunity.RyosyuAtena__c;
      } else {
        Opportunity oldOpp = oldMap.get(opportunity.Id);
        if(opportunity.RyosyuAtena__c != oldOpp.RyosyuAtena__c){
          if(String.isBlank(opportunity.RyosyuSoufuSakiName__c)) opportunity.RyosyuSoufuSakiName__c = opportunity.RyosyuAtena__c;
        }
      }

      if(opportunity.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId() && 
            ((opportunity.StageName == '決定' && (oldMap == null || oldMap.get(opportunity.Id).StageName != '決定')) || 
            (opportunity.StageName == '施行待ち' && (oldMap == null || oldMap.get(opportunity.Id).StageName != '施行待ち')))){
        oppKetteiIdSet.add(opportunity.Id);
      }
    }
    setKakuteibiSyodan(newList,oldMap);
    if(oppKetteiIdSet.size() > 0){
      System.debug('oppKetteiIdSet:' + oppKetteiIdSet);
      processOppStageNameShodanKetteiList(oppKetteiIdSet);
    }
  }
  private void setKakuteibiSyodan(List<Opportunity> newList, Map<ID, Opportunity> oldMap){
    String[] clearNotTargetStatus = new List<String>{'決定','施行待ち','施行完了','商談クローズ'};
    if(oldMap == null) return;

    for(Opportunity opportunity : newList){

      if ((opportunity.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')) &&
          (opportunity.StageName=='決定') && 
          ((oldMap.get(opportunity.Id).StageName=='問合せ受付') ||
           (oldMap.get(opportunity.Id).StageName=='フォロー') || 
           (oldMap.get(opportunity.Id).StageName=='事前準備処理中') || 
           (oldMap.get(opportunity.Id).StageName=='事前準備完了') || 
           (oldMap.get(opportunity.Id).StageName=='お亡くなり対応'))){
            opportunity.KakuteibiSyodan__c=system.now();
      }
            if ((opportunity.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin')) &&
          (opportunity.StageName=='決定') && 
          ((oldMap.get(opportunity.Id).StageName=='問合せ受付') ||
           (oldMap.get(opportunity.Id).StageName=='フォロー') ||
           (oldMap.get(opportunity.Id).StageName=='予約') || 
           (oldMap.get(opportunity.Id).StageName=='生前契約商談') || 
           (oldMap.get(opportunity.Id).StageName=='生前契約成立'))){
            opportunity.KakuteibiSyodan__c=system.now();
      }      

      if(opportunity.recordtypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId()){
        if(opportunity.KakuteibiSyodan__c!=null && !clearNotTargetStatus.contains(opportunity.StageName)
              && clearNotTargetStatus.contains(oldMap.get(opportunity.Id).StageName)){
          opportunity.KakuteibiSyodan__c=null;
        }
      }
      
    }
  }

  @Future(callout=true)
  public static void processOppStageNameShodanKetteiList(Set<Id> oppKetteiIdSet){
    try{
      List<Opportunity> oppList = [select 
                                    Id,
                                    SimpleYasugoRef__c, 
                                    SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, 
                                    SimpleYasugoRef__r.KetteijiTantoshaRef__c,
                                    SimpleYasugoRef__r.TokuyakutenKeiyakuRef__c
                                  from 
                                    Opportunity 
                                  where 
                                    Id = :oppKetteiIdSet and 
                                    SimpleYasugoRef__c != null];

      List<Opportunity> updateOppList = new List<Opportunity>();
      List<SimpleYasugo__c> updateSimpleList = new List<SimpleYasugo__c>();
      for(Opportunity opp : oppList){

        if(opp.SimpleYasugoRef__r.KetteijiTantoshaRef__c == null){
          System.debug('UserInfo.getUserId():' + UserInfo.getUserId());
          SimpleYasugo__c sy = new SimpleYasugo__c();
          sy.Id = opp.SimpleYasugoRef__c;
          sy.KetteijiTantoshaRef__c = UserInfo.getUserId();
          updateSimpleList.add(sy);       
        }
        if(opp.SimpleYasugoRef__r.TokuyakutenKeiyakuRef__c != null){
          Decimal tesuryo = SogiTokuyakutenTesuryoCalc.get_ITesuryoCalculator_incetance().get_tokuyakuten_tesuryo(opp.Id);
          if(tesuryo != 0){
            opp.TokuyakutenTesuryoKihonbunKari__c = tesuryo;
            updateOppList.add(opp);
          }
        }
      }

      if(updateSimpleList.size() > 0){
        update updateSimpleList;
      }

      if(updateOppList.size() > 0){
        update updateOppList;
      }
    }
    catch(Exception e){
      Loggings.writeLog(
        Loggings.createLogEntry(Loggings.Level.Error, '20190215-1105-01', 'OpportunityKettei')
          .putAttr('userId', UserInfo.getUserId() )
          .putAttr('e.getMessage()', e.getMessage() )
          .putAttr('LineNumber', '' + e.getLineNumber())
          .putAttr('getStackTraceString', e.getStackTraceString())
      );
    }
  }
  
  public static Date slideDay(Date d){
    datetime tDate = datetime.newInstance(d.year(), d.month(), d.day());
    switch on  tDate.format('E') {
      when 'Sun' {
        return d.addDays(1);
      }
      when 'Sat' {
        return d.addDays(2);
      }
      when else {
        return d;
      }
    }
  }
   
  public void OrderTransferToCore(list<opportunity> newList,map<id,opportunity> OldMap){
      List<opportunity> oppLst = getTransferData(newList,OldMap);
      if (oppLst.size()>0) SendToJob(oppLst);
    }  
    public void SendToJob(list<opportunity> syoriList){
      for (opportunity opp:syoriList){
          System.enqueueJob(new Ctl_OpportunityTransferJob(opp));
      }
    }

    private List<opportunity> getTransferData(list<opportunity> newList,map<id,opportunity> OldMap){
      list<opportunity> OppLst = new list<opportunity>();
      for(opportunity newData : newList){
        opportunity oldData = oldMap.get(newData.id);

        if(newData.IsWon == oldData.IsWon) continue;
        if(newData.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId()){
          OppLst.add(newData);
        }
      }
      return OppLst;
    }

  /**
  * グルバール検索用データ更新
  */
  public void setSearchTxt(List<Opportunity> newList, Map<ID, Opportunity> oldMap){
    List<Id> accountIds = new List<Id>();
    List<Opportunity> changeOppList = new List<Opportunity>();

    for(Opportunity newOpportunity : newList){
      Boolean isChange = (oldMap == null)
               || (newOpportunity.AccountId != oldMap.get(newOpportunity.Id).AccountId);
      if(isChange){
        accountIds.add(newOpportunity.AccountId);
        changeOppList.add(newOpportunity);
      }
    }

    List<Account> accList = Dao_Account.getInstance().selectByIds(accountIds);
    Map<Id, Account> accountMap = new Map<Id,Account>(accList);
    for(Opportunity opp : changeOppList){
      if(accountMap.containsKey(opp.AccountId)){
        Account soudansya = accountMap.get(opp.AccountId);
        try {
              opp.SodanshaNameTxt__c = soudansya.Name;    // 相談者氏名(検索用)
              opp.SodanshaFuriganaTxt__c = soudansya.NameFurigana__c;    // 相談者氏名カナ(検索用)
              opp.SodanshaPhoneTxt__c = soudansya.Phone;    // 相談者電話番号(検索用)
              opp.SodanshaMobilePhoneTxt__c = soudansya.MobilePhone__c;    // 相談者携帯番号(検索用)
        }
        catch (Exception e) {
            System.debug(e);
            
        }
        
      }

    }

    //setSearchSimpleYasugoTxt(newList, oldMap);

  }
  
  public void opportunityInitialValue(List<Opportunity> newList, Map<ID, Opportunity> oldMap){
    Account DefualtAcc = getDefaultAccount();
    
    Map<ID, ID> targetOpportunityIdSet = new Map<ID, ID>();
    for(Opportunity newOpportunity : newList){
      if(newOpportunity.AccountId != oldMap.get(newOpportunity.Id).AccountId){
        targetOpportunityIdSet.put(newOpportunity.Id, newOpportunity.AccountId);
      }
    }

    List<Opportunity> updateOpportunityList = new List<Opportunity>();
    Map<ID, Account> accountIdMap = AccountDaos.GetInstance().SelectByIdsAsMapById(targetOpportunityIdSet.values());

    System.debug('accountIdMap:' + accountIdMap);
    for(Opportunity newOpportunity : newList){

      if(targetOpportunityIdSet.containsKey(newOpportunity.Id)){
        System.debug('targetOpportunityIdSet.get(newOpportunity.Id):' + targetOpportunityIdSet.get(newOpportunity.Id));
        ID accId = targetOpportunityIdSet.get(newOpportunity.Id);
        if(String.isBlank(accId) || accountIdMap.get(accId) == null){
          newOpportunity.AccountId = DefualtAcc.Id;
          newOpportunity.Name = DefualtAcc.Name + '_' + newOpportunity.RecordType__c;
        } else{
          newOpportunity.Name = accountIdMap.get(targetOpportunityIdSet.get(newOpportunity.Id)).Name + '_' + newOpportunity.RecordType__c;  
        }
      }
    }
  }
  
  /**
   * ケースリストからサービス商談作成
   *　ケース作成時にサービス商談を作成する
   * @param list<case> ケースリスト
   * @return null
   */
  public void CreateServiceOpportunityFromCases(list<case> CaseLst){    
    System.Debug('Ctl_Opportunity.CreateServiceOpportunityFromCases.Limits.getQueries().01;' + Limits.getQueries());
    Account DefualtAcc=getDefaultAccount();
    List<opportunity> insOppLst=new List<opportunity>();
    for (case c:CaseLst){
      opportunity oppTmp=new opportunity();
      oppTmp=CaseToServiceOpportunity(c,DefualtAcc);
      if (oppTmp!=null){
        insOppLst.add(oppTmp);
      }      
    }
    System.Debug('Ctl_Opportunity.CreateServiceOpportunityFromCases.Limits.getQueries().02;' + Limits.getQueries());

    System.Debug('Ctl_Opportunity.CreateServiceOpportunityFromCases.Limits.getQueries().03;' + Limits.getQueries());
    System.debug('---insOppLst--' + insOppLst);
    insert insOppLst;
    System.Debug('Ctl_Opportunity.CreateServiceOpportunityFromCases.Limits.getQueries().04;' + Limits.getQueries());
  }

  /**
   * ケースからサービス商談作成
   *　ケース作成時にサービス商談を作成する
   * @param Case c ケース
   * @return 作成した商談
   */  
  public opportunity CaseToServiceOpportunity(Case c,Account DefualtAcc){
        system.debug('====================CaseToServiceOpportunity.begin===================');        
        String serviceName='';
        String stageName = '';
        String subPhase = '';

        //サービス商談のレコードタイプID
            String recordTypeId;
      
            // シンプル安豪-お問合せ
            // シンプル安豪-資料請求Webフォーム
            // シンプル安豪-お問い合わせWebフォーム
            // シンプル安豪-エンディングノート請求Webフォーム

            if(c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoOtoiawase') ||
              c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoOtoiawaseWebForm') ||
              c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoEndingnoteWebForm')||
              c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','OsoshikiYoyaku_SiryoSeikyu_Web') || 
              c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoShiryoSeikyuWebForm')) {
              serviceName ='シンプル安豪';
              stageName   = '問合せ受付';
              subPhase    = 'お客様情報一時聴取/入力中';
              recordTypeId= RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo');
              System.debug('サービス作成：シンプル安豪');            
            }
            // 生前契約（事前契約）  
            else if(c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','Seizenkeiyaku') ) {
                serviceName='生前契約';
              stageName = '問合せ受付';
                recordTypeId= RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Seizenkeiyaku');
                System.debug('サービス作成：生前契約');
            }
            // お坊さん便-資料請求
            // お坊さん便-手配代行
            else if(c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','ObousanbinShiryoSeikyu') ||
                    c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','ObousanbinTehaidaikou')){
              serviceName = 'お坊さん便';
              stageName = 'フォロー';
              subPhase = 'フォロー';
                recordTypeId= RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin');
                System.debug('サービス作成：お坊さん便');
            }
            // お坊さん便-ネット予約
            else if(c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','ObousanbinNetYoyaku')){
              serviceName = 'お坊さん便';
              stageName = '予約';
              subPhase = '仮受注';
                recordTypeId= RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin');
                System.debug('サービス作成：お坊さん便');
            }
            // お坊さん便-電話受付
            else if(c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','Obosanbin') ) {
                serviceName = 'お坊さん便';
              stageName = '問合せ受付';
                recordTypeId= RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin');
                System.debug('サービス作成：お坊さん便');
            }   
            //永代供養      
            else if(c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','EtaikuyoShiryoseikyuWebForm')){
                serviceName='永代供養';
                stageName = 'フォロー';
                subPhase = '資料請求-eitai';
                recordTypeId= RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','PerpetualMemorial');
                System.debug('サービス作成：永代供養');
            }
            else if(c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','PerpetualMemorial')) {
                serviceName='永代供養';
              stageName = '問合せ受付';
                recordTypeId= RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','PerpetualMemorial');
                System.debug('サービス作成：永代供養');
            }
            //ベスト仏壇 
            else if(c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','BestButsudanOtoiawase') || 
                c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','KakuyasuButsudan')) {
                serviceName='ベスト仏壇';
              stageName = '問合せ受付';
                recordTypeId= RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuButsudan');
                System.debug('サービス作成：ベスト仏壇');
            }
            //供花配達レビ
            else if(c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','Kyouka')) {
                serviceName='供花配達レビ';
              stageName = '問合せ受付';
                recordTypeId= RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Kyouka');
                System.debug('サービス作成：供花配達レビ');
            } 
            //Umie
            else if(c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','KaiyoUmie') || 
                c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','KaiyosankotsuMoshikomiWebForm') ) {
                serviceName='海洋散骨';
              stageName = '問合せ受付';
                recordTypeId= RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KaiyoUmie');
                System.debug('サービス作成：海洋散骨');
            }
            //Sorae
            else if(c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SpaceFuneral')) {
                serviceName='宇宙葬';
              stageName = '問合せ受付';
                recordTypeId= RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SpaceFuneral');
                System.debug('サービス作成：宇宙葬');
            }  
            //墓ピタ
            else if(c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','Hakapita')||
                c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','HakapitaWebForm')||
                c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','HakapitaHokatsutoiawase')) {
                serviceName='墓ピタ';
              stageName = '問合せ受付';
                recordTypeId= RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Hakapita');
                System.debug('サービス作成：墓ピタ ');
            }            
            //格安墓石
            else if(c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','KakuyasuBoseki')) {
                serviceName='格安墓石';
              stageName = '問合せ受付';
                recordTypeId= RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuBoseki');
                System.debug('サービス作成：格安墓石');
            }                                              
            //事前割
            else if(c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','JizenwariWebMoshikomi')) {
                serviceName='事前割';
              stageName = '問合せ受付';
                recordTypeId= RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Simple_Jizenwari');
                System.debug('サービス作成：事前割');
            }
            //葬儀レビ
            else if(c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SogiReviShiryoSeikyuWebForm') ||
                c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SougiRev')) {
                serviceName='葬儀レビ';
              stageName = '問合せ受付';
                recordTypeId= RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SougiRev');
                System.debug('サービス作成：葬儀レビ');
            }
            else {
              serviceName='対象外';
              stageName = '問合せ受付';
              recordTypeId= null;
                System.debug('サービス作成：対象外');
                return null;
            }
            
      Opportunity opp= new Opportunity();

        if (c.accountId==null){
           opp.AccountId = DefualtAcc.id;
           opp.Name = '新規' + '_' + serviceName;
        }else{
             opp.AccountId = c.accountId;
           opp.Name = c.account.Name + '_' + serviceName;
        }
        
        opp.RecordTypeId = RecordTypeId;
        opp.CloseDate = date.Today();
        opp.StageName = stageName;
        opp.CaseRef__c = c.id;
        opp.Iriguchi__c = c.Entrance__c;
        opp.TaishoushaJokyo__c = c.TaishoushaJokyo__c;
        if(RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId() && (opp.TaishoushaJokyo__c == null || opp.TaishoushaJokyo__c == '')){
          opp.TaishoushaJokyo__c = '未聴取により不明';
        }
        //issues3806--Start--
        opp.TaishoshaKyojuKeitai__c = c.TaishoshaKyojuKeitai__c;
        if(RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId() && (opp.TaishoshaKyojuKeitai__c  == null || opp.TaishoshaKyojuKeitai__c  == '')){
          opp.TaishoshaKyojuKeitai__c  = '未聴取により不明';
        }
        opp.TaishoshaYomeiKikan__c = c.TaishoshaYomeiKikan__c;
        if(RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId() && (opp.TaishoshaYomeiKikan__c   == null || opp.TaishoshaYomeiKikan__c   == '')){
          opp.TaishoshaYomeiKikan__c   = '未聴取により不明';
        }
        opp.ToiawaseKiinsha__c = c.ToiawaseKiinsha__c;
        if(RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId() && (opp.ToiawaseKiinsha__c   == null || opp.ToiawaseKiinsha__c   == '')){
          opp.ToiawaseKiinsha__c   = '未聴取により不明';
        }
        if(c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoOtoiawaseWebForm') ||
          c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoEndingnoteWebForm')||
          c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','OsoshikiYoyaku_SiryoSeikyu_Web') || 
          c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoShiryoSeikyuWebForm')) {
          opp.TaishoushaJokyoKeteiFlg__c = true;
        }
        //issues3806--End--
        opp.JuyoRenrakuJiko__c = c.ImporantMessage__c;
        opp.Req_Day__c = c.ToiawaseDate__c;
        opp.SubPhase__c = subPhase;
        opp.Pricebook2Id = '01s7F0000064fmI';

        //資料請求有無
            if(c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoShiryoSeikyuWebForm') ) {
        opp.SiryoSeikyoAri__c = true;
            }

            //お坊さん便資料請求Web受付
            if(c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','ObousanbinShiryoSeikyu')) {
        opp.ShiryoSoufuSakiCity__c =  c.ShiryohassosakiCity__c; // 資料送付先 市区郡
        opp.ShiryoSoufuSakiPostalCode__c = c.ShiryohassosakiZipCode__c; //資料送付先 郵便番号
        opp.ShiryoSoufuSakiState__c = c.ShiryohassosakiState__c; //資料送付先 都道府県
        opp.ShiryoSoufuSakiStreet__c = c.ShiryohassosakiStreet__c; //資料送付先 町名番地
        opp.ShiryoSoufuSakiMailAddress__c = c.ShiryoSoufuSakiMailAddress__c; // 資料送付先 メールアドレス
        opp.ShiryoSoufuSakiAtena__c = c.ShiryoSoufuSakiAtena__c; //資料送付 宛名
        opp.ShiryoSoufuSakiAtenaKana__c = c.ShiryoSoufuSakiAtenaKana__c; //資料送付先 宛名(カナ)
        opp.ShiryoSoufuHoho__c = c.ShiryoSoufuHoho__c; //資料送付方法
            }

            // お坊さん便-ネット予約
            if(c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','ObousanbinNetYoyaku')) {
        opp.ShiryoSoufuSakiCity__c = c.ShiryohassosakiCity__c; // 資料送付先 市区郡
        opp.ShiryoSoufuSakiPostalCode__c = c.ShiryohassosakiZipCode__c; //資料送付先 郵便番号
              opp.ShiryoSoufuSakiState__c = c.ShiryohassosakiState__c; //資料送付先 都道府県
              opp.ShiryoSoufuSakiStreet__c = c.ShiryohassosakiStreet__c; //資料送付先 町名番地

        if(c.ShiharaiHouhou__c == '現金') opp.KiboShiharaiHouhou__c = '現金';
        if(c.ShiharaiHouhou__c == 'クレジットカード決済') opp.KiboShiharaiHouhou__c = 'カード';
        if(c.ShiharaiHouhou__c == 'おきもち後払い') opp.KiboShiharaiHouhou__c = 'おきもち後払い';
            }

      system.debug('====================CaseToServiceOpportunity.end===================');
      return opp;  
  }



    /**
   * サービス商談から取引商談作成
   * @param list<opportunity> oppLst　サービス商談リスト
   * @return null
   */  
  public void CreateTorihikiShodanFromServiceShodan(list<opportunity> oppLst, Map<ID, Account> accountMap){
    system.debug('====================CreateTorihikiShodanFromServiceShodan.begin===================');
    List<Opportunity> insOppList = new List<Opportunity>();
    Set<ID> accountIdSet=new Set<ID>();
    Set<ID> caseIdSet=new Set<ID>();
    
    //サービス商談と紐づく取引先IDをセットに取得
    for (opportunity opp:oppLst){
      accountIdSet.add(opp.accountid);
      caseIdSet.add(opp.CaseRef__c);
    }
    accountIdSet.add(System.Label.ShinkShodanyoKojintorihikisaki);
    
    //取引先IDによる取引先のすべての情報を取得
    //Map<ID, Account> accountMap = new Map<ID, Account>([select Id, Name from Account where Id in :accountIdSet]);
    Map<ID, Case> caseMap = Dao_Case.getCaseMapByIds(caseIdSet);
    
    //取引商談のレコードタイプIDを取得
    String torihikiShodanRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
    String seizenShodanRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Seizenkeiyaku');
    
    // 2018/02/01 add yamamoto start 取引商談は毎回作成するためコメントアウト
    //Map<ID, opportunity> torihikiShodanMap = new Map<ID, opportunity>();
    
    //既存の取引商談を取得
    //for (opportunity torihikiShodan:[select id,accountid from Opportunity where recordtypeid=:torihikiShodanRecordTypeId and accountId in :accountIdSet]){
    //  torihikiShodanMap.put(torihikiShodan.accountid,torihikiShodan);
    //}
    // 2018/02/01 add yamamoto end

    //入力したサービス商談リストをループして、
    for (opportunity opp:oppLst){
      //レコードタイプが取引商談の場合、スキップする
      if (opp.TorihikiShodanRef__c != null || opp.recordTypeId==torihikiShodanRecordTypeId || opp.recordTypeId==seizenShodanRecordTypeId){
        continue;
      }
      // 2018/02/01 add yamamoto start 取引商談は毎回作成するためコメントアウト
      //取引商談オブジェクトを作成する、もし既存の取引商談が存在すれば、Nullを返して、新規しない。
      //opportunity oppTmp=ServiceShodanToTorihikiShodan(opp,torihikiShodanMap,accountMap);
      // 2018/02/01 add yamamoto end
      opportunity oppTmp=ServiceShodanToTorihikiShodan(opp,accountMap, caseMap);
      system.debug('***oppTmp='+oppTmp);
      if (oppTmp!=null){
        insOppList.add(oppTmp);
      }
    }    
    system.debug('***insOppList='+insOppList);
    insert insOppList;
    
    //2018/02/14 修正　サービス商談と取引商談紐1対1紐づく----begin---
      //サービス商談と取引商談紐づく
      integer index=0;
    for (opportunity opp:oppLst){
      //レコードタイプが取引商談の場合、スキップする
      if (opp.TorihikiShodanRef__c != null || opp.recordTypeId==torihikiShodanRecordTypeId || opp.recordTypeId==seizenShodanRecordTypeId){
        continue;
      }      
      opportunity torihikiShodan=insOppList[index];      
      opp.TorihikiShodanRef__c=torihikiShodan.id;
      index=index+1;
    }
    //2018/02/14 修正　サービス商談と取引商談紐1対1紐づく----end---        
    system.debug('====================CreateTorihikiShodanFromServiceShodan.end===================');
  }
    /**
   * サービス商談から取引商談作成
   * @param opportunity opp　商談
   * @param Map<ID, opportunity> torihikiShodanMap　既存の取引商談マップ
   * @param Account> accountMap　取引先マップ 
   * @return null
   */
  // 2018/02/01 add yamamoto start 取引商談は毎回作成するためコメントアウト
  //public opportunity ServiceShodanToTorihikiShodan(opportunity opp,Map<ID, opportunity> torihikiShodanMap,Map<ID, Account> accountMap){
  // 2018/02/01 add yamamoto end
  public opportunity ServiceShodanToTorihikiShodan(opportunity opp,Map<ID, Account> accountMap, Map<ID, Case> caseMap){
    system.debug('====================ServiceShodanToTorihikiShodan.begin===================');
    id Accid=opp.accountid;    
    //もし商談の取引先が設定していなければ、ディフォルトの取引先を使用
    if (opp.accountid==null){
      Accid=System.Label.ShinkShodanyoKojintorihikisaki;
    }
    Account sltAccount = accountMap.get(AccId);
    //既存の取引商談がなければ、新規する。
    //取引商談のレコードタイプIDを取得
    //String recordTypeId =RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
    String recordTypeId = '';
    String opportunityName = '';

    if(caseMap.containsKey(opp.CaseRef__c) && 
      caseMap.get(opp.CaseRef__c).RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','OsoshikiYoyaku_SiryoSeikyu_Web')){
      recordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Seizenkeiyaku');
      opportunityName = '_生前契約';
    }
    else{
      recordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
      opportunityName = '_取引商談';
    }

    map<string,object> ParamMap=new map<string,object>();
    ParamMap.put('AccountId',Accid);
    ParamMap.put('Name',sltAccount.Name + opportunityName);
    ParamMap.put('StageName','問合せ受付');
    ParamMap.put('RecordTypeId',recordTypeId);
    ParamMap.put('CloseDate',date.Today());
    ParamMap.put('Req_Day__c',opp.Req_Day__c);
    Opportunity rtnOpp=InsertOpportunity(ParamMap);


    return rtnOpp;
  }
    /**
   * 商談に登録
   * @param map<string,object> ParamMap　項目と値のマップ
   * @return 商談
   */  
  public Opportunity InsertOpportunity(map<string,object> ParamMap){
    system.debug('====================InsertOpportunity.begin===================');
    Opportunity opp  = new Opportunity();
    opp.AccountId=(id)ParamMap.get('AccountId');
    opp.Name=(string)ParamMap.get('Name');
    //取引商談
    opp.TorihikiShodanRef__c=(id)ParamMap.get('TorihikiShodanRef__c');
    //シンプル安豪
    opp.SimpleYasugoRef__c=(id)ParamMap.get('ServiceObjectId');
    //フェーズ
    opp.StageName=(string)ParamMap.get('StageName');
    //商談レコードタイプ
    opp.RecordTypeId=(id)ParamMap.get('RecordTypeId');
    //完了予定日
    opp.CloseDate=(date)ParamMap.get('CloseDate');
    //価格表
    opp.Pricebook2Id=(id)ParamMap.get('Pricebook2Id');
    //ケース
    opp.CaseRef__c=(id)ParamMap.get('CaseRef__c');
    //入口
    opp.Iriguchi__c=(string)ParamMap.get('Iriguchi__c');
    //対象者状況
    opp.TaishoushaJokyo__c=(string)ParamMap.get('TaishoushaJokyo__c');
    //issues3806--Start--
    //対象者居住状態（初回）
    opp.TaishoshaKyojuKeitai__c=(string)ParamMap.get('TaishoshaKyojuKeitai__c');
    //余命期間（初回）
    opp.TaishoshaYomeiKikan__c=(string)ParamMap.get('TaishoshaYomeiKikan__c');
    //問い合わせ起因者（初回）
    opp.ToiawaseKiinsha__c=(string)ParamMap.get('ToiawaseKiinsha__c');
    //対象者様のご状態（初回）決定フラグ
    if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')){
        opp.TaishoushaJokyoKeteiFlg__c = True;
    }
    //issues3806--End--
    
    //重要連絡事項
    opp.JuyoRenrakuJiko__c=(string)ParamMap.get('JuyoRenrakuJiko__c');
    // 資料請求有
    if( ParamMap.containsKey('SiryoSeikyoAri__c') ){
      opp.SiryoSeikyoAri__c=(Boolean)ParamMap.get('SiryoSeikyoAri__c');
    }
    opp.Req_Day__c  =(datetime)ParamMap.get('Req_Day__c');
    opp.SubPhase__c = (string)ParamMap.get('SubPhase__c');
    
    if( ParamMap.containsKey('ShiryoSoufuSakiCity__c') ){
      opp.ShiryoSoufuSakiCity__c = (string)ParamMap.get('ShiryoSoufuSakiCity__c'); // 資料送付先 市区郡
    }
    if( ParamMap.containsKey('ShiryoSoufuSakiPostalCode__c') ){
      opp.ShiryoSoufuSakiPostalCode__c = (string)ParamMap.get('ShiryoSoufuSakiPostalCode__c'); // 資料送付先 郵便番号
    }
    if( ParamMap.containsKey('ShiryoSoufuSakiState__c') ){
      opp.ShiryoSoufuSakiState__c = (string)ParamMap.get('ShiryoSoufuSakiState__c'); // 資料送付先 都道府県
    }
    if( ParamMap.containsKey('ShiryoSoufuSakiStreet__c') ){
      opp.ShiryoSoufuSakiStreet__c = (string)ParamMap.get('ShiryoSoufuSakiStreet__c'); // 資料送付先 町名番地
    }

    if( ParamMap.containsKey('ShiryoSoufuSakiMailAddress__c') ){
      opp.ShiryoSoufuSakiMailAddress__c = (string)ParamMap.get('ShiryoSoufuSakiMailAddress__c'); // 資料送付先 メールアドレス
    }
    if( ParamMap.containsKey('ShiryoSoufuSakiAtena__c') ){
      opp.ShiryoSoufuSakiAtena__c = (string)ParamMap.get('ShiryoSoufuSakiAtena__c'); // 資料送付 宛名
    }
    if( ParamMap.containsKey('ShiryoSoufuSakiAtenaKana__c') ){
      opp.ShiryoSoufuSakiAtenaKana__c = (string)ParamMap.get('ShiryoSoufuSakiAtenaKana__c'); // 資料送付先 宛名(カナ)
    }
    if( ParamMap.containsKey('ShiryoSoufuHoho__c') ){
      opp.ShiryoSoufuHoho__c = (string)ParamMap.get('ShiryoSoufuHoho__c'); // 資料送付先 宛名(カナ)
    }

    return opp;    
  }


  /** Ltvユニットの設定 */
  public void putLtvUnit(List<Opportunity> newList, Map<Id, Opportunity> oldMap){

    Map<Id, Opportunity> bestButsudanOppMap = new Map<Id, Opportunity>();
    for(Opportunity opp : newList){
         // ベスト仏壇
         if(!oldMap.get(opp.Id).IsWon && 
           opp.IsWon && 
           opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuButsudan')){
        opp.TaishosyaRef__c = opp.AccountId;
        bestButsudanOppMap.put(opp.AccountId, opp);
        }
      }

      if(!bestButsudanOppMap.isEmpty()){
        List<Account> targetAccounts = selectTargetAccount(bestButsudanOppMap.keySet());
           for(Account acc : targetAccounts){
          for(Opportunity opp : acc.Opportunities){
            if(opp.TaishoshaId__c != null && opp.Utiagebi__c != null){
              Opportunity newEitaiKuyoOpp = bestButsudanOppMap.get(opp.AccountId);
              newEitaiKuyoOpp.TaishosyaRef__c = opp.TaishoshaId__c;
              break;
            }
          }
        }
      }
  }

  /**
  * ・商談画面中央［流入経路］タブ内「ポスタルくらぶ会員番号」が
  * 　ブランクでない場合、同タブ内「流入経路（新規）」が 「ポスタルくらぶ」となるよう設定する
  * 
  * ・［流入経路］タブ内、「ベネフィット・ワン会員ID」が
  * 　ブランクでない場合に、「流入経路」につき「FD-ベネフィット・ワン」を自動で選択する仕様とする
   **/
  public void setIriguchi(List<Opportunity> newList, Map<Id, Opportunity> oldMap){
    Map<Id,Keiyaku__c> theKeiyakuIdMap = KeiyakuCachedDaos.getInstance().SelectAlliance();
    for(opportunity newData : newList){
      opportunity oldData = oldMap.get(newData.id);
      //ベネフィット・ワン会員ID  BenefitOneID__c
      if(theKeiyakuIdMap != null && 
        String.isNotBlank(newData.BenefitOneID__c) && 
        newData.BenefitOneID__c != oldData.BenefitOneID__c){

        for(Keiyaku__c theKeiyaku : theKeiyakuIdMap.values()){
          if(theKeiyaku.Name.contains('ベネフィット')){
            newData.AllianceRef__c = theKeiyaku.Id;
            break;
          }
        }
      }
      //ポスタルくらぶ会員番号
      if(theKeiyakuIdMap != null && 
        String.isNotBlank(newData.PostalClubKaiinBango__c) && 
        newData.PostalClubKaiinBango__c != oldData.PostalClubKaiinBango__c){

        for(Keiyaku__c theKeiyaku : theKeiyakuIdMap.values()){
          if(theKeiyaku.Name.contains('ポスタルくらぶ')){
            newData.AllianceRef__c = theKeiyaku.Id;
            break;
          }
        }
      }
    }
  }

  private List<Account> selectTargetAccount(Set<Id> accIds){

    List<Account> targetAccounts = [SELECT
                      Id,
                      (
                        SELECT
                          Id,
                          TaishosyaRef__c,
                          TaishoshaId__c,
                          RecordTypeId,
                          AccountId,
                          Utiagebi__c
                        FROM
                          Opportunities
                        Order By
                          Utiagebi__c
                      )
                    FROM
                      Account
                    WHERE
                        Id =:accIds
                    ];
    return targetAccounts;
  }

  private Account defaultAccount;
  private Account getDefaultAccount(){
    if(defaultAccount == null){
      defaultAccount = AccountDaos.GetInstance().GetDefualtAccount();
    }
    return defaultAccount;
  }

  /**
   * 取引先が変更される場合、履歴を記録する
   * @param List<Opportunity> newOpportunitys New商談
   * @param Map<ID, Opportunity> oldOpportunityMap Oｌｄ商談マップ
   * @return null
   */
  public void insertAccountChangedTask(List<Opportunity> newList, Map<ID, Opportunity> oldMap){
    
    List<AccountChangedTask__c> oppAccountChangeHistoryList = new List<AccountChangedTask__c>();
    for(Opportunity newOpportunity : newList){
      if(newOpportunity.AccountId != oldMap.get(newOpportunity.Id).AccountId 
        && !AccountChangedTaskProcessor.isProcessing){
            AccountChangedTask__c sobj = new AccountChangedTask__c();
            sobj.Opportunity__c = newOpportunity.Id;    // 商談
            sobj.OldAccount__c = oldMap.get(newOpportunity.Id).AccountId;    // 旧お客様・提携先
            sobj.NewAccount__c = newOpportunity.AccountId;    // お客様・提携先
            sobj.ShoriStatus__c = '未処理';
            oppAccountChangeHistoryList.add(sobj);
      }
    }
    insert oppAccountChangeHistoryList;
  }

}