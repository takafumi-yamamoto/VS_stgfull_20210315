/**
僧侶手配依頼書
*/
public class SogSok_SrthIraiSho_Torikoming {

    public void subscriveOnSogSokSrthIraiShoTorikBeforeUpdated(List<SogSok_SrthIraiSho_Torik__c> pNewOnes, Map<ID, SogSok_SrthIraiSho_Torik__c> pNewMap, Map<ID, SogSok_SrthIraiSho_Torik__c> pOldOnes){
        this.buildSyoudan(
            this.reloadData(
                this.getProcessData(pNewOnes, pOldOnes)),
                pNewMap
            );
    }

    private List<SogSok_SrthIraiSho_Torik__c> getProcessData(List<SogSok_SrthIraiSho_Torik__c> pNewOnes, Map<ID, SogSok_SrthIraiSho_Torik__c> pOldOnes){
        List<SogSok_SrthIraiSho_Torik__c> processData = new List<SogSok_SrthIraiSho_Torik__c>();
        for(SogSok_SrthIraiSho_Torik__c pOne : pNewOnes){
            if(pOldOnes.containskey(pOne.Id)){
                SogSok_SrthIraiSho_Torik__c pOldOne = pOldOnes.get(pOne.Id);
                if(pOne.Status__c != pOldOne.Status__c && pOne.Status__c == '取込'){
                    if(String.isBlank(pOne.syop_Ref__c)){
                        pOne.addError('商談を登録してください; '); 
                        continue;
                    }
                    if(String.isBlank(pOne.obop_SoudanshaRef__c)){
                        pOne.addError('相談者を登録してください; '); 
                        continue;
                    }
                    if(String.isBlank(pOne.obop_TaishoShaRef__c)){
                        pOne.addError('対象者を登録してください; '); 
                        continue;
                    }
                    if(String.isBlank(pOne.obop_SougishaRef__c)){
                        pOne.addError('葬儀社を登録してください; '); 
                        continue;
                    }
                    processData.add(pOne);
                }
            }
        }
        return processData;
    }

    private List<SogSok_SrthIraiSho_Torik__c> reloadData(List<SogSok_SrthIraiSho_Torik__c> processData){
        return [SELECT 
                        Id ,
                        Name ,
                        syop_Ref__c ,
                        obop_SoudanshaRef__c ,
                        obop_Soudansha_Sei__c ,
                        obop_Soudansha_Mei__c ,
                        obop_TaishoShaRef__c ,
                        obop_TaishoSha_Sei__c ,
                        obop_TaishoSha_Mei__c ,
                        obop_TaishoSha_BirthDate__c ,
                        obop_TaishoSha_DeathDate__c ,
                        obop_TaishoSha_Age__c ,
                        obop_TaishoSha_Shuha_SonotaShuha__c ,
                        obop_MoshuRef__c ,
                        obop_Moshu_Sei__c ,
                        obop_Moshu_Mei__c ,
                        obop_Moshu_SeiKana__c ,
                        obop_Moshu_MeiKana__c ,
                        obop_Moshu_Phone__c ,
                        obop_Moshu_Mobile__c ,
                        obop_Moshu_Addr_PostalCode__c ,
                        obop_Moshu_Addr_State__c ,
                        obop_Moshu_Addr_City__c ,
                        obop_Moshu_Addr_Street__c ,
                        obop_SougishaRef__c ,
                        obop_SogiTantoName__c ,
                        obop_SogiTantoTel__c ,
                        obop_SogiTantoFax__c ,
                        obop_TsuyaDateTime__c ,
                        obop_KokubetsuDateTime__c ,
                        obop_KasoDateTime__c ,
                        obop_SaijoName__c ,
                        obop_SaijoAddress__c ,
                        obop_SaijoPhone__c ,
                        obop_KasobaName__c ,
                        obop_KaimyoKiboUmu__c ,
                        obop_RenrakuJiko__c ,
                        obop_RyunyuMotoService__c ,
                        SogSok_SrthIraiShoRef__c ,
                        Status__c ,
                        obop_ObouPlan__c ,
                        obop_Kaimyo__c ,
                        obop_TaishoSha_Shuha__c ,
                        obop_TaishoSha_Bodaiji_Umu__c ,
                        obop_TaishoShaZokugaraFromMoshu__c ,
                        obop_Shonanoka__c,
                        obop_ToiawaseDate__c,
                        obop_StageName__c,
                        obop_SubPhase__c,
                        (
                            SELECT 
                                    Id ,
                                    Name ,
                                    SogSok_SrthIraiSho_TorikRef__c ,
                                    ShohinRef__c,
                                    ShohinRef__r.Name,
                                    ShohinRef__r.ShohinBango__c,
                                    ShohinRef__r.Id
                             FROM SogSok_SrthIraiSho_TorikShohins__r
                        )
                 FROM SogSok_SrthIraiSho_Torik__c
                 Where id = :processData
                 ];
    }

