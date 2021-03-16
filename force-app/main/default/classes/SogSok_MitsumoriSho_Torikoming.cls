public class SogSok_MitsumoriSho_Torikoming {
    
    public void subscriveOnSogSokMitsumoriShoTorikAfterUpdated(List<SogSok_MitsumoriSho_Torik__c> pNewOnes, Map<ID, SogSok_MitsumoriSho_Torik__c> pOldOnes){
    	this.updateSyoudan(
                this.reloadData(
                    this.getProcessData(pNewOnes, pOldOnes)
            ));
    }

    private List<SogSok_MitsumoriSho_Torik__c> getProcessData(List<SogSok_MitsumoriSho_Torik__c> pNewOnes, Map<ID, SogSok_MitsumoriSho_Torik__c> pOldOnes){
        System.debug('getProcessData start');
    	List<SogSok_MitsumoriSho_Torik__c> processData = new List<SogSok_MitsumoriSho_Torik__c>();
    	for(SogSok_MitsumoriSho_Torik__c pOne : pNewOnes){
    		if(pOldOnes.containskey(pOne.Id)){
    			SogSok_MitsumoriSho_Torik__c pOldOne = pOldOnes.get(pOne.Id);
    			if(pOne.Status__c != pOldOne.Status__c && pOne.Status__c == '取込'){
                    
                    if(String.isBlank(pOne.syop_Ref__c)){
                        pOne.addError('商談を登録してください; '); 
                        continue;
                    }
                    if(String.isBlank(pOne.syop_SoudanshaRef__c)){
                        pOne.addError('相談者を登録してください; '); 
                        continue;
                    }
                    if(String.isBlank(pOne.syop_TaishoShaRef__c)){
                        pOne.addError('対象者を登録してください; '); 
                        continue;
                    }
    	    		processData.add(pOne);
    			}
    		}
    	}
    	return processData;
    }

    private void updateSyoudan(List<SogSok_MitsumoriSho_Torik__c> processData){
        if(processData.size() <= 0) return;
    	Map<Id, Opportunity> simpleOppMap = this.getSimpleOppMap(processData);

        Map<Id, SObject> sobjMapForUpdate = new Map<Id, SObject>();
        List<SObject> itemsForInsert = new List<SObject>();
        List<SObject> itemsForDelete = new List<SObject>();

        List<Id> simpleIdList = new List<Id>();
        List<Account> accMoshuList = new List<Account>();
        String juryoShoId = '';
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        String strText = '商談情報の一部に更新がありました。内容を確認してください。' + '\r\n' + '今回、発生した変更内容は以下のとおりです。' + '\r\n' + '\r\n';
        Boolean mailFlg = false;
        String jushinPlanShohinBango = '';
        String jushinPlanShohinName = '';
        Decimal jushinPlanShohinAmount = 0;
        Boolean palnChangeFlg = false;
    	for(SogSok_MitsumoriSho_Torik__c toriki : processData){
            // 1件ずつしかこないため
            List<SogSok_MitsumoriSho_TorikShohin__c> toriWariList = [select Id, ShohinRef__r.Name, ShohinRef__r.k_ShohinSyubetsu_Id_exp__c, Amount__c from SogSok_MitsumoriSho_TorikShohin__c where SogSok_MitsumoriSho_TorikRef__c = :toriki.Id];
            juryoShoId = toriki.MitsumoriShoRef__c;

            for(SogSok_MitsumoriSho_TorikShohin__c torikshohin : toriki.SogSok_MitsumoriSho_TorikShohins__r){
                if(torikshohin.ShohinRef__r.k_ShohinSyubetsu_Id_exp__c == '1'){
                    jushinPlanShohinBango = torikshohin.ShohinRef__r.ShohinBango__c;
                    jushinPlanShohinName = torikshohin.ShohinRef__r.Name;
                    jushinPlanShohinAmount = torikshohin.Amount__c;
                }
            }

    		Opportunity theOpp = simpleOppMap.get(toriki.syop_Ref__c);

            strText += '〇商談データ' + '\r\n' + 
                        baseUrl + 'lightning/r/Opportunity/' + theOpp.Id + '/view' + '\r\n' + 
                       '\r\n';

            Boolean isMoshuNull = false;
            Account accMoshu = new Account();
            accMoshu.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();

            if(theOpp.Account.LastName != toriki.syop_Soudansha_Sei__c || theOpp.Account.FirstName != toriki.syop_Soudansha_Mei__c){
                strText += '≪相談者≫' + '\r\n' +
                            '■受信した書類で相談者に指定された情報' + '\r\n' + 
                            '[更新前]' + '\r\n' + theOpp.Account.LastName + ' ' + theOpp.Account.FirstName + '\r\n' + '\r\n' + 
                            '[更新後]' + '\r\n' + toriki.syop_Soudansha_Sei__c + ' ' + toriki.syop_Soudansha_Mei__c + '\r\n' + 
                            '\r\n';
                mailFlg = true;
            }

            String planChangeBefore = '[更新前]' + '\r\n' + 'プラン：';
            String planChangeAfter = '[更新後]' + '\r\n' + 'プラン：';
            String waribikiChangeBefore = '割引：';
            String waribikiChangeAfter = '割引：';
            for(OpportunityLineItem oppIL : theOpp.OpportunityLineItems){
                if(oppIL.Product2.k_ShohinSyubetsu_Id_exp__c == '1' && oppIL.Product2.ShohinBango__c != jushinPlanShohinBango){
                    planChangeBefore += oppIL.Product2.Name + ' ' + oppIL.TotalPrice + '円';
                    planChangeAfter += jushinPlanShohinName + ' ' + jushinPlanShohinAmount + '円';
                    palnChangeFlg = true;
                    mailFlg = true;
                }
                else if(oppIL.Product2.k_ShohinSyubetsu_Id_exp__c == '6'){
                    waribikiChangeBefore += oppIL.Product2.Name + ' ' + oppIL.TotalPrice + '円, ';
                }
            }

            for(SogSok_MitsumoriSho_TorikShohin__c toriWari : toriWariList){
                if(toriWari.ShohinRef__r.k_ShohinSyubetsu_Id_exp__c == '6'){
                    waribikiChangeAfter += toriWari.ShohinRef__r.Name + ' ' + toriWari.Amount__c + '円, ';
                }
            }

            if(palnChangeFlg){
                strText += '≪プラン≫' + '\r\n' +
                            '■受信した書類でプランに指定された情報' + '\r\n' + 
                            planChangeBefore + '\r\n' + 
                            waribikiChangeBefore + '\r\n' + '\r\n' + 
                            planChangeAfter + '\r\n' + 
                            waribikiChangeAfter + '\r\n' + '\r\n';
            }

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
                if(String.isBlank(toriki.syop_Moshu_Sei__c) && 
                    String.isBlank(toriki.syop_Moshu_Mei__c) && 
                    String.isBlank(toriki.syop_Moshu_MeiKana__c) && 
                    String.isBlank(toriki.syop_Moshu_SeiKana__c) && 
                    toriki.syop_Moshu_BirthDate__c == null && 
                    String.isBlank(toriki.syop_Moshu_Addr_City__c) && 
                    String.isBlank(toriki.syop_Moshu_Addr_PostalCode__c) && 
                    String.isBlank(toriki.syop_Moshu_Addr_State__c) && 
                    String.isBlank(toriki.syop_Moshu_Addr_Street__c) && 
                    String.isBlank(toriki.syop_Moshu_Gender__c) && 
                    String.isBlank(toriki.syop_Moshu_Phone__c) && 
                    String.isBlank(toriki.syop_Moshu_Mobile__c)){
                    isMoshuNull = true;
                }
                else{
                    String moshu_sei = toriki.syop_Moshu_Sei__c;
                    if(String.isBlank(moshu_sei)){
                        moshu_sei = theOpp.ShodanBango__c + '_喪主様';
                    }
                    accMoshu.LastName = moshu_sei;
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
            }
            
    		//対象者
    		if(String.isNotBlank(toriki.syop_TaishoShaRef__c)){
    			Account acc = sobjMapForUpdate.containskey(toriki.syop_TaishoShaRef__c) ? (Account)sobjMapForUpdate.get(toriki.syop_TaishoShaRef__c) : new Account(Id=toriki.syop_TaishoShaRef__c);
    			Boolean isChanged = false;
    			if(String.isNotBlank(toriki.syop_TaishoSha_Sei__c)){
    				acc.LastName = toriki.syop_TaishoSha_Sei__c;
    				isChanged = true;
    			}
    			if(String.isNotBlank(toriki.syop_TaishoSha_Mei__c)){
    				acc.FirstName = toriki.syop_TaishoSha_Mei__c;
    				isChanged = true;
    			}
    			if(toriki.syop_TaishoSha_BirthDate__c != null){
    				acc.PersonBirthdate = toriki.syop_TaishoSha_BirthDate__c;
    				isChanged = true;
    			}
    			if(toriki.syop_TaishoSha_DeathDate__c != null){
    				acc.PersonDeathDate__pc = toriki.syop_TaishoSha_DeathDate__c;
    				isChanged = true;
    			}
    			if(toriki.syop_TaishoSha_Age__c != null){
    				acc.ManNenrei__c = toriki.syop_TaishoSha_Age__c;
    				isChanged = true;
    			}
    			if(String.isNotBlank(toriki.syop_TaishoSha_Gender__c)){
    				acc.Gender__pc = toriki.syop_TaishoSha_Gender__c;
    				isChanged = true;
    			}
    			if(String.isNotBlank(toriki.syop_TaishoSha_Addr_PostalCode__c)){
    				acc.BillingPostalCode = toriki.syop_TaishoSha_Addr_PostalCode__c;
    				isChanged = true;
    			}
    			if(String.isNotBlank(toriki.syop_TaishoSha_Addr_State__c)){
    				acc.BillingState = toriki.syop_TaishoSha_Addr_State__c;
    				isChanged = true;
    			}
    			if(String.isNotBlank(toriki.syop_TaishoSha_Addr_City__c)){
    				acc.BillingCity = toriki.syop_TaishoSha_Addr_City__c;
    				isChanged = true;
    			}
    			if(String.isNotBlank(toriki.syop_TaishoSha_Addr_Street__c)){
    				acc.BillingStreet = toriki.syop_TaishoSha_Addr_Street__c;
    				isChanged = true;
    			}
    			if(String.isNotBlank(toriki.syop_TaishoSha_Jumh_City__c)){
    				acc.JuminhyouCity__c = toriki.syop_TaishoSha_Jumh_City__c;
    				isChanged = true;
    			}
    			if(String.isNotBlank(toriki.syop_TaishoSha_Jumh_State__c)){
    				acc.JuminhyouState__c = toriki.syop_TaishoSha_Jumh_State__c;
    				isChanged = true;
    			}
    			if(String.isNotBlank(toriki.syop_TaishoSha_Shuha__c)){
    				acc.Syuha__c = toriki.syop_TaishoSha_Shuha__c;
    				isChanged = true;
    			}
    			if(String.isNotBlank(toriki.syop_TaishoSha_Shuha_Sonota__c)){
    				acc.SonotanoSyukyoSyuha__c = toriki.syop_TaishoSha_Shuha_Sonota__c;
    				isChanged = true;
    			}
    			if(String.isNotBlank(toriki.syop_TaishoSha_Bodaiji_Umu__c)){
    				acc.BodaijinoUmu__c = toriki.syop_TaishoSha_Bodaiji_Umu__c;
    				isChanged = true;
    			}
    			if(isChanged)  sobjMapForUpdate.put(toriki.syop_TaishoShaRef__c, acc);
    		}

            //相談者
            if(String.isNotBlank(toriki.syop_SoudanshaRef__c)){
                Account acc = sobjMapForUpdate.containskey(toriki.syop_SoudanshaRef__c) ? (Account)sobjMapForUpdate.get(toriki.syop_SoudanshaRef__c) : new Account(Id=toriki.syop_SoudanshaRef__c);
                Boolean isChanged = false;
                if(String.isNotBlank(toriki.syop_Soudansha_Sei__c)){
                    acc.LastName = toriki.syop_Soudansha_Sei__c;
                    isChanged = true;
                }
                if(String.isNotBlank(toriki.syop_Soudansha_Mei__c)){
                    acc.FirstName = toriki.syop_Soudansha_Mei__c;
                    isChanged = true;
                }
                if(isChanged) sobjMapForUpdate.put(toriki.syop_SoudanshaRef__c, acc);
            }

    		//葬儀
    		Id simpleId = theOpp.SimpleYasugoRef__c;
    		if(String.isNotBlank(simpleId)){
    			SimpleYasugo__c simple = sobjMapForUpdate.containskey(simpleId) ? (SimpleYasugo__c)sobjMapForUpdate.get(simpleId) : new SimpleYasugo__c(Id = simpleId);
    			Boolean isChanged = false;
    			//葬儀
    			if(String.isNotBlank(toriki.syop_Moshu_Sei__c)){
    				simple.SokyakugoPlanHenkoUmu__c = toriki.syop_PlanHenkouUmu__c;
    				isChanged = true;
    			}
    			if(toriki.syop_TsuyaDateTime__c != null){
    				simple.TsuyaDateTime_Inp__c = toriki.syop_TsuyaDateTime__c;
    				isChanged = true;
    			}
    			if(toriki.syop_KokubetsuDateTime__c != null){
    				simple.KokubetsuDateTime_Inp__c = toriki.syop_KokubetsuDateTime__c;
    				isChanged = true;
    			}
    			if(toriki.syop_ShukkanDateTime__c != null){
    				simple.ShukkanDateTimei_Inp__c = toriki.syop_ShukkanDateTime__c;
    				isChanged = true;
    			}
    			if(toriki.syop_KasoDateTime__c != null){
    				simple.KasoDateTime_Inp__c = toriki.syop_KasoDateTime__c;
    				isChanged = true;
    			}
    			if(String.isNotBlank(toriki.syop_SonotaSaijoName__c)){
    				simple.SonotaSaijoShisetsu__c = toriki.syop_SonotaSaijoName__c;
    				isChanged = true;
    			}
    			if(String.isNotBlank(toriki.syop_SonotaKasobaName__c)){
    				simple.SonotaKasobaShisetsu__c = toriki.syop_SonotaKasobaName__c;
    				isChanged = true;
    			}
				//葬儀社
    			if(toriki.syop_MitsumoriJuryoDate__c != null){
    				simple.MitsumorijuryoDay__c = toriki.syop_MitsumoriJuryoDate__c;
    				isChanged = true;
    			}
    			if(String.isNotBlank(toriki.syop_SogiTantoName__c)){
    				simple.SogishagawaTantoshamei__c = toriki.syop_SogiTantoName__c;
    				isChanged = true;
    			}
	    		//僧侶手配
    			if(String.isNotBlank(toriki.syop_SoryoTehaiKiboUmu__c)){
    				simple.MonkArrangements__c = toriki.syop_SoryoTehaiKiboUmu__c;
    				isChanged = true;
    			}
    			if(String.isNotBlank(toriki.syop_KaimyoKiboUmu__c)){
    				simple.Kaimyojuyo__c = toriki.syop_KaimyoKiboUmu__c;
    				isChanged = true;
    			}
    			if(String.isNotBlank(toriki.syop_Kaimyo__c)){
    				simple.Kaimyo__c = toriki.syop_Kaimyo__c;
    				isChanged = true;
    			}
    			if(String.isNotBlank(toriki.syop_MoshuZokugaraFromSoudanSha__c)){
    				simple.ZokugaraSodanshaKaramitaMoshu__c = toriki.syop_MoshuZokugaraFromSoudanSha__c; //続柄：相談者から見た喪主
    				isChanged = true;
    			}
                //対象者と喪主更新
                if(theOpp.SimpleYasugoRef__r.TaishoshaRef__c != toriki.syop_TaishoShaRef__c && String.isNotBlank(toriki.syop_TaishoShaRef__c)){
                    simple.TaishoshaRef__c = toriki.syop_TaishoShaRef__c;
                    isChanged = true;
                }
                if(isMoshuNull){
                    simple.MoshuRef__c = null;
                    isChanged = true;
                }
                if(isChanged)  sobjMapForUpdate.put(simpleId, simple);
            }

            Boolean isOppChanged = false;
            if(theOpp.AccountId != toriki.syop_SoudanshaRef__c && String.isNotBlank(toriki.syop_SoudanshaRef__c)){
                theOpp.AccountId = toriki.syop_SoudanshaRef__c;
                isOppChanged = true;
            }
            //領収書
            if(String.isNotBlank(toriki.syop_Ryos_Atena__c)){
                theOpp.RyosyuAtena__c = toriki.syop_Ryos_Atena__c;
                isOppChanged = true;
            }
            if(String.isNotBlank(toriki.syop_Ryos_PostalCode__c)){
                theOpp.RyosyuSoufuPostalCode__c = toriki.syop_Ryos_PostalCode__c;
                isOppChanged = true;
            }
            if(String.isNotBlank(toriki.syop_Ryos_State__c)){
                theOpp.RyosyuSoufuSakiState__c = toriki.syop_Ryos_State__c;
                isOppChanged = true;
            }
            if(String.isNotBlank(toriki.syop_Ryos_City__c)){
                theOpp.RyosyuSoufuSakiCity__c = toriki.syop_Ryos_City__c;
                isOppChanged = true;
            }
            if(String.isNotBlank(toriki.syop_Ryos_Street__c)){
                theOpp.RyosyuSoufuSakiStreet__c = toriki.syop_Ryos_Street__c;
                isOppChanged = true;
            }
            if(toriki.syop_Ryos_RyosyuShoHitsuyo__c != null){
                theOpp.RyosyuYou__c = toriki.syop_Ryos_RyosyuShoHitsuyo__c;
                isOppChanged = true;
            }
            if(isOppChanged) sobjMapForUpdate.put(toriki.syop_Ref__c, theOpp);

            itemsForInsert.addAll((List<SObject>)this.getOpportunityLineItems(theOpp, toriki.SogSok_MitsumoriSho_TorikShohins__r));
            itemsForInsert.addAll((List<SObject>)this.getOkyakusamaSeikyuMeisai(theOpp, toriki));
            itemsForDelete.addAll((List<SObject>)theOpp.OpportunityLineItems);
            itemsForDelete.addAll((List<SObject>)theOpp.KaisyuYoteisOpportunity__r);
    	}

        if(simpleIdList.size() > 0){
            List<Database.SaveResult> srList = Database.insert(accMoshuList, false);
            List<SimpleYasugo__c> upSimpleYasugoList = new List<SimpleYasugo__c>();
            List<Account> upAccountList = new List<Account>();

            strText += '≪喪主≫' + '\r\n';
            String strBefAcc = '■受信した書類で喪主に指定されたお客様の情報' + '\r\n' + '[更新前]' + '\r\n';
            String strAftAcc = '[更新後]' + '\r\n';

            for(Database.SaveResult sr : srList){
                System.debug(sr.isSuccess());
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
                        System.debug('error:' + error);
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
                            if(tempAcc.PersonBirthdate != dupAccount.PersonBirthdate){
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
                                Loggings.createLogEntry(Loggings.Level.Error, '20190128-1755-01', 'SogSokMitsumoriShoMoshu')
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
            ma.Title__c = '【パートナーWeb】商談情報更新のお知らせ(見積書受領時)';
            ma.Body__c = strText;
            insert ma;
        }
    }


    /**
    * SogSok_MitsumoriSho_TorikShohins -> OpportunityLineItem
    */
    private List<OpportunityLineItem> getOpportunityLineItems(Opportunity aOpp, List<SogSok_MitsumoriSho_TorikShohin__c> torikiShohins){
        List<OpportunityLineItem> items = new List<OpportunityLineItem>();
        for(SogSok_MitsumoriSho_TorikShohin__c torikiShohin : torikiShohins){
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

    private Map<Id, Opportunity> getSimpleOppMap(List<SogSok_MitsumoriSho_Torik__c> processData){
        if(processData.size() <= 0) return new Map<Id, Opportunity>();
    	Set<Id> oppIds = new Set<Id>();
    	for(SogSok_MitsumoriSho_Torik__c toriki : processData){
    		oppIds.add(toriki.syop_Ref__c);
    	}
    	return new Map<Id, Opportunity>([Select id, 
    									AccountId,
                                        Account.LastName,
                                        Account.FirstName,
                                        Pricebook2Id,
                                        ShodanBango__c,
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
                                        SimpleYasugoRef__r.TaishoshaRef__c,
                                        (Select id, Product2.ShohinBango__c, Product2.Name, Product2.k_Service_Id_exp__c, Product2.k_ShohinSyubetsu_Id_exp__c, TotalPrice From OpportunityLineItems),
                                        (	
                                        	SELECT Id FROM KaisyuYoteisOpportunity__r //お客様請求明細 (商談)
                                        	Where SeikyuHouhou__c = 'Partner'
                                        	AND servicesyubetsu__c = 'シンプル安豪'
                                        )
    									from Opportunity where id = :oppIds]);
    }

    private List<SogSok_MitsumoriSho_Torik__c> reloadData(List<SogSok_MitsumoriSho_Torik__c> processData){
        if(processData.size() <= 0 ) return new List<SogSok_MitsumoriSho_Torik__c>();
        return [SELECT
                        Id ,
                        Name ,
                        MitsumoriShoRef__c ,
                        syop_Ref__c ,
                        syop_Soudansha_Sei__c ,
                        syop_Soudansha_Mei__c ,
                        Status__c ,
                        syop_SoudanshaRef__c ,
                        syop_TaishoShaRef__c ,
                        syop_TaishoSha_Shuha_Sonota__c ,
                        syop_TaishoSha_Sei__c ,
                        syop_TaishoSha_Mei__c ,
                        syop_TaishoSha_BirthDate__c ,
                        syop_TaishoSha_DeathDate__c ,
                        syop_TaishoSha_Age__c ,
                        syop_TaishoSha_Addr_PostalCode__c ,
                        syop_TaishoSha_Addr_State__c ,
                        syop_TaishoSha_Addr_City__c ,
                        syop_TaishoSha_Addr_Street__c ,
                        syop_TaishoSha_Jumh_State__c ,
                        syop_TaishoSha_Jumh_City__c ,
                        syop_MoshuRef__c ,
                        syop_Moshu_Sei__c ,
                        syop_Moshu_Mei__c ,
                        syop_Moshu_SeiKana__c ,
                        syop_Moshu_MeiKana__c ,
                        syop_TaishoSha_Shuha__c ,
                        syop_Moshu_Phone__c ,
                        syop_Moshu_Mobile__c ,
                        syop_Moshu_Addr_PostalCode__c ,
                        syop_Moshu_Addr_State__c ,
                        syop_Moshu_Addr_City__c ,
                        syop_Moshu_Addr_Street__c ,
                        syop_TsuyaDateTime__c ,
                        syop_KokubetsuDateTime__c ,
                        syop_ShukkanDateTime__c ,
                        syop_KasoDateTime__c ,
                        syop_SonotaSaijoName__c ,
                        syop_SonotaKasobaName__c ,
                        syop_SogiTantoName__c ,
                        syop_MitsumoriJuryoDate__c ,
                        syop_Ryos_Atena__c ,
                        syop_Ryos_PostalCode__c ,
                        syop_Ryos_State__c ,
                        syop_Ryos_City__c ,
                        syop_Ryos_Street__c ,
                        syop_Moshu_BirthDate__c ,
                        syop_Ryos_RyosyuShoHitsuyo__c ,
                        syop_PlanHenkouUmu__c ,
                        syop_TaishoSha_Bodaiji_Umu__c ,
                        syop_TaishoSha_Gender__c ,
                        syop_Moshu_Gender__c ,
                        syop_MoshuZokugaraFromSoudanSha__c ,
                        syop_SoryoTehaiKiboUmu__c ,
                        syop_KaimyoKiboUmu__c ,
                        syop_Kaimyo__c ,
                        syop_GenkinKingaku__c ,
                        (
                            SELECT 
                                    Id ,
                                    Name ,
                                    Quantity__c,
                                    UnitPrice__c,
                                    Amount__c,
                                    SogSok_MitsumoriSho_TorikRef__c ,
                                    ShohinRef__c,
                                    ShohinRef__r.Name,
                                    ShohinRef__r.Id,
                                    ShohinRef__r.ShohinBango__c,
                                    ShohinRef__r.k_ShohinSyubetsu_Id_exp__c 
                             FROM SogSok_MitsumoriSho_TorikShohins__r
                        )
                 FROM SogSok_MitsumoriSho_Torik__c
                 Where id = :processData
        ];
    }

    private List<OkyakusamaSeikyuMeisai__c> getOkyakusamaSeikyuMeisai(Opportunity aOpp, SogSok_MitsumoriSho_Torik__c toriki){
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