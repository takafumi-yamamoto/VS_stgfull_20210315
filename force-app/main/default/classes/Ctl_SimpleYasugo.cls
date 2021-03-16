public class Ctl_SimpleYasugo {

	private static ID nullAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();

    public void chkInputRules(List<SimpleYasugo__c> newList, Map<ID, SimpleYasugo__c> oldMap){
        List<Opportunity> oppList = sltOpportunitysByIds(newList);
        Map<Id, Opportunity> simplIdOppValueMap = new Map<Id, Opportunity>();
        for(Opportunity opp : oppList){
            simplIdOppValueMap.put(opp.SimpleYasugoRef__c, opp);
        }

        List<Account> upAccList = new List<Account>();
        for(SimpleYasugo__c simple : newList){
            Boolean errFlg = false;
            Opportunity tempOpp = simplIdOppValueMap.get(simple.Id);
            SimpleYasugo__c tempSimp = oldMap.get(simple.Id);
            if(tempOpp.StageName == '決定' && tempOpp.KiboShiharaiHouhou__c == null){
                simple.addError('【フェーズ】が「決定」の時は【希望支払方法】を入力してください。');
            }

            if(tempSimp.JizenJunbiSheetGoteishutsuShudan__c != simple.JizenJunbiSheetGoteishutsuShudan__c && 
                simple.JizenJunbiSheetGoteishutsuShudan__c == '代理入力' && simple.JizenJunbiSheetDairiNyuryokuTantoshaRef__c == null){
                simple.addError('【事前準備シートご提出手段】が「代理入力」の時は【事前準備シート代理入力担当者】を入力してください。');
            }

            if(chkJizenJunbiSheetJuryobi(tempOpp, simple, tempSimp)){
				// issues4156 --Start--
				// エラーメッセージの変更
				simple.addError(System.Label.chkJizenJunbiSheetJuryobiMessage);
				// issues4156 --end--
                errFlg = true;
			}

			// issues4156 --Start--
			if(simple.PreliminaryConsultationDate__c != null){
				simple.JizenJunbiSheetGoannaiJokyo__c = '受領';
			}
			// issues4156 --end--

            if(!errFlg && simple.PreliminaryConsultationDate__c != null && tempSimp.PreliminaryConsultationDate__c == null){
                upAccList.add(new Account(Id = tempOpp.AccountId, JizenJizenSheetTeishutsuzumi__c = true));
            }
        }

        update upAccList;
    }

    private Boolean chkJizenJunbiSheetJuryobi(Opportunity opp, SimpleYasugo__c newSimple, SimpleYasugo__c oldSimple){

		if(oldSimple.PreliminaryConsultationDate__c != newSimple.PreliminaryConsultationDate__c && 
			newSimple.PreliminaryConsultationDate__c != null && 
			opp.Account.RecordTypeId != nullAccRecordTypeId && 
			!opp.Account.MemberTourokuZumi__c){
				return true;
		}

		return false;
	}

    public void simpleYasugoValuesSet(List<SimpleYasugo__c> newList, Map<ID, SimpleYasugo__c> oldMap){

        for(SimpleYasugo__c simpleYasugo : newList){

            if(simpleYasugo.MailShiryoSofubi__c != null && (oldMap == null || simpleYasugo.MailShiryoSofubi__c != oldMap.get(simpleYasugo.Id).MailShiryoSofubi__c)){
                simpleYasugo.ShiryoSofuNichiji__c = simpleYasugo.MailShiryoSofubi__c;
            }
            else if(simpleYasugo.YubinShiryoSofubi__c != null && (oldMap == null || simpleYasugo.YubinShiryoSofubi__c != oldMap.get(simpleYasugo.Id).YubinShiryoSofubi__c)){
                simpleYasugo.ShiryoSofuNichiji__c = simpleYasugo.YubinShiryoSofubi__c;
            }
            else if(simpleYasugo.FaxShiryoSofubi__c != null && (oldMap == null || simpleYasugo.FaxShiryoSofubi__c != oldMap.get(simpleYasugo.Id).FaxShiryoSofubi__c)){
                simpleYasugo.ShiryoSofuNichiji__c = simpleYasugo.FaxShiryoSofubi__c;
            }

            if(simpleYasugo.X3CallJishiKekka__c != null && (oldMap == null || simpleYasugo.X3CallJishiKekka__c != oldMap.get(simpleYasugo.Id).X3CallJishiKekka__c)){
                if(simpleYasugo.X3CallJishiKekka__c != '対象外' && simpleYasugo.X3CallJishiKekka__c != '未実施'){
                    simpleYasugo.X3CallJishiTantosha__c = UserInfo.getUserId();
                    simpleYasugo.X3CallJishibi__c = date.today();
                }
            }
        }
    }

    public void setSearchTxt(List<SimpleYasugo__c> newList, Map<ID, SimpleYasugo__c> oldMap){
        List<Id> accIds = new List<Id>();
        List<Id> taisyoushaSimpleIds = new List<Id>();
        List<Id> moshuSimpleIds = new List<Id>();
        Map<Id, Id> simpleTaisyoushaMap = new Map<Id, Id>();
        Map<Id, Id> simpleMoshuMap = new Map<Id, Id>();
        
        for(SimpleYasugo__c simpleYasugo : newList){

            if(simpleYasugo.TaishoshaRef__c != null && (oldMap == null || simpleYasugo.TaishoshaRef__c != oldMap.get(simpleYasugo.Id).TaishoshaRef__c)){
                // opp の検索用データ更新対象
                accIds.add(simpleYasugo.TaishoshaRef__c);
                taisyoushaSimpleIds.add(simpleYasugo.Id);
                simpleTaisyoushaMap.put(simpleYasugo.Id, simpleYasugo.TaishoshaRef__c);
            }
            if(simpleYasugo.MoshuRef__c != null && (oldMap == null || simpleYasugo.MoshuRef__c != oldMap.get(simpleYasugo.Id).MoshuRef__c)){
                // opp の検索用データ更新対象
                accIds.add(simpleYasugo.MoshuRef__c);
                moshuSimpleIds.add(simpleYasugo.Id);
                simpleMoshuMap.put(simpleYasugo.Id, simpleYasugo.MoshuRef__c);
            }
        }

        List<Account> accList = Dao_Account.getInstance().selectByIds(accIds);
        Map<Id, Account> accountMap = new Map<Id, Account>(accList);
        List<Opportunity> oppTaisyouUpdate = Dao_Opportunity.getInstance().selectBySimpleYasugoIds(taisyoushaSimpleIds);
        List<Opportunity> oppMoshuUpdate = Dao_Opportunity.getInstance().selectBySimpleYasugoIds(moshuSimpleIds);
        List<Opportunity> oppForUpdate = new List<Opportunity>();
        for(Opportunity opp : oppTaisyouUpdate){
            Id accId = simpleTaisyoushaMap.get(opp.SimpleYasugoRef__c);

            if(accountMap.containsKey(accId)){
                Account acc = accountMap.get(accId);
                Opportunity tmpopp = new Opportunity(Id=opp.Id);
                tmpopp.TaisyousyaNameTxt__c = acc.Name;    // 対象者氏名(検索用)
                tmpopp.TaisyousyaFurigana__c = acc.NameFurigana__c;    // 対象者氏名カナ(検索用)
                tmpopp.TaisyousyaPhone__c = acc.Phone;    // 対象者電話番号(検索用)
                tmpopp.TaisyousyaMobilePhone__c = acc.MobilePhone__c;    // 対象者携帯番号(検索用)
                oppForUpdate.add(tmpopp);
            }
        }
        update oppForUpdate;
        oppForUpdate = new List<Opportunity>();
        for(Opportunity opp : oppMoshuUpdate){
            Id accId = simpleMoshuMap.get(opp.SimpleYasugoRef__c);

            if(accountMap.containsKey(accId)){
                Account acc = accountMap.get(accId);
                Opportunity tmpopp = new Opportunity(Id=opp.Id);
                tmpopp.MosyuNameTxt__c = acc.Name;    // 対象者氏名(検索用)
                tmpopp.MosyuFuriganaTxt__c = acc.NameFurigana__c;    // 対象者氏名カナ(検索用)
                tmpopp.MosyuPhoneTxt__c = acc.Phone;    // 対象者電話番号(検索用)
                tmpopp.MosyuMobilePhoneTxt__c = acc.MobilePhone__c;    // 対象者携帯番号(検索用)
                oppForUpdate.add(tmpopp);
            }
        }
        update oppForUpdate;
    }

    public void setSearchTxtKetteisaki(List<SimpleYasugo__c> newList, Map<ID, SimpleYasugo__c> oldMap){
        
        List<Id> serviceOppIds = new List<Id>();

        for(SimpleYasugo__c aNewOne : newList){
            SimpleYasugo__c aOldOne = oldMap.get(aNewOne.Id);
            if(aNewOne.SimpleYasugoKeiyakuRef__c != aOldOne.SimpleYasugoKeiyakuRef__c){
                serviceOppIds.add(aNewOne.Id);
            }
        }
        if(serviceOppIds.size() > 0 ){
            List<Opportunity> oppTaisyouUpdate = Dao_Opportunity.getInstance().selectBySimpleYasugoIds(serviceOppIds);
            List<Opportunity> oppForUpdate = new List<Opportunity>();
            for(Opportunity opp : oppTaisyouUpdate){
                Opportunity tmpopp = new Opportunity(Id=opp.Id);
                tmpopp.KetteiSakiRef__c = opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c;    
                tmpopp.KetteiSakiKanaSerch__c = opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.NameYagouFurigana__c;    
                tmpopp.KetteiSakiDenwaBangoSearch__c = opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Phone;    
                oppForUpdate.add(tmpopp);
            }
            update oppForUpdate;
        }
    }


    /*public void togetsuSokyakuSuSet(List<SimpleYasugo__c> newList, Map<ID, SimpleYasugo__c> oldMap){

        List<ID> keiyakuIdList = new List<ID>();
        List<ID> simpleYasugoIdList = new List<ID>();
        for(SimpleYasugo__c simpleYasugo : newList){

            if(simpleYasugo.SimpleYasugoKeiyakuRef__c != null && (oldMap == null || simpleYasugo.SimpleYasugoKeiyakuRef__c != oldMap.get(simpleYasugo.Id).SimpleYasugoKeiyakuRef__c)){
                keiyakuIdList.add(simpleYasugo.SimpleYasugoKeiyakuRef__c);
                simpleYasugoIdList.add(simpleYasugo.Id);
            }
        }

        List<Keiyaku__c> sltKeiyakuList = Dao_Keiyaku.getListByIds(keiyakuIdList);
        Map<ID, SimpleYasugo__c> sltSimpleYasugoMap = Dao_SimpleYasugo.getMapByIds(simpleYasugoIdList);

        List<Keiyaku__c> updateKeiyakuList = new List<Keiyaku__c>();

        for(Keiyaku__c sltKeiyaku : sltKeiyakuList){
            Integer sokyakusu = 0;
            List<Keiyaku__c> tokuyakutenKeiyakuList = sltKeiyaku.KeiyakusSyuKeiyaku__r;
            Keiyaku__c tempTokuyakutenKeiyaku = new Keiyaku__c();
            if(tokuyakutenKeiyakuList.size() == 1){
                tempTokuyakutenKeiyaku = tokuyakutenKeiyakuList.get(0);
                List<SimpleYasugo__c> sltSimpleYasugoList = sltKeiyaku.KeiyakusSimpleYasugoKeiyaku__r;
                for(SimpleYasugo__c sltSimpleYasugo : sltSimpleYasugoList){
                    SimpleYasugo__c tempSimpleYasugo = sltSimpleYasugoMap.get(sltSimpleYasugo.Id);
                    sokyakusu += tempSimpleYasugo.OpportunitysSimpleYasugo__r.size();
                }
            }
            tempTokuyakutenKeiyaku.TogetsuSokyakusu__c = sokyakusu;
            updateKeiyakuList.add(tempTokuyakutenKeiyaku);
        }
    }*/
    public void CopyTaisyoushaInfoToOpportunityForGloabalSearch(List<Opportunity> oppTaisyouUpdatedList,Map<Id, Account> SimpleYasugoTaisyoushaMap){
        list<Opportunity> UpdateOpportunityList =new list<Opportunity>();
        for(Opportunity opp : oppTaisyouUpdatedList){
            Account acc = SimpleYasugoTaisyoushaMap.get(opp.SimpleYasugoRef__c);
            Opportunity tmpopp = new Opportunity(Id=opp.Id); 
            tmpopp.TaisyousyaNameTxt__c = acc.LastName+' '+acc.FirstName;    // 対象者氏名(検索用)
            tmpopp.TaisyousyaFurigana__c = acc.NameFurigana__c;    // 対象者氏名カナ(検索用)
            tmpopp.TaisyousyaPhone__c = acc.Phone;    // 対象者電話番号(検索用)
            tmpopp.TaisyousyaMobilePhone__c = acc.MobilePhone__c;    // 対象者携帯番号(検索用)    
            UpdateOpportunityList.add(tmpopp);
        }
        update UpdateOpportunityList;
    }   
    public void CopyMoshuInfoToOpportunityForGloabalSearch(List<Opportunity> oppMoshuUpdatedList,Map<Id, Account> SimpleYasugoMoshuMap){
        list<Opportunity> UpdateOpportunityList =new list<Opportunity>();
        for(Opportunity opp : oppMoshuUpdatedList){
            Account acc = SimpleYasugoMoshuMap.get(opp.SimpleYasugoRef__c);
            Opportunity tmpopp = new Opportunity(Id=opp.Id); 
            tmpopp.MosyuNameTxt__c = acc.LastName+' '+acc.FirstName;    // 対象者氏名(検索用)
            tmpopp.MosyuFuriganaTxt__c = acc.NameFurigana__c;    // 対象者氏名カナ(検索用)
            tmpopp.MosyuPhoneTxt__c = acc.Phone;    // 対象者電話番号(検索用)
            tmpopp.MosyuMobilePhoneTxt__c = acc.MobilePhone__c;    // 対象者携帯番号(検索用)  
            UpdateOpportunityList.add(tmpopp);
        }
        update UpdateOpportunityList;
    }

    public List<Opportunity> sltOpportunitysByIds(List<SimpleYasugo__c> newList){
        return [select Id, 
                        Name, 
                        StageName, 
                        SimpleYasugoRef__c, 
                        CaseRef__r.Origin, 
                        CaseRef__r.TaishoushaJokyo__c, 
                        Account.RecordTypeId, 
						Account.MemberTourokuZumi__c,
						// issues4156 --Start-- 
                        KiboShiharaiHouhou__c, 
						AccountId
						// issues4156 --end--
                from Opportunity
                where SimpleYasugoRef__c = :newList];
    }
}