    private Map<Id, Account> getAccountMap(List<SogSok_SrthIraiSho_Torik__c> processData){
        Set<Id> accIds = new Set<Id>();
        for(SogSok_SrthIraiSho_Torik__c toriki : processData){
            if(toriki.obop_SoudanshaRef__c != null){
                accIds.add(toriki.obop_SoudanshaRef__c);
            }
        }
        return new Map<Id, Account>([Select Id, name from Account where id = :accIds]);
    }

    private void buildSyoudan(List<SogSok_SrthIraiSho_Torik__c> processData, Map<ID, SogSok_SrthIraiSho_Torik__c> pNewMap){


        Map<Id, Account> accMap = this.getAccountMap(processData);
        Map<Id, Opportunity> simpleOppMap = this.getSimpleOppMap(processData);

        ObosanBuilder builder = new ObosanBuilder();
        for(SogSok_SrthIraiSho_Torik__c toriki : processData){
            String oppName = toriki.obop_SoudanshaRef__c != null && accMap.containskey(toriki.obop_SoudanshaRef__c) ? accMap.get(toriki.obop_SoudanshaRef__c).Name + '_お坊さん便' : '新規_お坊さん便';
            String recordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin');
            builder.add(
                        toriki,
                        new Opportunity(
                            Name = oppName,
                            RecordTypeId = recordTypeId,
                            StageName = String.isNotBlank(toriki.obop_StageName__c) ? toriki.obop_StageName__c : '問合せ受付',
                            Req_Day__c = toriki.obop_ToiawaseDate__c,
                            SubPhase__c = toriki.obop_SubPhase__c,
                            JuyoRenrakuJiko__c = toriki.obop_RenrakuJiko__c,
                            RyunyumotoService__c = toriki.obop_RyunyuMotoService__c,
                            Pricebook2Id = getStdPricebook2Id(),
                            CloseDate = date.Today(),
                            AccountId = toriki.obop_SoudanshaRef__c,
                            TaishosyaRef__c = toriki.obop_TaishoShaRef__c,
                            MosyuRef__c = toriki.obop_MoshuRef__c
                        )
                );
        }

        builder.saveAll();
        update_obop_Ref(builder.oppMap, pNewMap);


        Map<Id, SObject> sobjMapForUpdate = new Map<Id, SObject>();

        List<Id> simpleIdList = new List<Id>();
        List<Account> accMoshuList = new List<Account>();
        String juryoShoId = '';
        String oboId = '';
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        String strText = '今回、発生した変更内容は以下のとおりです。' + '\r\n' + '\r\n';
        Boolean mailFlg = false;
        String jushinPlanShohinBango = '';
        String jushinPlanShohinName = '';

        for(SogSok_SrthIraiSho_Torik__c toriki : processData){

            juryoShoId = toriki.SogSok_SrthIraiShoRef__c;

            Opportunity theOpp = simpleOppMap.get(toriki.syop_Ref__c);

            strText = '〇商談データ' + '\r\n' + 
                        baseUrl + 'lightning/r/Opportunity/' + theOpp.Id + '/view' + '\r\n' + 
                        '\r\n';

            SimpleYasugo__c upSimpleYasugo = new SimpleYasugo__c(Id=theOpp.SimpleYasugoRef__c, SoryoTehaiIraishoJuryobi__c=toriki.obop_ToiawaseDate__c);
            sobjMapForUpdate.put(upSimpleYasugo.Id, upSimpleYasugo);

            //喪主
            Account accMoshu = new Account();
            accMoshu.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();

            //喪主
            if(theOpp.SimpleYasugoRef__r.MoshuRef__r.LastName != toriki.obop_Moshu_Sei__c || 
                theOpp.SimpleYasugoRef__r.MoshuRef__r.FirstName != toriki.obop_Moshu_Mei__c || 
                theOpp.SimpleYasugoRef__r.MoshuRef__r.FirstNameFurigana__pc != toriki.obop_Moshu_MeiKana__c || 
                theOpp.SimpleYasugoRef__r.MoshuRef__r.LastNameFurigana__pc != toriki.obop_Moshu_SeiKana__c || 
                theOpp.SimpleYasugoRef__r.MoshuRef__r.BillingCity != toriki.obop_Moshu_Addr_City__c || 
                theOpp.SimpleYasugoRef__r.MoshuRef__r.BillingPostalCode != toriki.obop_Moshu_Addr_PostalCode__c || 
                theOpp.SimpleYasugoRef__r.MoshuRef__r.BillingState != toriki.obop_Moshu_Addr_State__c || 
                theOpp.SimpleYasugoRef__r.MoshuRef__r.BillingStreet != toriki.obop_Moshu_Addr_Street__c || 
                theOpp.SimpleYasugoRef__r.MoshuRef__r.Phone != toriki.obop_Moshu_Phone__c || 
                theOpp.SimpleYasugoRef__r.MoshuRef__r.MobilePhone__c != toriki.obop_Moshu_Mobile__c){

                accMoshu.LastName = toriki.obop_Moshu_Sei__c;
                accMoshu.FirstName = toriki.obop_Moshu_Mei__c;
                accMoshu.FirstNameFurigana__pc = toriki.obop_Moshu_MeiKana__c;
                accMoshu.LastNameFurigana__pc = toriki.obop_Moshu_SeiKana__c;
                accMoshu.BillingCity = toriki.obop_Moshu_Addr_City__c;
                accMoshu.BillingPostalCode = toriki.obop_Moshu_Addr_PostalCode__c;
                accMoshu.BillingState = toriki.obop_Moshu_Addr_State__c;
                accMoshu.BillingStreet = toriki.obop_Moshu_Addr_Street__c;
                accMoshu.Phone = toriki.obop_Moshu_Phone__c;
                accMoshu.MobilePhone__c = toriki.obop_Moshu_Mobile__c;
                simpleIdList.add(theOpp.SimpleYasugoRef__c);
                accMoshuList.add(accMoshu);
            }
            
            //対象者
            if(String.isNotBlank(toriki.obop_TaishoShaRef__c)){
                Account acc = sobjMapForUpdate.containskey(toriki.obop_TaishoShaRef__c) ? (Account)sobjMapForUpdate.get(toriki.obop_TaishoShaRef__c) : new Account(Id=toriki.obop_TaishoShaRef__c);
                Boolean isChanged = false;
                if(String.isNotBlank(toriki.obop_TaishoSha_Sei__c)){
                    acc.LastName = toriki.obop_TaishoSha_Sei__c;
                    isChanged = true;
                }
                if(String.isNotBlank(toriki.obop_TaishoSha_Mei__c)){
                    acc.FirstName = toriki.obop_TaishoSha_Mei__c;
                    isChanged = true;
                }
                if(toriki.obop_TaishoSha_BirthDate__c != null){
                    acc.PersonBirthdate = toriki.obop_TaishoSha_BirthDate__c;
                    isChanged = true;
                }
                if(toriki.obop_TaishoSha_DeathDate__c != null){
                    acc.PersonDeathDate__pc = toriki.obop_TaishoSha_DeathDate__c;
                    isChanged = true;
                }
                if(toriki.obop_TaishoSha_Age__c != null){
                    acc.ManNenrei__c = toriki.obop_TaishoSha_Age__c;
                    isChanged = true;
                }
                if(String.isNotBlank(toriki.obop_TaishoSha_Shuha__c)){
                    acc.Syuha__c = toriki.obop_TaishoSha_Shuha__c;
                    isChanged = true;
                }
                if(String.isNotBlank(toriki.obop_TaishoSha_Shuha_SonotaShuha__c)){
                    acc.SonotanoSyukyoSyuha__c = toriki.obop_TaishoSha_Shuha_SonotaShuha__c;
                    isChanged = true;
                }
                if(String.isNotBlank(toriki.obop_TaishoSha_Bodaiji_Umu__c)){
                    acc.BodaijinoUmu__c = toriki.obop_TaishoSha_Bodaiji_Umu__c;
                    isChanged = true;
                }
                if(isChanged) sobjMapForUpdate.put(toriki.obop_TaishoShaRef__c, acc);
            }

            //相談者
            if(String.isNotBlank(toriki.obop_SoudanshaRef__c)){
                Account acc = sobjMapForUpdate.containskey(toriki.obop_SoudanshaRef__c) ? (Account)sobjMapForUpdate.get(toriki.obop_SoudanshaRef__c) : new Account(Id=toriki.obop_SoudanshaRef__c);
                Boolean isChanged = false;
                if(String.isNotBlank(toriki.obop_Soudansha_Sei__c)){
                    acc.LastName = toriki.obop_Soudansha_Sei__c;
                    isChanged = true;
                }
                if(String.isNotBlank(toriki.obop_Soudansha_Mei__c)){
                    acc.FirstName = toriki.obop_Soudansha_Mei__c;
                    isChanged = true;
                }
                if(isChanged) sobjMapForUpdate.put(toriki.obop_SoudanshaRef__c, acc);
            }

            oboId = builder.getOboId(toriki.Id);
            if(String.isNotBlank(oboId)){
                Obosanbin__c obosan = sobjMapForUpdate.containskey(oboId) ? (Obosanbin__c)sobjMapForUpdate.get(oboId) : new Obosanbin__c(Id=oboId);
                if(String.isNotBlank(toriki.obop_TaishoShaRef__c)){
                    obosan.Taishosha1Ref__c = toriki.obop_TaishoShaRef__c;
                }
                /*if(String.isNotBlank(toriki.obop_MoshuRef__c)){
                    obosan.MoshuRef__c = toriki.obop_MoshuRef__c;
                }*/

                //お坊さん便プラン
                if(String.isNotBlank(toriki.obop_ObouPlan__c)){
                    obosan.MemorialServicePlan__c = toriki.obop_ObouPlan__c;
                }
                if(String.isNotBlank(toriki.obop_KaimyoKiboUmu__c)){
                    obosan.Kaimyojuyo__c = toriki.obop_KaimyoKiboUmu__c;
                }
                if(String.isNotBlank(toriki.obop_Kaimyo__c)){
                    obosan.Kaimyo__c = toriki.obop_Kaimyo__c;
                }

                //葬儀
                if(toriki.obop_TsuyaDateTime__c != null){
                    obosan.TsuyaDateTime_Inp__c = toriki.obop_TsuyaDateTime__c;
                }
                if(toriki.obop_KokubetsuDateTime__c != null){
                    obosan.KokubetsushikiNichiji__c = toriki.obop_KokubetsuDateTime__c;
                }
                if(toriki.obop_KasoDateTime__c != null){
                    obosan.KasoDateTime_Inp__c = toriki.obop_KasoDateTime__c;
                }
                if(String.isNotBlank(toriki.obop_Shonanoka__c)){
                    obosan.Shonanoka__c = toriki.obop_Shonanoka__c;
                }
                if(String.isNotBlank(toriki.obop_SaijoName__c)){
                    obosan.Saijo__c = toriki.obop_SaijoName__c;
                }
                if(String.isNotBlank(toriki.obop_SaijoPhone__c)){
                    obosan.SaijoPhone__c = toriki.obop_SaijoPhone__c;
                }
                if(String.isNotBlank(toriki.obop_SaijoAddress__c)){
                    obosan.SaijoAddress__c = toriki.obop_SaijoAddress__c;
                }
                if(String.isNotBlank(toriki.obop_KasobaName__c)){
                    obosan.Kasoba__c = toriki.obop_KasobaName__c;
                }

                //葬儀社
                //葬儀社Ref
                if(String.isNotBlank(toriki.obop_SougishaRef__c)){
                    obosan.Sogisha__c = toriki.obop_SougishaRef__c;
                }
                if(String.isNotBlank(toriki.obop_SogiTantoName__c)){
                    obosan.SogiTantosha__c = toriki.obop_SogiTantoName__c;
                }
                if(String.isNotBlank(toriki.obop_SogiTantoTel__c)){
                    obosan.SogiTantoshaTel__c = toriki.obop_SogiTantoTel__c;
                }
                if(String.isNotBlank(toriki.obop_SogiTantoFax__c)){
                    obosan.SogiTantoshaFax__c = toriki.obop_SogiTantoFax__c;
                }
     
                if(String.isNotBlank(toriki.obop_TaishoShaZokugaraFromMoshu__c)){
                    obosan.ZokugaraMoshuNitottenoTaishosha1__c = toriki.obop_TaishoShaZokugaraFromMoshu__c; //続柄：喪主にとっての対象者1
                }
                sobjMapForUpdate.put(oboId, obosan);
            }

        }

        if(simpleIdList.size() > 0){
            List<Database.SaveResult> srList = Database.insert(accMoshuList, false);
            List<SimpleYasugo__c> upSimpleYasugoList = new List<SimpleYasugo__c>();
            List<Account> upAccountList = new List<Account>();

            strText += '≪喪主≫' + '\r\n';
            String strBefAcc = '■受信した書類で喪主に指定されたお客様の情報' + '\r\n' + '[更新前]' + '\r\n';
            String strAftAcc = '[更新後]' + '\r\n';

            for(Database.SaveResult sr : srList){
                if (sr.isSuccess()) {
                    SimpleYasugo__c simple = sobjMapForUpdate.containskey(simpleIdList.get(0)) ? (SimpleYasugo__c)sobjMapForUpdate.get(simpleIdList.get(0)) : new SimpleYasugo__c(Id = simpleIdList.get(0));
                    simple.MoshuRef__c=sr.getId();
                    sobjMapForUpdate.put(simpleIdList.get(0), simple);
                    Obosanbin__c obosanbin = sobjMapForUpdate.containskey(oboId) ? (Obosanbin__c)sobjMapForUpdate.get(oboId) : new Obosanbin__c(Id = oboId);
                    obosanbin.MoshuRef__c=sr.getId();
                    sobjMapForUpdate.put(oboId, obosanbin);

                    strText += '・喪主の変更がありました' + '\r\n' + 
                                '→誤った喪主の指定がされていないか確認してください。' + '\r\n' + 
                                '\r\n';

                    strBefAcc += '空欄' + '\r\n';

                    Account tempAcc = accMoshuList.get(0);
                    if(String.isNotBlank(tempAcc.LastName)){
                        strAftAcc += '姓：' + Utility_Common.str(tempAcc.LastName) + '\r\n';
                    }
                    if(String.isNotBlank(tempAcc.FirstName)){
                        strAftAcc += '名：' + Utility_Common.str(tempAcc.FirstName) + '\r\n';
                    }
                    if(String.isNotBlank(tempAcc.LastNameFurigana__pc)){
                        strAftAcc += 'セイ：' + Utility_Common.str(tempAcc.LastNameFurigana__pc) + '\r\n';
                    }
                    if(String.isNotBlank(tempAcc.FirstNameFurigana__pc)){
                        strAftAcc += 'メイ：' + Utility_Common.str(tempAcc.FirstNameFurigana__pc) + '\r\n';
                    }
                    if(String.isNotBlank(tempAcc.BillingPostalCode)){
                        strAftAcc += '郵便番号：' + Utility_Common.str(tempAcc.BillingPostalCode) + '\r\n';
                    }
                    if(String.isNotBlank(tempAcc.BillingState)){
                        strAftAcc += '都道府県：' + Utility_Common.str(tempAcc.BillingState) + '\r\n';
                    }
                    if(String.isNotBlank(tempAcc.BillingCity)){
                        strAftAcc += '市区郡：' + Utility_Common.str(tempAcc.BillingCity) + '\r\n';
                    }
                    if(String.isNotBlank(tempAcc.BillingStreet)){
                        strAftAcc += '町名・番地：' + Utility_Common.str(tempAcc.BillingStreet) + '\r\n';
                    }
                    if(String.isNotBlank(tempAcc.Gender__pc)){
                        strAftAcc += '性別：' + Utility_Common.str(tempAcc.Gender__pc) + '\r\n';
                    }
                    if(tempAcc.PersonBirthdate != null){
                        strAftAcc += '生年月日：' + tempAcc.PersonBirthdate.format() + '\r\n';
                    }
                    if(String.isNotBlank(tempAcc.MobilePhone__c)){
                        strAftAcc += '携帯：' + Utility_Common.str(tempAcc.MobilePhone__c) + '\r\n';
                    }
                    if(String.isNotBlank(tempAcc.Phone)){
                        strAftAcc += '電話：' + Utility_Common.str(tempAcc.Phone) + '\r\n';
                    }

                    strText += strBefAcc + 
                                '\r\n' + 
                                strAftAcc;
                }
                else{
                    for (Database.Error error : sr.getErrors()) {
                        if (error instanceof Database.DuplicateError) {
                            Database.DuplicateError duplicateError = (Database.DuplicateError)error;
                            Datacloud.DuplicateResult duplicateResult =  duplicateError.getDuplicateResult();
                            Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                            Datacloud.MatchResult matchResult = matchResults[0];
                            Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                            List<String> matchRecordIdList = new List<String>();
                            for (Datacloud.MatchRecord matchRecord : matchRecords) {
                                matchRecordIdList.add(matchRecord.getRecord().Id);
                            }
                            ID accId = matchRecords[0].getRecord().Id;
                            SimpleYasugo__c simple = sobjMapForUpdate.containskey(simpleIdList.get(0)) ? (SimpleYasugo__c)sobjMapForUpdate.get(simpleIdList.get(0)) : new SimpleYasugo__c(Id = simpleIdList.get(0));
                            simple.MoshuRef__c=accId;
                            sobjMapForUpdate.put(simpleIdList.get(0), simple);

                            Obosanbin__c obosanbin = sobjMapForUpdate.containskey(oboId) ? (Obosanbin__c)sobjMapForUpdate.get(oboId) : new Obosanbin__c(Id = oboId);
                            obosanbin.MoshuRef__c=sr.getId();
                            sobjMapForUpdate.put(oboId, obosanbin);

                            Account tempAcc = accMoshuList.get(0);
                            tempAcc.Id = accId;

                            // 1件ずつしかこないため
                            Account dupAccount = [select Id, LastName, FirstName, FirstNameFurigana__pc, LastNameFurigana__pc, PersonBirthdate, BillingCity, BillingPostalCode, BillingState, BillingStreet, Gender__pc, Phone, MobilePhone__c from Account where Id = :accId];

                            if(tempAcc.LastName != dupAccount.LastName){
                                strAftAcc += '姓：' + Utility_Common.str(tempAcc.LastName) + '\r\n';
                                strBefAcc += '姓：' + Utility_Common.str(dupAccount.LastName) + '\r\n';
                            }
                            if(tempAcc.FirstName != dupAccount.FirstName){
                                strAftAcc += '名：' + Utility_Common.str(tempAcc.FirstName) + '\r\n';
                                strBefAcc += '名：' + Utility_Common.str(dupAccount.FirstName) + '\r\n';
                            }
                            if(tempAcc.LastNameFurigana__pc != dupAccount.LastNameFurigana__pc){
                                strAftAcc += 'セイ：' + Utility_Common.str(tempAcc.LastNameFurigana__pc) + '\r\n';
                                strBefAcc += 'セイ：' + Utility_Common.str(dupAccount.LastNameFurigana__pc) + '\r\n';
                            }
                            if(tempAcc.FirstNameFurigana__pc != dupAccount.FirstNameFurigana__pc){
                                strAftAcc += 'メイ：' + Utility_Common.str(tempAcc.FirstNameFurigana__pc) + '\r\n';
                                strBefAcc += 'メイ：' + Utility_Common.str(dupAccount.FirstNameFurigana__pc) + '\r\n';
                            }
                            if(tempAcc.BillingPostalCode != dupAccount.BillingPostalCode){
                                strAftAcc += '郵便番号：' + Utility_Common.str(tempAcc.BillingPostalCode) + '\r\n';
                                strBefAcc += '郵便番号：' + Utility_Common.str(dupAccount.BillingPostalCode) + '\r\n';
                            }
                            if(tempAcc.BillingState != dupAccount.BillingState){
                                strAftAcc += '都道府県：' + Utility_Common.str(tempAcc.BillingState) + '\r\n';
                                strBefAcc += '都道府県：' + Utility_Common.str(dupAccount.BillingState) + '\r\n';
                            }
                            if(tempAcc.BillingCity != dupAccount.BillingCity){
                                strAftAcc += '市区郡：' + Utility_Common.str(tempAcc.BillingCity) + '\r\n';
                                strBefAcc += '市区郡：' + Utility_Common.str(dupAccount.BillingCity) + '\r\n';
                            }
                            if(tempAcc.BillingStreet != dupAccount.BillingStreet){
                                strAftAcc += '町名・番地：' + Utility_Common.str(tempAcc.BillingStreet) + '\r\n';
                                strBefAcc += '町名・番地：' + Utility_Common.str(dupAccount.BillingStreet) + '\r\n';
                            }
                            if(tempAcc.MobilePhone__c != dupAccount.MobilePhone__c){
                                strAftAcc += '携帯：' + Utility_Common.str(tempAcc.MobilePhone__c) + '\r\n';
                                strBefAcc += '携帯：' + Utility_Common.str(dupAccount.MobilePhone__c) + '\r\n';
                            }
                            if(tempAcc.Phone != dupAccount.Phone){
                                strAftAcc += '電話：' + Utility_Common.str(tempAcc.Phone) + '\r\n';
                                strBefAcc += '電話：' + Utility_Common.str(dupAccount.Phone) + '\r\n';
                            }

                            strText += '・喪主の変更もしくは喪主に紐づけられたお客様情報の更新（またはその両方）がありました' + '\r\n' + 
                                        '→誤った喪主の指定がされていないか、または誤った更新がされていないか確認してください。' + '\r\n' +
                                        '\r\n';

                            String multiAccount = '';
                            if(matchRecordIdList.size() > 1){
                                strText += '・名寄せによる重複を検知しました' + '\r\n' + 
                                            '→重複が発生しているようです。詳細を確認してください。' + '\r\n' +
                                            '\r\n';
                                multiAccount = 'なお、名寄せ時に複数のお客様情報が検出されました。' + '\r\n' + 
                                                'データを確認し、必要があれば手動でマージ作業を実施してください。' + '\r\n' + 
                                                '\r\n' + 
                                                '■名寄せ時に検出された複数のお客様情報' + '\r\n';

                                matchRecordIdList.remove(0);
                                for(String matchRecordId : matchRecordIdList){
                                    multiAccount += baseUrl + 'lightning/r/Account/' + matchRecordId + '/view' + '\r\n';
                                }
                            }

                            strText += strBefAcc + 
                                        '\r\n' + 
                                        strAftAcc + 
                                        '\r\n' + 
                                        '----------' + '\r\n' +
                                        '※ 更新前データと更新後データで何の項目も表示されていない場合は、喪主の指定のみが変更されています' + '\r\n' +
                                        '----------' + '\r\n' +
                                        '\r\n' + 
                                        multiAccount;

                            Database.DMLOptions dml = new Database.DMLOptions();
                            dml.DuplicateRuleHeader.AllowSave = true;
                            Database.SaveResult sr2 = Database.update(tempAcc, dml);
                        }
                        else{
                            Loggings.writeLog(
                                Loggings.createLogEntry(Loggings.Level.Error, '20190219-1328-01', 'SogSokSoryoTehaiShoMoshu')
                                    .putAttr( 'e.getMessage()', error.getMessage() )
                            );
                        }
                    }
                }
            }
            mailFlg = true;
        }

        if(sobjMapForUpdate.size()>0) update sobjMapForUpdate.values();
        if(mailFlg){
            MailAlert__c ma = new MailAlert__c();
            ma.ToAddress__c = Label.WebJizenJunbiMihaneiAddress;
            ma.Title__c = '【パートナーWeb】商談情報更新のお知らせ(僧侶手配依頼書受領時)';
            ma.Body__c = strText;
            insert ma;
        }
    }

