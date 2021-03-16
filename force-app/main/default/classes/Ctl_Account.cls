public class Ctl_Account {

  public static void subscriveAccountBeforeInsert(List<Account> pNewOnes){
        for(Account aNewOne : pNewOnes){
      //生年月日 - 西暦和暦
            if( aNewOne.PersonBirthdate != null ){
                aNewOne.SeinengappiWareki__c = JpCalendar.convertSeirekiToWareki(aNewOne.PersonBirthdate);
            }
      if( !String.isBlank(aNewOne.SeinengappiWareki__c) && aNewOne.PersonBirthdate == null ){
        aNewOne.PersonBirthdate = JpCalendar.convertWarekiToSeireki(aNewOne.SeinengappiWareki__c);
      }
      //没年月日 - 西暦和暦
            if( aNewOne.PersonDeathDate__pc != null ){
                aNewOne.BotsunengappiWareki__c = JpCalendar.convertSeirekiToWareki(aNewOne.PersonDeathDate__pc);
            }
      if( !String.isBlank(aNewOne.BotsunengappiWareki__c) && aNewOne.PersonDeathDate__pc == null ){
        aNewOne.PersonDeathDate__pc = JpCalendar.convertWarekiToSeireki(aNewOne.BotsunengappiWareki__c);
      }
        }
  }

  public static void subscriveAccountBeforeUpdate(List<Account> pNewOnes, Map<Id, Account> pOldOnes){
    for(Account aNewOne : pNewOnes){
      Account aOldOne = pOldOnes.get(aNewOne.Id);

      //生年月日 - 西暦和暦
      if( aNewOne.SeinengappiWareki__c != aOldOne.SeinengappiWareki__c && aNewOne.PersonBirthdate == aOldOne.PersonBirthdate){ //和暦のみ変更した場合
        aNewOne.PersonBirthdate = String.isBlank(aNewOne.SeinengappiWareki__c) ? null : JpCalendar.convertWarekiToSeireki(aNewOne.SeinengappiWareki__c);
      } else if (aNewOne.PersonBirthdate != aOldOne.PersonBirthdate){
        aNewOne.SeinengappiWareki__c = aNewOne.PersonBirthdate == null ? null : JpCalendar.convertSeirekiToWareki(aNewOne.PersonBirthdate);
      }

      //没年月日 - 西暦和暦
      if( aNewOne.BotsunengappiWareki__c != aOldOne.BotsunengappiWareki__c && aNewOne.PersonDeathDate__pc == aOldOne.PersonDeathDate__pc){ //和暦のみ変更した場合
        aNewOne.PersonDeathDate__pc = String.isBlank(aNewOne.BotsunengappiWareki__c) ? null : JpCalendar.convertWarekiToSeireki(aNewOne.BotsunengappiWareki__c);
      } else if (aNewOne.PersonDeathDate__pc != aOldOne.PersonDeathDate__pc){
        aNewOne.BotsunengappiWareki__c = aNewOne.PersonDeathDate__pc == null ? null : JpCalendar.convertSeirekiToWareki(aNewOne.PersonDeathDate__pc);
      }
    }
  }

    public void initialProcessing(List<Account> newList, Map<ID, Account> oldMap){

        for(Account account : newList){
            // 生年月日をテキスト項目に設定(重複ルール用)
            if(account.PersonBirthdate != null && (oldMap == null || oldMap.get(account.Id).PersonBirthdate != account.PersonBirthdate)){
                    account.SeinengappiChofukuCheckyo__c = String.valueOf(account.PersonBirthdate);
            }

            // 没年月日をテキスト項目に設定(重複ルール用)
            if(account.PersonDeathDate__pc != null && (oldMap == null || oldMap.get(account.Id).PersonDeathDate__pc != account.PersonDeathDate__pc)){
                    account.BotsunengappiChofukuCheckyo__c = String.valueOf(account.PersonDeathDate__pc);
            }
                        
            //事前割メンバー化済の設定
            if (account.JizenwariMemberKa__c==true){
                account.MemberTourokuZumi__c=true;
            }       
            
        }
    }

    public List<Account> searchForExistenceOfAccount(List<Case> cases){

        List<Account> targetAccounts = createFromCaseToAccount(cases);

        if(!targetAccounts.isEmpty()){
            Map<Integer,List<Id>> accountInsertResultMap = checkDuplicateOfAccount(targetAccounts);
            associateCaseWithAccount(cases,accountInsertResultMap);
            copyCaseAddressToAccountAddress(cases);
        }

        return targetAccounts;
    }
    
    /**
     * ケースに入力した対象者情報より、Accountに対象者を追加
     * @param  newList 対象ケース(Update処理が入るため、再取得済)
     */     
    public void searchForExistenceTaishoshaOfAccount(List<Case> cases){
        //ケースの対象者情報より、取引先を作成
        List<Account> targetAccounts = createFromTaishoshaToAccount(cases);
        if(!targetAccounts.isEmpty()){
            Map<Integer,List<Id>> accountInsertResultMap = checkDuplicateOfAccount(targetAccounts);
            associateTaishoshaWithAccount(cases,accountInsertResultMap);
        }
    }

    private Boolean judgeCreateAccount(Case targetCase){
        if( String.isNotBlank(targetCase.FirstNameKana__c) &&
            String.isNotBlank(targetCase.LastNameKana__c)  &&
            (String.isNotBlank(targetCase.TelNo__c) || String.isNotBlank(targetCase.KeitaiDenwa__c) || String.isNotBlank(targetCase.MailAddress__c))
            ){return true;}

        return false;
    }

    @TestVisible
    private List<Account> createFromCaseToAccount(List<Case> targetCases){

        List<Account> insertTargetAccounts = new List<Account>();

        for(Case aCase : targetCases){
            if(judgeCreateAccount(aCase)){
                String mobilePhone;
                String phone;

                if(String.isNotBlank(aCase.TelNo__c)){
                    phone = aCase.TelNo__c.replaceAll('-','');
                }
                if(String.isNotBlank(aCase.KeitaiDenwa__c)){
                    mobilePhone = aCase.KeitaiDenwa__c.replaceAll('-','');
                }
            
                Account newAccount = new Account();
                
                if(aCase.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','affiliate')){
                    newAccount.recordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account', 'Customer');
                } else if(aCase.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','ObousanbinNetYoyaku')){
                    newAccount.recordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account', 'Customer');
                }
                
                newAccount.FirstName             = aCase.Firstname__c;
                newAccount.LastName              = aCase.Lastname__c;
                newAccount.FirstNameFurigana__pc = aCase.FirstNameKana__c;
                newAccount.LastNameFurigana__pc  = aCase.LastNameKana__c;
                newAccount.Phone                 = phone;
                newAccount.MobilePhone__c        = mobilePhone;
                newAccount.MailAddress__c        = aCase.MailAddress__c;
                newAccount.BillingPostalCode     = aCase.PostalCode__c;
                newAccount.BillingState          = aCase.State__c;
                newAccount.BillingCity           = aCase.City__c;
                newAccount.BillingStreet         = aCase.Street__c;
                newAccount.PersonBirthdate       = aCase.Seinengappi__c;
                newAccount.Syuha__c             = aCase.Shuha__c;
                newAccount.SonotanoSyukyoSyuha__c = aCase.SonotanoSyukyoSyuha__c;
                newAccount.Fax                    = aCase.FAX__c;
                if(aCase.TaishoshaBodaijinoUmu__c == '不明'){
                    newAccount.BodaijinoUmu__c       = '要確認';
                }
                else{
                    newAccount.BodaijinoUmu__c       = aCase.TaishoshaBodaijinoUmu__c;
                }
                newAccount.JuminhyouState__c     = aCase.TaishoshaJuminhyoState__c;
                newAccount.JuminhyouCity__c      = aCase.TaishoshaJuminhyoCity__c;

                if(aCase.PermissionFlag__c){
                    newAccount.PermissionFlag__pc      = '受け取る';
                }else{
                    newAccount.PermissionFlag__pc      = '受け取らない';
                }
                insertTargetAccounts.add(newAccount);               
            }
        }

        return insertTargetAccounts;
    }

    @TestVisible
    private List<Account> createFromTaishoshaToAccount(List<Case> targetCases){
        List<Account> insertTargetAccounts = new List<Account>();
        for (Case c:targetCases){
                //お坊さん便-ネット予約-Web受付
            if (c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','ObousanbinNetYoyaku')||
                //シンプル安豪事前準備Web受付
                c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoJizenJunbiWebForm')||
                //Umie申込Web受付
                c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','KaiyosankotsuMoshikomiWebForm')){
                    if (judgeCreateAccountFromTaishosha(c)){

                        String mobilePhone;
                        String phone;

                        if(String.isNotBlank(c.TaishoshaTelNo__c)){
                            phone = c.TaishoshaTelNo__c.replaceAll('-','');
                        }
                        if(String.isNotBlank(c.TaishoshaKeitaiDenwa__c)){
                            mobilePhone = c.TaishoshaKeitaiDenwa__c.replaceAll('-','');
                        }

                        Account Acc;
                        if(c.ZokugaraSodanshaNitottenoTaishosha__c == '本人'){
                            Acc = new Account(ID = c.AccountId);
                        }
                        else{
                            Acc = new Account();
                        }
                        //姓
                        Acc.LastName=c.TaishoshaSei__c;
                        //名
                        Acc.FirstName=c.TaishoshaMei__c;
                        //姓（カナ）
                        Acc.LastNameFurigana__pc=c.TaishoshaSeiFurigana__c;
                        //名(カナ)
                        Acc.FirstNameFurigana__pc=c.TaishoshaMeiFurigana__c;
                        //誕生日
                        if (c.TaishoshaSeinengappi__c!=null){
                            Acc.PersonBirthdate=c.TaishoshaSeinengappi__c;
                        }                       
                        //没年月日
                        if (c.TaishoushaBotsunengappi__c!=null){
                            Acc.PersonDeathDate__pc=c.TaishoushaBotsunengappi__c;
                        }
                        // 宗派
                        Acc.Syuha__c = c.Shuha__c;
                        // その他の宗旨・宗派
                        Acc.SonotanoSyukyoSyuha__c = c.SonotanoSyukyoSyuha__c;
                        // 菩提寺の有無
                        Acc.BodaijinoUmu__c = c.TaishoshaBodaijinoUmu__c;
                        Acc.Phone                 = phone;
                        Acc.MobilePhone__c        = mobilePhone;
                        Acc.BillingPostalCode     = c.TaishoshaZipCode__c;
                        Acc.BillingState          = c.TaishoshaState__c;
                        Acc.BillingCity           = c.TaishoshaCity__c;
                        Acc.BillingStreet         = c.TaishoshaStreet__c;
                        // 住民票都道府県
                        Acc.JuminhyouState__c = c.TaishoshaJuminhyoState__c;
                        // 住民票市区郡
                        Acc.JuminhyouCity__c = c.TaishoshaJuminhyoCity__c;
                        //レコードタイプ-=お客様
                        Acc.recordtypeid=RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer');   
                        insertTargetAccounts.add(Acc);     
                    }
                }       
        }
        
        return insertTargetAccounts;
    }
    private Boolean judgeCreateAccountFromTaishosha(Case targetCase){
        if( String.isNotBlank(targetCase.TaishoshaSeiFurigana__c) &&
            String.isNotBlank(targetCase.TaishoshaMeiFurigana__c) ){
                return true;
        }

        return false;
    }

    @TestVisible
    private Map<Integer,List<Id>> checkDuplicateOfAccount(List<Account> insertAccounts){

        List<Database.UpsertResult> results = Database.upsert(insertAccounts, false);
        
        Map<Integer,List<Id>> insertResultMap = new Map<Integer,List<Id>>();

        Integer caseIndex = 0;
        for(Database.UpsertResult result : results){

            caseIndex++;

            List<Id> duplicateIds = new List<id>();

            if(result.isSuccess()){
                System.debug('成功');
                duplicateIds.add(result.getId());
                insertResultMap.put(caseIndex,duplicateIds);
            }
            else{
                System.debug('失敗');
                Datacloud.DuplicateResult duplicateResult;
                List<Datacloud.MatchRecord> matchRecords;
             
                 
                for(Database.Error aError : result.getErrors()){
                    if(aError instanceof Database.DuplicateError){
                        duplicateResult = ((Database.DuplicateError)aError).getDuplicateResult();
                    }else{
                        throw new Exceptions.AnException( aError.getMessage() );
                    }
                }
                
                for(Datacloud.MatchResult duplicateMatchResult : duplicateResult.getMatchResults()) {
                    matchRecords = duplicateMatchResult.getMatchRecords();
                }
             
                for(Datacloud.MatchRecord duplicateMatchRecord : matchRecords) {
                    duplicateIds.add(duplicateMatchRecord.getRecord().Id);
                    
                    insertResultMap.put(caseIndex,duplicateIds);
                }
              
                system.debug('重複レコードID:' + duplicateIds);
            }           
        }
        System.debug('Ctl_Account.checkDuplicateOfAccount end');

        return insertResultMap;

    }


    private void associateCaseWithAccount(List<Case> targetCases, Map<Integer,List<Id>> accountInsertResultMap){
        Integer mapKeyIndex = 0;
        for(Case aCase : targetCases){

            mapKeyIndex++;
            List<Id> accountIds = accountInsertResultMap.get(mapKeyIndex);

            if(accountIds.size() == 1){
                aCase.AccountId = accountIds.get(0);
            }
            else if(accountIds.size() > 1){
                String duplicateIdUrl = '';
                // 重複ルールにひっかかる then 重複先が複数件ある then 既存取引先(重複先のいずれか　最初の一件)
                aCase.AccountId = accountIds.get(0);
                for(Id anAccountId : accountIds){
                    duplicateIdUrl += URL.getSalesforceBaseUrl().toExternalForm() + '/one/one.app?source=aloha#/alohaRedirect/' + anAccountId + '\r\n';
                }

                aCase.DuplicationCheckAccountUrl__c = duplicateIdUrl;
            }
        }
    }

    @TestVisible
    private void copyCaseAddressToAccountAddress(List<Case> targetCases){
        Account DefualtAcc=AccountDaos.GetInstance().GetDefualtAccount();
        map<id,Account> accMap = new map<id,Account>(); 
        set<id> accountIds=new set<id>();
        for (Case aCase : targetCases) {
            accountIds.add(aCase.AccountId);
        }
        
        if (accountIds.size()<1) return;
        for (Account acc:Dao_Account.getInstance().selectByIds(new List<id>(accountIds))) {
            accMap.put(acc.id,acc);         
        }
        list<Account> updateAccLst=new list<Account>();
        list<Case> updateCaseLst=new list<Case>();      

        for (Case aCase : targetCases){
            Account acc=accMap.get(aCase.AccountId);                
            if (acc==null || acc.id==DefualtAcc.id){
                continue;
            }
            Account updateAcc=new Account();
            updateAcc.id=acc.id;
            system.debug('**acc='+acc);
            if (acc.BillingPostalCode==null && acc.BillingState==null && acc.BillingCity==null && acc.BillingStreet==null){
                updateAcc.BillingPostalCode=aCase.PostalCode__c;
                updateAcc.BillingState=aCase.State__c;
                updateAcc.BillingCity=aCase.City__c;
                updateAcc.BillingStreet =aCase.Street__c;
                updateAccLst.add(updateAcc);
            }else{          
                if ((!equalStr(acc.BillingPostalCode,aCase.PostalCode__c))||
                    (!equalStr(acc.BillingState,aCase.State__c))||
                    (!equalStr(acc.BillingCity,aCase.City__c))||
                    (!equalStr(acc.BillingStreet,aCase.Street__c))){
                        aCase.AddressConfirmInfo__c='★住所は取引先の住所と異なりますので、ご確認ください。';          
                }
            }
        }
        update updateAccLst;        
    }

    @TestVisible
    private boolean equalStr(string A,string B){
        if ((string.isblank(A)) && (!string.isblank(B))) return false;
        if ((!string.isblank(A)) && (string.isblank(B))) return false;
        if (string.isblank(A) && string.isblank(B)) return true;  
        if (A.trim()==B.trim()){
             return true;
        }else{
             return false;
        }       
    }

    @TestVisible
    private void associateTaishoshaWithAccount(List<Case> targetCases, Map<Integer,List<Id>> accountInsertResultMap){
        Integer mapKeyIndex = 0;
        System.debug('accountInsertResultMap:' + accountInsertResultMap);
        for(Case aCase : targetCases){

            mapKeyIndex++;
            List<Id> accountIds = accountInsertResultMap.get(mapKeyIndex);

            if(accountIds.size() == 1){
                aCase.TaishoshaRef__c = accountIds.get(0);
            }           
        }
    }
    public class MemberTouroku {

        private IsNullAccountServices.IIsNullAccountService f_IIsNullAccountService = IsNullAccountServices.GetInstance();

        public void onCaseAfterInsert(List<Case> caseList){
            this.memberTouroku(caseList);
        }

        public void onCaseAfterUpdate(List<Case> caseList, Map<ID, Case> caseOldMap){
            this.memberTouroku( this.getCasesToProcess(caseList,caseOldMap) );
        }

        private List<Case> getCasesToProcess(List<Case> caseList, Map<ID, Case> caseOldMap){
            List<Case> theCases = new List<Case>();
            for(Case aCase : caseList){
                Case aOldOne = caseOldMap.get(aCase.Id);
                if(this.toProcess(aCase, aOldOne)) theCases.add(aCase);
            }
            return theCases;
        }
        private Boolean toProcess(Case pNewOne, Case pOldOne){
            if(pNewOne.MemberTourokuKibo__c != pOldOne.MemberTourokuKibo__c) return true;
            if(pNewOne.AccountId != pOldOne.AccountId) return true;
            return false;
        }

        private void memberTouroku(List<Case> caseList){
            List<Account> accountList = new List<Account>();

            for(Case aCase : caseList) {
                if(this.toMenberTouroku(aCase)) {
                    accountList.add(new Account(Id=aCase.AccountId, MemberTourokuZumi__c=true));
                }                
            }
            AccDml.updates(accountList, true);
        }

        private Boolean toMenberTouroku(Case pCase){
            if(f_IIsNullAccountService.isNullOrNullObj(pCase.AccountId)) return false;
            if(pCase.MemberTourokuKibo__c == '希望する') return true;
            return false;
        }
    }

    public void checkDuplicateAccountMerge(List<Account> accDelList) {  
        List<Id> accIds = SobjectsExtension.collectIds(accDelList);
        List<WebAccount__c> webAccountList = Dao_WebAccount.GetInstance().getWebAccountByAccountIds(accIds);
        List<WebAccountTourokuIrai__c> webAccountTourokuIraiList = Dao_WebAccountTourokuIrai.GetInstance().getWebAccountTourokuIraiListByAccountIds(accIds);
        List<Opportunity> closeOpportunityList = OpportunityDao.sltByAccountIdShoriStatusNotNull(accIds);

        Map<Id, WebAccount__c> webAccountMap = new Map<Id, WebAccount__c>();
        for(WebAccount__c webAccount : webAccountList){
            webAccountMap.put(webAccount.TorihikiSakiRef__c, webAccount);
        }

        Map<Id, List<WebAccountTourokuIrai__c>> iraisyoMap = new Map<Id, List<WebAccountTourokuIrai__c>>();
        for(WebAccountTourokuIrai__c iraisyo : webAccountTourokuIraiList){
            List<WebAccountTourokuIrai__c> iraiList = new List<WebAccountTourokuIrai__c>();
            if(iraisyoMap.containskey(iraisyo.TorihikiSakiRef__c)){
                iraiList = iraisyoMap.get(iraisyo.TorihikiSakiRef__c);
            }
            iraiList.add(iraisyo);
            iraisyoMap.put(iraisyo.TorihikiSakiRef__c, iraiList);
        }

        Map<Id, Opportunity> closeOpportunityMap = new Map<Id, Opportunity>();
        for(Opportunity closeOpportunity : closeOpportunityList){
            if(!closeOpportunityMap.containsKey(closeOpportunity.AccountId)){
                closeOpportunityMap.put(closeOpportunity.AccountId, closeOpportunity);
            }
        }

        for(Account acc: accDelList){
           if(webAccountMap.containsKey(acc.Id)){
                acc.addError('Webアカウント登録のある取引先は削除できません。' + webAccountMap.get(acc.Id).Name);
            }       
            else if(iraisyoMap.containsKey(acc.Id)){
                for(WebAccountTourokuIrai__c tempWebAccTorokuIrai : iraisyoMap.get(acc.Id)){
                    if((tempWebAccTorokuIrai.ShoriStatus__c == 'Processing_Created' || 
                        tempWebAccTorokuIrai.ShoriStatus__c == 'Processing_Validated' || 
                        tempWebAccTorokuIrai.ShoriStatus__c == 'Processing_WebAccountRequested' || 
                        tempWebAccTorokuIrai.ShoriStatus__c == 'Processing_WebAccountProcessed') &&
                        tempWebAccTorokuIrai.CreatedDate >= Datetime.now().addHours(-26)){
                        acc.addError('Webアカウント登録依頼中の取引先は削除できません。' + tempWebAccTorokuIrai.Name);
                        break;
                    }
                }
            }
            else if(closeOpportunityMap.containsKey(acc.Id)){
                acc.addError('コア連携済みの商談があるため削除できません。' + closeOpportunityMap.get(acc.Id).ShodanBangoF__c);
            }
        }
    }

    public void copyContact(List<Account> newAccountList, Map<ID, Account> oldAccountMap){

        List<String> leadNumber = new List<String>();
        for(Account newAccount : newAccountList){
            if(newAccount.LeadNumber__c != null && newAccount.LeadNumber__c != ''){
                leadNumber.add(newAccount.LeadNumber__c);
            }
        }

        Map<String, Boolean> leadNumberMap = new Map<String, Boolean>();
        if(leadNumber.size() > 0){
            for(Lead sltLead : [select Id, IsConverted, LeadNumber__c, RecordTypeId from Lead where LeadNumber__c = :leadNumber]){
                if(sltLead.LeadNumber__c != null && sltLead.LeadNumber__c != ''){
                    leadNumberMap.put(sltLead.LeadNumber__c, sltLead.IsConverted);
                }
            }
        }

        ID rtSoryoAccountId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId();
        ID rtTeikeisakiSoryoId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Teikeisaki_Soryo').getRecordTypeId();
        Map<ID, Account> accountIdMap = new Map<ID, Account>();
        List<Contact> upsertContactList = new List<Contact>();
        for(Account newAccount : newAccountList){
            if(newAccount.RecordTypeId == rtSoryoAccountId){
                if(oldAccountMap == null && !leadNumberMap.containsKey(newAccount.LeadNumber__c)){
                    Contact insCountact = new Contact();
                    String accountName = newAccount.Name;
                    Integer nameIndex = accountName.indexOf(' ');
                    if(nameIndex < 0){
                        insCountact.LastName = accountName;
                    }
                    else{
                        insCountact.LastName = accountName.substring(0, nameIndex);
                        insCountact.FirstName = accountName.substring(nameIndex);
                    }
                    insCountact.Email = newAccount.MailAddress__c;
                    insCountact.LastNameFurigana__c = newAccount.SeiKana__c;
                    insCountact.FirstNameFurigana__c = newAccount.MeiKana__c;
                    insCountact.Phone = newAccount.Phone;
                    insCountact.MobilePhone = newAccount.MobilePhone__c;
                    insCountact.AccountId = newAccount.Id;
                    insCountact.RecordTypeId = rtTeikeisakiSoryoId;
                    upsertContactList.add(insCountact);
                }
                else if(oldAccountMap != null){
                    Account oldAccount = oldAccountMap.get(newAccount.Id);
                    if(newAccount.Name != oldAccount.Name || 
                        newAccount.MailAddress__c != oldAccount.MailAddress__c || 
                        newAccount.SeiKana__c != oldAccount.SeiKana__c || 
                        newAccount.MeiKana__c != oldAccount.MeiKana__c || 
                        newAccount.Phone != oldAccount.Phone || 
                        newAccount.MobilePhone__c != oldAccount.MobilePhone__c){
                        accountIdMap.put(newAccount.Id, newAccount);
                    }
                }
            }
        }

        for(Contact sltContact : Dao_Contact.getContactListByAccountIdList(accountIdMap.keySet())){
            Account tempAccount = accountIdMap.get(sltContact.AccountId);
            String accountName = tempAccount.Name;
            Integer nameIndex = accountName.indexOf(' ');
            if(nameIndex > 0){
                sltContact.LastName = accountName.substring(0, nameIndex);
                sltContact.FirstName = accountName.substring(nameIndex);
            }
            sltContact.Email = tempAccount.MailAddress__c;
            sltContact.LastNameFurigana__c = tempAccount.SeiKana__c;
            sltContact.FirstNameFurigana__c = tempAccount.MeiKana__c;
            sltContact.Phone = tempAccount.Phone;
            sltContact.MobilePhone = tempAccount.MobilePhone__c;
            upsertContactList.add(sltContact);
        }
        
        upsert upsertContactList;
    }

    public void changeKeiyakuName(List<Account> newAccountList, Map<ID, Account> oldAccountMap){

        ID rtSoryoAccountId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId();
        ID rtJiinId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Jiin').getRecordTypeId();
        ID rtSogisyaId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId();
        Set<ID> accountIdList = new Set<ID>();
        for(Account newAccount : newAccountList){
            if((newAccount.RecordTypeId == rtSoryoAccountId || 
                newAccount.RecordTypeId == rtJiinId ||
                newAccount.RecordTypeId == rtSogisyaId) &&
                newAccount.Name != oldAccountMap.get(newAccount.Id).Name){
                accountIdList.add(newAccount.Id);
            }
        }
        
        if(accountIdList.size() > 0){
            List<Keiyaku__c> updateKeiyakuList = new List<Keiyaku__c>();
            for(Account sltAccount : Dao_Account.getAccountKeiyakuListByAccountId(accountIdList)){
                for(Keiyaku__c sltKeiyaku : sltAccount.KeiyakusTeikeisaki__r){
                    updateKeiyakuList.add(new Keiyaku__c(Id=sltKeiyaku.Id,Name=sltAccount.Name + '_' + sltKeiyaku.RecordType.Name + '契約'));
                }
            }
            update updateKeiyakuList;
        }
    }

    public static void formatBillingPostalCode(List<Account> newAccountList,Map<ID, Account> oldAccountMap){
        for(Account newAccount : newAccountList){
            if(String.isNotBlank(newAccount.BillingPostalCode) &&
            (oldAccountMap == null || newAccount.BillingPostalCode != oldAccountMap.get(newAccount.Id).BillingPostalCode)){
                newAccount.BillingPostalCode = convertToHankaku(newAccount.BillingPostalCode);
                newAccount.BillingPostalCode = plusHihunPostalCode(newAccount.BillingPostalCode);         
            }
            if(String.isNotBlank(newAccount.SeikyuSakiAddrPostalCode__c) &&
            (oldAccountMap == null || newAccount.SeikyuSakiAddrPostalCode__c != oldAccountMap.get(newAccount.Id).SeikyuSakiAddrPostalCode__c)){
                newAccount.SeikyuSakiAddrPostalCode__c = convertToHankaku(newAccount.SeikyuSakiAddrPostalCode__c);
                newAccount.SeikyuSakiAddrPostalCode__c = plusHihunPostalCode(newAccount.SeikyuSakiAddrPostalCode__c);         
            }
        }
    }

    @TestVisible
    private static String convertToHankaku(String postalCode){
        postalCode = postalCode.replace('〒','');
        postalCode = Com_Utility.HankakuReplace(postalCode);
        return postalCode;
    }

    @TestVisible
    private static String plusHihunPostalCode(String postalCode){
        Pattern haihunnashi = Pattern.compile('^[0-9]{7}');
        Matcher matcherHaihunnashi = haihunnashi.matcher(postalCode);
        if(matcherHaihunnashi.matches()){
            postalCode = postalCode.left(3) + '-' + postalCode.right(4);
        }
        return postalCode;
    }

}