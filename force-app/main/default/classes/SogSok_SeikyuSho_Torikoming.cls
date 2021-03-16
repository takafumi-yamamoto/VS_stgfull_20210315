public class SogSok_SeikyuSho_Torikoming {
    public void subscriveOnSogSokSeikyuShoTorikAfterUpdated(List<SogSok_SeikyuSho_Torik__c> pNewOnes, Map<ID, SogSok_SeikyuSho_Torik__c> pOldOnes){
    	this.updateSyoudan(
                this.reloadData(
                    this.getProcessData(pNewOnes, pOldOnes)
            ));

    }

    private List<SogSok_SeikyuSho_Torik__c> getProcessData(List<SogSok_SeikyuSho_Torik__c> pNewOnes, Map<ID, SogSok_SeikyuSho_Torik__c> pOldOnes){
    	List<SogSok_SeikyuSho_Torik__c> processData = new List<SogSok_SeikyuSho_Torik__c>();
    	for(SogSok_SeikyuSho_Torik__c pOne : pNewOnes){
    		if(pOldOnes.containskey(pOne.Id)){
    			SogSok_SeikyuSho_Torik__c pOldOne = pOldOnes.get(pOne.Id);
    			if(pOne.Status__c != pOldOne.Status__c && pOne.Status__c == '取込'){
                    
                    if(String.isBlank(pOne.syop_Ref__c)){
                        pOne.addError('商談を登録してください; '); 
                        continue;
                    }
    	    		processData.add(pOne);
    			}
    		}
    	}
    	return processData;
    }

    private List<SogSok_SeikyuSho_Torik__c> reloadData(List<SogSok_SeikyuSho_Torik__c> processData){
        if(processData.size() <= 0 ) return new List<SogSok_SeikyuSho_Torik__c>();
        return [SELECT 
				        Id ,
				        Name ,
				        SeikyuShoRef__c ,
				        syop_Ref__c ,
				        Status__c ,
				        syop_TsuyaDateTime__c ,
				        syop_KokubetsuDateTime__c ,
				        syop_ShukkanDateTime__c ,
				        syop_KasoDateTime__c ,
				        syop_GenkinKingaku__c ,
				        syop_SeikyusShoJuryoDate__c ,
                        syop_Moshu_Sei__c,
                        syop_Moshu_Mei__c,
                        syop_Moshu_MeiKana__c,
                        syop_Moshu_SeiKana__c,
                        syop_Moshu_BirthDate__c,
                        syop_Moshu_Addr_City__c,
                        syop_Moshu_Addr_PostalCode__c,
                        syop_Moshu_Addr_State__c,
                        syop_Moshu_Addr_Street__c,
                        syop_Moshu_Gender__c,
                        syop_Moshu_Phone__c,
                        syop_Moshu_Mobile__c,
				        StatusDescr__c ,
                        (
                            SELECT 
                                    Id ,
                                    Name ,
                                    Quantity__c,
                                    UnitPrice__c,
                                    ShohinRef__c,
                                    ShohinRef__r.Name,
                                    ShohinRef__r.Id,
                                    ShohinRef__r.ShohinBango__c,
                                    ShohinRef__r.k_ShohinSyubetsu_Id_exp__c 
                             FROM SogSok_SeikyuSho_TorikShohins__r
                        )
				 FROM SogSok_SeikyuSho_Torik__c
                 Where id = :processData
        ];
    }

    private void updateSyoudan(List<SogSok_SeikyuSho_Torik__c> processData){
        if(processData.size() <= 0) return;
    	Map<Id, Opportunity> simpleOppMap = this.getSimpleOppMap(processData);

        Map<Id, SObject> sobjMapForUpdate = new Map<Id, SObject>();
        List<SObject> itemsForInsert = new List<SObject>();
        List<SObject> itemsForDelete = new List<SObject>();

        List<Id> simpleIdList = new List<Id>();
        List<Account> accMoshuList = new List<Account>();
        String juryoShoId = '';
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        String strText = '今回、発生した変更内容は以下のとおりです。' + '\r\n' + '\r\n';
        Boolean mailFlg = false;
        String jushinPlanShohinBango = '';
        String jushinPlanShohinName = '';
    	for(SogSok_SeikyuSho_Torik__c toriki : processData){
            // 1件ずつしかこないため
            juryoShoId = toriki.SeikyuShoRef__c;

    		Opportunity theOpp = simpleOppMap.get(toriki.syop_Ref__c);

            strText = '〇商談データ' + '\r\n' + 
                        baseUrl + 'lightning/r/Opportunity/' + theOpp.Id + '/view' + '\r\n' + 
                        '\r\n';

            Account accMoshu = new Account();
            accMoshu.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();

            //喪主
            if(theOpp.SimpleYasugoRef__r.MoshuRef__r.LastName != toriki.syop_Moshu_Sei__c || 
                theOpp.SimpleYasugoRef__r.MoshuRef__r.FirstName != toriki.syop_Moshu_Mei__c || 
                theOpp.SimpleYasugoRef__r.MoshuRef__r.FirstNameFurigana__pc != toriki.syop_Moshu_MeiKana__c || 
                theOpp.SimpleYasugoRef__r.MoshuRef__r.LastNameFurigana__pc != toriki.syop_Moshu_SeiKana__c || 
                theOpp.SimpleYasugoRef__r.MoshuRef__r.PersonBirthdate !=  toriki.syop_Moshu_BirthDate__c || 
                theOpp.SimpleYasugoRef__r.MoshuRef__r.BillingCity != toriki.syop_Moshu_Addr_City__c || 
                theOpp.SimpleYasugoRef__r.MoshuRef__r.BillingPostalCode != toriki.syop_Moshu_Addr_PostalCode__c || 
                theOpp.SimpleYasugoRef__r.MoshuRef__r.BillingState != toriki.syop_Moshu_Addr_State__c || 
                theOpp.SimpleYasugoRef__r.MoshuRef__r.BillingStreet != toriki.syop_Moshu_Addr_Street__c || 
                theOpp.SimpleYasugoRef__r.MoshuRef__r.Gender__pc != toriki.syop_Moshu_Gender__c || 
                theOpp.SimpleYasugoRef__r.MoshuRef__r.Phone != toriki.syop_Moshu_Phone__c || 
                theOpp.SimpleYasugoRef__r.MoshuRef__r.MobilePhone__c != toriki.syop_Moshu_Mobile__c){
                accMoshu.LastName = toriki.syop_Moshu_Sei__c;
                accMoshu.FirstName = toriki.syop_Moshu_Mei__c;
                accMoshu.FirstNameFurigana__pc = toriki.syop_Moshu_MeiKana__c;
                accMoshu.LastNameFurigana__pc = toriki.syop_Moshu_SeiKana__c;
                accMoshu.PersonBirthdate = toriki.syop_Moshu_BirthDate__c;
                accMoshu.BillingCity = toriki.syop_Moshu_Addr_City__c;
                accMoshu.BillingPostalCode = toriki.syop_Moshu_Addr_PostalCode__c;
                accMoshu.BillingState = toriki.syop_Moshu_Addr_State__c;
                accMoshu.BillingStreet = toriki.syop_Moshu_Addr_Street__c;
                accMoshu.Gender__pc = toriki.syop_Moshu_Gender__c;
                accMoshu.Phone = toriki.syop_Moshu_Phone__c;
                accMoshu.MobilePhone__c = toriki.syop_Moshu_Mobile__c;
                simpleIdList.add(theOpp.SimpleYasugoRef__c);
                accMoshuList.add(accMoshu);
            }

    		//葬儀
    		Id simpleId = theOpp.SimpleYasugoRef__c;
    		if(String.isNotBlank(simpleId)){
    			SimpleYasugo__c simple = sobjMapForUpdate.containskey(simpleId) ? (SimpleYasugo__c)sobjMapForUpdate.get(simpleId) : new SimpleYasugo__c(Id = simpleId);
    			Boolean isChanged = false;
    			//葬儀
    			if(toriki.syop_TsuyaDateTime__c != null && theOpp.SimpleYasugoRef__r.TsuyaDateTime_Inp__c != toriki.syop_TsuyaDateTime__c){
    				simple.TsuyaDateTime_Inp__c = toriki.syop_TsuyaDateTime__c;
    				isChanged = true;
    			}
    			if(toriki.syop_KokubetsuDateTime__c != null && theOpp.SimpleYasugoRef__r.KokubetsuDateTime_Inp__c != toriki.syop_KokubetsuDateTime__c){
    				simple.KokubetsuDateTime_Inp__c = toriki.syop_KokubetsuDateTime__c;
    				isChanged = true;
    			}
    			if(toriki.syop_ShukkanDateTime__c != null && theOpp.SimpleYasugoRef__r.ShukkanDateTimei_Inp__c != toriki.syop_ShukkanDateTime__c){
    				simple.ShukkanDateTimei_Inp__c = toriki.syop_ShukkanDateTime__c;
    				isChanged = true;
    			}
    			if(toriki.syop_KasoDateTime__c != null && theOpp.SimpleYasugoRef__r.KasoDateTime_Inp__c != toriki.syop_KasoDateTime__c){
    				simple.KasoDateTime_Inp__c = toriki.syop_KasoDateTime__c;
    				isChanged = true;
    			}
    			//葬儀社
    			// if(toriki.syop_SeikyusShoJuryoDate__c != null && theOpp.SimpleYasugoRef__r.SeikyushojuryoDay__c != toriki.syop_SeikyusShoJuryoDate__c){
    			// 	simple.SeikyushojuryoDay__c = toriki.syop_SeikyusShoJuryoDate__c;
    			// 	isChanged = true;
    			// }
                if(isChanged)  sobjMapForUpdate.put(simpleId, simple);

	            itemsForInsert.addAll((List<SObject>)this.getOpportunityLineItems(theOpp, toriki.SogSok_SeikyuSho_TorikShohins__r));
	            itemsForInsert.addAll((List<SObject>)this.getOkyakusamaSeikyuMeisai(theOpp, toriki));
	            
	            itemsForDelete.addAll((List<SObject>)theOpp.OpportunityLineItems);
	            itemsForDelete.addAll((List<SObject>)theOpp.KaisyuYoteisOpportunity__r);
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
                            if(tempAcc.Gender__pc != dupAccount.Gender__pc){
                                strAftAcc += '性別：' + Utility_Common.str(tempAcc.Gender__pc) + '\r\n';
                                strBefAcc += '性別：' + Utility_Common.str(dupAccount.Gender__pc) + '\r\n';
                            }
                            if(tempAcc.BillingCity != dupAccount.BillingCity){
                                if(tempAcc.PersonBirthdate == null){
                                    strAftAcc += '生年月日：' + '\r\n';
                                }
                                else{
                                    strAftAcc += '生年月日：' + tempAcc.PersonBirthdate.format() + '\r\n';
                                }

                                if(dupAccount.PersonBirthdate == null){
                                    strBefAcc += '生年月日：' + '\r\n';
                                }
                                else{
                                    strBefAcc += '生年月日：' + dupAccount.PersonBirthdate.format() + '\r\n';
                                }
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
                                Loggings.createLogEntry(Loggings.Level.Error, '20190129-1749-01', 'SogSokSeikyuShoMoshu')
                                    .putAttr( 'e.getMessage()', error.getMessage() )
                            );
                        }
                    }
                }
            }
            mailFlg = true;
        }

        if(itemsForDelete.size() > 0) delete itemsForDelete;
        if(sobjMapForUpdate.size() > 0) update sobjMapForUpdate.values();
        if(itemsForInsert.size() > 0) insert itemsForInsert;
        if(mailFlg){
            MailAlert__c ma = new MailAlert__c();
            ma.ToAddress__c = Label.WebJizenJunbiMihaneiAddress;
            ma.Title__c = '【パートナーWeb】商談情報更新のお知らせ(請求書受領時)';
            ma.Body__c = strText;
            insert ma;
        }
    }

    private Map<Id, Opportunity> getSimpleOppMap(List<SogSok_SeikyuSho_Torik__c> processData){
        if(processData.size() <= 0) return new Map<Id, Opportunity>();
    	Set<Id> oppIds = new Set<Id>();
    	for(SogSok_SeikyuSho_Torik__c toriki : processData){
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
                                        // SimpleYasugoRef__r.SeikyushojuryoDay__c,
                                        (Select id, Product2.ShohinBango__c, Product2.Name, Product2.k_Service_Id_exp__c, Product2.k_ShohinSyubetsu_Id_exp__c From OpportunityLineItems),
                                        (	
                                        	SELECT Id FROM KaisyuYoteisOpportunity__r //お客様請求明細 (商談)
                                        	Where SeikyuHouhou__c = 'Partner'
                                        	AND servicesyubetsu__c = 'シンプル安豪'
                                        )
    									from Opportunity where id = :oppIds]);
    }

    /**
    * SogSok_SeikyuSho_TorikShohins -> OpportunityLineItem
    */
    private List<OpportunityLineItem> getOpportunityLineItems(Opportunity aOpp, List<SogSok_SeikyuSho_TorikShohin__c> torikiShohins){
        List<OpportunityLineItem> items = new List<OpportunityLineItem>();
        for(SogSok_SeikyuSho_TorikShohin__c torikiShohin : torikiShohins){
            OpportunityLineItem item = new OpportunityLineItem();
            item.Product2Id = torikiShohin.ShohinRef__c;
            item.OpportunityId = aOpp.Id;
            item.Quantity = torikiShohin.Quantity__c;
            item.UnitPrice = torikiShohin.UnitPrice__c;
            item.isAutoAddWaribkiItem__c = false;
            items.add(item);
        }
        return items;
    }

    private List<OkyakusamaSeikyuMeisai__c> getOkyakusamaSeikyuMeisai(Opportunity aOpp, SogSok_SeikyuSho_Torik__c toriki){
    	List<OkyakusamaSeikyuMeisai__c> meisaiList = new List<OkyakusamaSeikyuMeisai__c>();
		if(toriki.syop_GenkinKingaku__c == null || toriki.syop_GenkinKingaku__c == 0) return meisaiList;
        OkyakusamaSeikyuMeisai__c meisai = new OkyakusamaSeikyuMeisai__c(
        		recordtypeid = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('OkyakusamaSeikyuMeisai__c','KobetsuSeikyu'),   // レコードタイプ ID
        		opportunityref__c = aOpp.Id,
        		servicesyubetsu__c = 'シンプル安豪',   // サービス種別
        		seikyuhouhou__c = 'Partner',   // 請求方法
        		seikyukingaku__c = toriki.syop_GenkinKingaku__c   // 請求金額
        	);
        meisaiList.add(meisai);
        return meisaiList;
    }


}