    private void update_obop_Ref(Map<Id, Opportunity> oppMap, Map<ID, SogSok_SrthIraiSho_Torik__c> pNewMap){
        // 僧侶手配依頼書 
        for(Id torikiId : oppMap.keySet()){
            if(pNewMap.containskey(torikiId)){
                pNewMap.get(torikiId).obop_Ref__c = oppMap.get(torikiId).Id;
            }
        }

        //葬儀送客,お坊さん便リレーション設定
        this.set_Sokyaku_Obop_Ref(oppMap, pNewMap);

    }

    //葬儀送客,お坊さん便リレーション設定
    private void set_Sokyaku_Obop_Ref(Map<Id, Opportunity> oppMap, Map<ID, SogSok_SrthIraiSho_Torik__c> pNewMap){
        if(pNewMap.size() <= 0) return;

        Map<Id, SokyakuRelation> sokyakuRelationMap = new Map<Id, SokyakuRelation>();
        for(Id torikiId : oppMap.keySet()){
            if(pNewMap.containskey(torikiId)){
                SogSok_SrthIraiSho_Torik__c toriki = pNewMap.get(torikiId);
                if(String.isNotBlank(toriki.SogSok_SrthIraiShoRef__c)) {
                    sokyakuRelationMap.put(toriki.SogSok_SrthIraiShoRef__c, new SokyakuRelation(
                                                             null,
                                                             new SogSok_SrthIraiSho__c(Id=toriki.SogSok_SrthIraiShoRef__c),
                                                             toriki,
                                                             oppMap.get(torikiId)
                                                    ));
                }
            }
        }

        if(sokyakuRelationMap.size() <=0 ) return;
        Set<Id> srthIraiShoIds = sokyakuRelationMap.keySet();
        List<SogSok_Sokyaku__c> sogSok_Sokyakus_for_update = new List<SogSok_Sokyaku__c>();
        for( SogSok_Sokyaku__c sokyaku  : [Select id, SrthIraiShoRef__c From SogSok_Sokyaku__c Where SrthIraiShoRef__c =:srthIraiShoIds]){
            if( sokyakuRelationMap.containskey(sokyaku.SrthIraiShoRef__c) ){
                sogSok_Sokyakus_for_update.add(new SogSok_Sokyaku__c(Id=sokyaku.Id, 
                                                                    obop_Ref__c=sokyakuRelationMap.get(sokyaku.SrthIraiShoRef__c).getOpportunity().Id));
            }
        }
        if(sogSok_Sokyakus_for_update.size() > 0) update sogSok_Sokyakus_for_update;
    }


    private class SokyakuRelation {
        SogSok_Sokyaku__c sokyaku;
        SogSok_SrthIraiSho__c srthIraiSho;
        SogSok_SrthIraiSho_Torik__c toriki;
        Opportunity opp;

        public SokyakuRelation( SogSok_Sokyaku__c sokyaku,
                                SogSok_SrthIraiSho__c srthIraiSho,
                                SogSok_SrthIraiSho_Torik__c toriki,
                                Opportunity opp){
            this.sokyaku = sokyaku;
            this.srthIraiSho = srthIraiSho;
            this.toriki = toriki;
            this.opp = opp;
        }

        public Opportunity getOpportunity(){
            return this.opp;
        }
    }



    private class ObosanBuilder {
        List<SogSok_SrthIraiSho_Torik__c> torikiList = new List<SogSok_SrthIraiSho_Torik__c>();
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();

        public void add(SogSok_SrthIraiSho_Torik__c toriki, Opportunity opp){
            this.torikiList.add(toriki);
            this.oppMap.put(toriki.Id, opp);
        }

        public void saveAll(){
            this.insertOpps();
            this.reloadOpps();
            this.insertOpportunityLineItem();
        }

        private void insertOpportunityLineItem(){
            List<OpportunityLineItem> items = new List<OpportunityLineItem>();
            for(SogSok_SrthIraiSho_Torik__c toriki : torikiList){
                Opportunity opp = this.getOpp(toriki.Id);
                for(SogSok_SrthIraiSho_TorikShohin__c torikiShohin :  toriki.SogSok_SrthIraiSho_TorikShohins__r){
                    PriceBookDao.PriceBookEnt thePriceBookEnt = 
                        PriceBookDao.instance().getEntry(opp.Pricebook2Id, torikiShohin.ShohinRef__r.ShohinBango__c);
                    OpportunityLineItem item = new OpportunityLineItem();
                    item.Product2Id = torikiShohin.ShohinRef__r.Id;
                    item.OpportunityId = opp.Id;
                    item.Quantity = 1;
                    item.UnitPrice = thePriceBookEnt.unitPrice;
                    item.isAutoAddWaribkiItem__c = false;
                    items.add(item);
                }
            }
            if(items.size() > 0 ) insert items;
        }

        private void insertOpps(){
            if(oppMap.size() > 0 ) insert oppMap.values();
        }

        public Opportunity getOpp(String torikiId){
            return oppMap.get(torikiId);
        }

        public Id getOboId(Id torikiId){
            if(oppMap.containskey(torikiId)) return oppMap.get(torikiId).ObosanbinRef__c;
            return null;
        }

        private void reloadOpps(){
            List<Opportunity> opps = oppMap.values();
            Map<Id, Opportunity> newOppMap = new Map<Id, Opportunity>([Select id, 
                                            Pricebook2Id,
                                            AccountId,
                                            TaishosyaRef__c,
                                            MosyuRef__c,
                                            ObosanbinRef__c
                                            from Opportunity where id = :opps]);
            
            for(Id torikiId : oppMap.keySet()){
                Opportunity opp = oppMap.get(torikiId);
                oppMap.put(torikiId, newOppMap.get(opp.Id));    
            }
        }
    }

    private static String StdPricebook2Id;
    private String getStdPricebook2Id(){
        if(StdPricebook2Id == null){
            try{
                StdPricebook2Id = [select id from Pricebook2 where IsStandard = TRUE limit 1].Id;
            } catch(Exception ex){
                StdPricebook2Id = '';
            }
        }
        if (Test.isRunningTest()) return Test.getStandardPricebookId();
        return StdPricebook2Id;
    }

    private Map<Id, Opportunity> getSimpleOppMap(List<SogSok_SrthIraiSho_Torik__c> processData){
        if(processData.size() <= 0) return new Map<Id, Opportunity>();
        Set<Id> oppIds = new Set<Id>();
        for(SogSok_SrthIraiSho_Torik__c toriki : processData){
            oppIds.add(toriki.syop_Ref__c);
        }
        return new Map<Id, Opportunity>([Select id, 
                                        AccountId,
                                        Pricebook2Id,
                                        SimpleYasugoRef__c,
                                        SimpleYasugoRef__r.MoshuRef__c,
                                        SimpleYasugoRef__r.MoshuRef__r.LastName,
                                        SimpleYasugoRef__r.MoshuRef__r.FirstName,
                                        SimpleYasugoRef__r.MoshuRef__r.FirstNameFurigana__pc,
                                        SimpleYasugoRef__r.MoshuRef__r.LastNameFurigana__pc,
                                        SimpleYasugoRef__r.MoshuRef__r.PersonBirthdate,
                                        SimpleYasugoRef__r.MoshuRef__r.BillingCity,
                                        SimpleYasugoRef__r.MoshuRef__r.BillingPostalCode,
                                        SimpleYasugoRef__r.MoshuRef__r.BillingState,
                                        SimpleYasugoRef__r.MoshuRef__r.BillingStreet,
                                        SimpleYasugoRef__r.MoshuRef__r.Gender__pc,
                                        SimpleYasugoRef__r.MoshuRef__r.Phone,
                                        SimpleYasugoRef__r.MoshuRef__r.MobilePhone__c,
                                        SimpleYasugoRef__r.TsuyaDateTime_Inp__c,
                                        SimpleYasugoRef__r.KokubetsuDateTime_Inp__c,
                                        SimpleYasugoRef__r.ShukkanDateTimei_Inp__c,
                                        SimpleYasugoRef__r.KasoDateTime_Inp__c,
                                        SimpleYasugoRef__r.SoryoTehaiIraishoJuryobi__c,
                                        // SimpleYasugoRef__r.SeikyushojuryoDay__c,
                                        (Select id From OpportunityLineItems),
                                        (   
                                            SELECT Id FROM KaisyuYoteisOpportunity__r //お客様請求明細 (商談)
                                            Where SeikyuHouhou__c = 'Partner'
                                            AND servicesyubetsu__c = 'シンプル安豪'
                                        )
                                        from Opportunity where id = :oppIds]);
    }
}