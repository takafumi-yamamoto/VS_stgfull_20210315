public class Ctl_SogSok_Sokyaku {
	public void OnBeforeInsert(List<SogSok_Sokyaku__c> sogSok_Sokyaku_list) {
		SogSokSokyakuBeanBuilder builder = new SogSokSokyakuBeanBuilder();
		Map<Id, Opportunity> oppMap = this.getOppMap(sogSok_Sokyaku_list);
		for(SogSok_Sokyaku__c sokyaku : sogSok_Sokyaku_list){
			builder.add(new SogSokSokyakuBean(sokyaku, oppMap.get(sokyaku.OpportunityRef__c)));
		}
		builder.save();
	}

	public void OnAfterInsert(List<SogSok_Sokyaku__c> sogSok_Sokyaku_list) {
		this.updateSokyakushoBango(sogSok_Sokyaku_list);
	}

	private Map<Id, Opportunity> getOppMap(List<SogSok_Sokyaku__c> sogSok_Sokyaku_list){
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
		Set<Id> oppIds = new Set<Id>();
		for(SogSok_Sokyaku__c sokyaku : sogSok_Sokyaku_list){
			oppIds.add(sokyaku.OpportunityRef__c);
		}
		oppMap = new Map<Id, Opportunity>(new Ctl_SogSok_Sokyaku.OpportunityDao().getByIds(oppIds));
		return oppMap;
	}

	//送客書：送客番号更新
	private void updateSokyakushoBango(List<SogSok_Sokyaku__c> sogSok_Sokyaku_list){
		List<SogSok_SokyakuSho__c> sokyakushoList = new List<SogSok_SokyakuSho__c>();
		for(SogSok_Sokyaku__c sokyaku : sogSok_Sokyaku_list){
			if(String.isNotBlank(sokyaku.SokyakuShoRef__c)){
				sokyakushoList.add(new SogSok_SokyakuSho__c(Id=sokyaku.SokyakuShoRef__c, SokyakuBango__c=sokyaku.Name));
			}
		}
		update sokyakushoList;
	}

	private class SogSokSokyakuBeanBuilder {
		private List<SogSokSokyakuBean> sokyakuBeanList = new List<SogSokSokyakuBean>();

		public void add(SogSokSokyakuBean bean){
			sokyakuBeanList.add(bean);
		}

		public void save(){
			List<Sobject> objList = new List<Sobject>();
			for(SogSokSokyakuBean bean : sokyakuBeanList){
				objList.add(bean.sokyakusho);
			}
			insert objList; //送客書作成

			for(SogSokSokyakuBean bean : sokyakuBeanList){
				bean.setRelation();
			}

			List<SogSok_SokyakuSho_WaribikiLine__c> waribikiLines = new List<SogSok_SokyakuSho_WaribikiLine__c>();
			for(SogSokSokyakuBean bean : sokyakuBeanList){
				waribikiLines.addAll(bean.getWaribkiLines());
			}
			insert waribikiLines; //割引商品を追加

			List<SogSok_SokyakuSho_TsuikaHinLine__c> tsuikaLines = new List<SogSok_SokyakuSho_TsuikaHinLine__c>();
			for(SogSokSokyakuBean bean : sokyakuBeanList){
				tsuikaLines.addAll(bean.getTsuikaLines());
			}
			insert tsuikaLines; //追加商品を追加
		}

	}


	private class SogSokSokyakuBean {
		SogSok_Sokyaku__c sokyaku;
		// SogSok_MitsumoriSho__c mitsumorisho;
		// SogSok_SeikyuSho__c seikyusho;
		SogSok_SokyakuSho__c sokyakusho;
		Keiyaku__c keiyaku;
		Opportunity opp;

		public SogSokSokyakuBean(SogSok_Sokyaku__c sokyaku, Opportunity opp){
			this.sokyaku = sokyaku;
			this.opp = opp;
			// this.mitsumorisho = new SogSok_MitsumoriSho__c();
			// this.seikyusho = new SogSok_SeikyuSho__c();
			this.sokyakusho = new SogSok_SokyakuSho__c();
			this.keiyaku = new Keiyaku__c();
			this.setSokyakusho();
		}

		public List<SogSok_SokyakuSho_WaribikiLine__c> getWaribkiLines(){
			List<SogSok_SokyakuSho_WaribikiLine__c> waribkiLines = new List<SogSok_SokyakuSho_WaribikiLine__c>();
			List<OpportunityLineItem> waribkiitems = this.getWaribikiItems(this.opp.OpportunityLineItems);
			for(OpportunityLineItem item : waribkiitems){
		        SogSok_SokyakuSho_WaribikiLine__c sobj = new SogSok_SokyakuSho_WaribikiLine__c();
		        sobj.ShohinBango__c = item.Product2.ShohinBango__c;    // ShohinBango
		        sobj.Hinmei__c = item.Product2.NameForCustomerExp__c;    // Hinmei
		        sobj.UnitPrice__c = item.UnitPrice;    // UnitPrice
		        sobj.Quantity__c = item.Quantity;    // Quantity
		        sobj.Amount__c = item.TotalPrice;    // Amount
		        sobj.SokyakuShoRef__c = this.sokyakusho.Id;
		        waribkiLines.add(sobj);
			}
			return waribkiLines;
		}

		public List<SogSok_SokyakuSho_TsuikaHinLine__c> getTsuikaLines(){
			List<SogSok_SokyakuSho_TsuikaHinLine__c> tsuikaLines = new List<SogSok_SokyakuSho_TsuikaHinLine__c>();
			List<OpportunityLineItem> tsuikaitems = this.getTsuikaItems(this.opp.OpportunityLineItems);
			String hanbaiKaishibi = this.getHanbaiKaishibi(this.opp.OpportunityLineItems);
			System.debug('Ctl_SogSok_Sokyaku hanbaiKaishibi:' + hanbaiKaishibi);
			for(OpportunityLineItem item : tsuikaitems){
		        SogSok_SokyakuSho_TsuikaHinLine__c sobj = new SogSok_SokyakuSho_TsuikaHinLine__c();
				sobj.Amount__c = item.TotalPrice;    // Amount
		        sobj.Hinmei__c = item.Product2.NameForCustomerExp__c;    // Hinmei
                sobj.HinmokuBunrui__c = Sogsok_TsuikaHinBunrui_201101.tryGetKeyFromShohinCd(item.Product2.ShohinBango__c);    // Hinmei
				sobj.Quantity__c = item.Quantity;    // Quantity
				sobj.SokyakuShoRef__c = this.sokyakusho.Id;
				sobj.UnitPrice__c = item.UnitPrice;    // UnitPrice
				sobj.ShohinBango__c = item.Product2.ShohinBango__c;
		        tsuikaLines.add(sobj);
			}
			return tsuikaLines;
		}

		//送客書値を設定
		private void setSokyakusho(){
			SimpleYasugo__c simple = opp.SimpleYasugoRef__r;
			OpportunityLineItem mainitem = this.getMainItem(opp.OpportunityLineItems);

			sokyaku.SoukyakuSakiKeiyakuRef__c = simple.SimpleYasugoKeiyakuRef__c;

			//商談値⇒送客書に設定する
			//ヘッダ
			sokyakusho.ShodanBango__c = opp.ShodanBangoF__c;
			//sokyakusho.SoukyakuDate__c = Date.Today();
			//葬儀プラン
	        sokyakusho.SogiPlan_KiboArea__c = simple.KiboAreaRef__r.Name;
	        sokyakusho.SogiPlan_ShohinBango__c = mainitem == null ? null : mainitem.Product2.ShohinBango__c;
	        sokyakusho.SogiPlan_PlanName__c = mainitem == null ? null : mainitem.Product2.NameForCustomerExp__c;
	        sokyakusho.SogiPlan_ServiceId__c = mainitem == null ? null : mainitem.Product2.k_Service_Id_exp__c;
			sokyakusho.SogiPlan_Amount__c = mainitem == null ? null : mainitem.TotalPrice;
			sokyakusho.ButsuguNashiKibo__c = resolveButsuguumu(simple.ButsuguNashiKibo__c);
	        sokyakusho.SoryoTehai_KiboUmu__c = simple.MonkArrangements__c;
			sokyakusho.SoryoTehai_Kaimyo__c = new SogSok_Kaimyo().tryGetKeyFromSimpleYasugoKaimyo(simple.Kaimyo__c);
			
	        //支払
	        sokyakusho.Shiharai_MaeukeKingaku__c = simple.ReportMaeukekin__c;
	        sokyakusho.Shiharai_KiboShiharaiHoho__c = opp.KiboShiharaiHouhou__c == '後払い（GMO）' ? '後払い' : opp.KiboShiharaiHouhou__c;

			//支払者
			sokyakusho.Shiharaisha_Name__c = opp.RyosyuAtena__c;
			sokyakusho.ShiharaiSha_RyosyuAtena__c = opp.RyosyuAtena__c;
			sokyakusho.ShiharaiSha_Mail__c = opp.RyosyuAtenaIsSodansha__c ? opp.Account.MailAddress__c : null;
			sokyakusho.ShiharaiSha_Addr_PostalCode__c = opp.RyosyuSoufuPostalCode__c;
			sokyakusho.ShiharaiSha_Addr_State__c = opp.RyosyuSoufuSakiState__c;
			sokyakusho.ShiharaiSha_Addr_City__c = opp.RyosyuSoufuSakiCity__c;
			sokyakusho.ShiharaiSha_Addr_Street__c = opp.RyosyuSoufuSakiStreet__c;

			// よりそうオプション希望
			sokyakusho.SaidanKibo__c = simple.SaidanKibo__c;
			sokyakusho.KagobanaKibo__c = simple.KagobanaKibo__c;
			sokyakusho.KanjoHanatabaKibo__c = simple.KanjoHanatabaKibo__c;
			sokyakusho.MakurabanaKibo__c = simple.MakurabanaKibo__c;

	        //送客先
	        sokyakusho.SoukyakuSaki_KeiyakuBango__c = simple.SimpleYasugoKeiyakuRef__r.KeiyakuBango__c;
	        sokyakusho.Soukyakusaki_TorihikisakiBango__c = simple.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.TorihikisakiBangoF__c;
	        sokyakusho.SoukyakuSaki_TorihikiSakiName__c = simple.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name;
			sokyakusho.SoukyakuSaki_Tantosha_Fax__c = 
				TelNos.isTelNo(simple.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Fax) 
				? TelNos.toNumber(simple.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Fax)
				: null;
			sokyakusho.SoukyakuSak_FaxSoufu__c = simple.SimpleYasugoKeiyakuRef__r.IsSoukyakujiFax__c;
	        //相談者
	        sokyakusho.SodanSha_TorihikiSakiBango__c = opp.Account.TorihikisakiBangoF__c;
	        sokyakusho.SodanSha_Sei__c = opp.Account.LastName;
	        sokyakusho.SodanSha_Mei__c = opp.Account.FirstName;
	        sokyakusho.SodanSha_SeiKana__c = opp.Account.LastNameFurigana__pc;
	        sokyakusho.SodanSha_MeiKana__c = opp.Account.FirstNameFurigana__pc;
	        sokyakusho.SodanSha_Phone__c = opp.Account.Phone;
	        sokyakusho.SodanSha_Mobile__c = opp.Account.MobilePhone__c;
	        sokyakusho.SodanSha_Addr_State__c = opp.Account.BillingState;
	        sokyakusho.SodanSha_Addr_City__c = opp.Account.BillingCity;
	        sokyakusho.SodanSha_Addr_Street__c = opp.Account.BillingStreet;
	        sokyakusho.SodanSha_Addr_PostalCode__c = opp.Account.BillingPostalCode;
	        //対象者
	        sokyakusho.TaishoSha_TorihikiSakiBango__c = opp.TaishosyaRef__r.TorihikisakiBangoF__c;
	        sokyakusho.TaishoSha_ZokugaraFromSoudanSha__c = 
				new SogSok_Zokugara().tryGetKeyFromSimpleYasugoTaishoshaZokugara(simple.ZokugaraSodanshaNitottenoTaishosha__c);
			sokyakusho.TaishoSha_ZokugaraFromMoshu__c = 
				new SogSok_Zokugara().tryGetKeyFromSimpleYasugoTaishoshaZokugara(simple.ZokugaraMoshuNitottenoTaishosha__c);
	        sokyakusho.TaishoSha_Sei__c = opp.TaishosyaRef__r.LastName;
	        sokyakusho.TaishoSha_Mei__c = opp.TaishosyaRef__r.FirstName;
	        sokyakusho.TaishoSha_SeiKana__c = opp.TaishosyaRef__r.LastNameFurigana__pc;
	        sokyakusho.TaishoSha_MeiKana__c = opp.TaishosyaRef__r.FirstNameFurigana__pc;
	        sokyakusho.TaishoSha_BirthDate__c = opp.TaishosyaRef__r.PersonBirthdate;
	        sokyakusho.TaishoSha_DeathDate__c = opp.TaishosyaRef__r.PersonDeathDate__pc;
	        sokyakusho.TaishoSha_Age__c = opp.TaishosyaRef__r.Age__pc;
	        sokyakusho.TaishoSha_Gender__c = new SogSok_Gender().tryGetKeyFromCustomerAccountGender(opp.TaishosyaRef__r.Gender__pc);
	        sokyakusho.TaishoSha_Addr_PostalCode__c = opp.TaishosyaRef__r.BillingPostalCode;
	        sokyakusho.TaishoSha_Addr_State__c = opp.TaishosyaRef__r.BillingState;
	        sokyakusho.TaishoSha_Addr_City__c = opp.TaishosyaRef__r.BillingCity;
	        sokyakusho.TaishoSha_Addr_Street__c = opp.TaishosyaRef__r.BillingStreet;
			sokyakusho.TaishoSha_JumHyo_State__c = opp.TaishosyaRef__r.JuminhyouState__c;
			sokyakusho.TaishoSha_JumHyo_City__c = opp.TaishosyaRef__r.JuminhyouCity__c;
			sokyakusho.TaishoSha_Shushi__c = Sogsok_ShushiShuha.tryGetShushiFromCustomerAccountShuha(opp.TaishosyaRef__r.Syuha__c,null);
			sokyakusho.TaishoSha_Shuha__c = Sogsok_ShushiShuha.tryGetShuhaFromCustomerAccountShuha(opp.TaishosyaRef__r.Syuha__c,null);
			sokyakusho.TaishoSha_Shuha_Sonota__c = 
				String.isBlank(opp.TaishosyaRef__r.SonotanoSyukyoSyuha__c) 
				? ''
				: opp.TaishosyaRef__r.SonotanoSyukyoSyuha__c;

	        sokyakusho.TaishoSha_BodaijiUmu__c = new SogSok_BodaijiUmu().tryGetKeyFromCustomerAccountBodaijiUmu(opp.TaishosyaRef__r.BodaijinoUmu__c);
	        //お迎え先
	        sokyakusho.OmukaeSaki_Name__c = simple.OmukaeSakiName__c;
	        sokyakusho.OmukaeSaki_Addr_Street__c = simple.OmukaeSakiStreet__c;
	        sokyakusho.AnchiSaki__c = String.join(new String[]{
	        										String.isNotBlank(simple.KiboGoanchisaki__c) ? simple.KiboGoanchisaki__c : '',
	        										String.isNotBlank(simple.GoanchisakiJusho__c) ? simple.GoanchisakiJusho__c : ''
										        }, '　');

	        //喪主
	        sokyakusho.Moshu_TorihikiSakiBango__c = opp.MosyuRef__r.TorihikisakiBangoF__c;
	        sokyakusho.Moshu_Sei__c = opp.MosyuRef__r.LastName;
	        sokyakusho.Moshu_Mei__c = opp.MosyuRef__r.FirstName;
	        sokyakusho.Moshu_SeiKana__c = opp.MosyuRef__r.LastNameFurigana__pc;
	        sokyakusho.Moshu_MeiKana__c = opp.MosyuRef__r.FirstNameFurigana__pc;
	        sokyakusho.Moshu_Addr_State__c = opp.MosyuRef__r.BillingState;
	        sokyakusho.Moshu_Addr_City__c = opp.MosyuRef__r.BillingCity;
	        sokyakusho.Moshu_Addr_Street__c = opp.MosyuRef__r.BillingStreet;
	        sokyakusho.Moshu_Addr_PostalCode__c = opp.MosyuRef__r.BillingPostalCode ;
	        sokyakusho.Moshu_Mobile__c = opp.MosyuRef__r.MobilePhone__c ;
	        sokyakusho.Moshu_Phone__c = opp.MosyuRef__r.Phone;
			sokyakusho.Moshu_BirthDate__c = opp.MosyuRef__r.PersonBirthdate;
			sokyakusho.Moshu_Gender__c = opp.MosyuRef__r.Gender__pc;
			sokyakusho.Moshu_ZokugaraFromSoudanSha__c = 
				new SogSok_Zokugara().tryGetKeyFromSimpleYasugoTaishoshaZokugara(simple.ZokugaraSodanshaKaramitaMoshu__c);
	        //連絡事項
	        sokyakusho.RenrakuJiko__c = simple.SokyakushoKisaiJiko__c;

		}

		public void setRelation(){
			// this.sokyaku.MitsumoriShoRef__c = this.mitsumorisho.Id;
			// this.sokyaku.SeikyuShoRef__c = this.seikyusho.Id;
			this.sokyaku.SokyakuShoRef__c = this.sokyakusho.Id; //送客書と送客を紐づく
		}

		private OpportunityLineItem getMainItem(List<OpportunityLineItem> items){
			if(items != null){
				for(OpportunityLineItem item : items){
					if((item.Product2.k_Service_Id_exp__c == '1' || item.Product2.k_Service_Id_exp__c == '2') && item.Product2.k_ShohinSyubetsu_Id_exp__c == '1')
						return item;
				}
			}
		 	return new OpportunityLineItem();
		}

		private List<OpportunityLineItem> getWaribikiItems(List<OpportunityLineItem> items){
			List<OpportunityLineItem> waribikiItems = new List<OpportunityLineItem>();
			if(items != null){
				for(OpportunityLineItem item : items){
					if((item.Product2.k_Service_Id_exp__c == '1' || item.Product2.k_Service_Id_exp__c == '2') && item.Product2.k_ShohinSyubetsu_Id_exp__c == '6')
						waribikiItems.add(item);
				}
			}
		 	return waribikiItems;
		}

		private List<OpportunityLineItem> getTsuikaItems(List<OpportunityLineItem> items){
			List<OpportunityLineItem> tsuikaItems = new List<OpportunityLineItem>();
			if(items != null){
				for(OpportunityLineItem item : items){
					if((item.Product2.k_Service_Id_exp__c == '1' || item.Product2.k_Service_Id_exp__c == '2') && (item.Product2.k_ShohinSyubetsu_Id_exp__c == '3' || item.Product2.k_ShohinSyubetsu_Id_exp__c == '4'))
						tsuikaItems.add(item);
				}
			}
		 	return tsuikaItems;
		}

		private String getHanbaiKaishibi(List<OpportunityLineItem> items){
			String hanbaiKaishibi = '';
			if(items != null){
				for(OpportunityLineItem item : items){
					if((item.Product2.k_Service_Id_exp__c == '1' || item.Product2.k_Service_Id_exp__c == '2') && item.Product2.k_ShohinSyubetsu_Id_exp__c == '1'){
						if(item.Product2.HanbaiKaishiBi__c >= date.newInstance(2020, 11, 1)){
							hanbaiKaishibi = '20201101';
						}
						else if(item.Product2.HanbaiKaishiBi__c >= date.newInstance(2019, 9, 30)){
							hanbaiKaishibi = '20190930';
						}
						else{
							hanbaiKaishibi = '20170101';
						}
					}
				}
			}
		 	return hanbaiKaishibi;
		}
	
		private String resolveButsuguumu(String val){
			if(val == '仏具あり' || val == '仏具なし') return val;
			return '';
		}
	}


    /**
    * 新規お客様請求明細画面用データ
    * サービス商談IDを指定して、関するデータを取得する
    */
    private class OpportunityDao {
    	public List<Opportunity> getByIds(Set<Id> oppIds){
    		List<Opportunity> oppList =	[select 
												Id,				//商談 ID
												//ヘッダ
												ShodanBangoF__c,
												//葬儀プラン
										        SimpleYasugoRef__r.KiboAreaRef__r.Name,
										        SimpleYasugoRef__r.SogiPlanUketsuke__c,
										        SimpleYasugoRef__r.GoanchiMenkaiKiboUmu__c,
												SimpleYasugoRef__r.MonkArrangements__c,
												SimpleYasugoRef__r.ButsuguNashiKibo__c,
												SimpleYasugoRef__r.Kaimyo__c,
										        //支払
										        SimpleYasugoRef__r.ReportMaeukekin__c,
										        KiboShiharaiHouhou__c,
												//支払い者
												RyosyuAtena__c,
												RyosyuAtenaIsSodansha__c,
												Account.MailAddress__c,
												RyosyuSoufuPostalCode__c,
												RyosyuSoufuSakiState__c,
												RyosyuSoufuSakiCity__c,
												RyosyuSoufuSakiStreet__c,
												//よりそうオプション希望
												SimpleYasugoRef__r.SaidanKibo__c,
												SimpleYasugoRef__r.KagobanaKibo__c,
												SimpleYasugoRef__r.KanjoHanatabaKibo__c,
												SimpleYasugoRef__r.MakurabanaKibo__c,
										        //送客先
										        SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.KeiyakuBango__c,
												SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.IsSoukyakujiFax__c,
										        SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.TorihikisakiBangoF__c,
										        SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name,
												SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Fax,
										        //相談者
										        Account.TorihikisakiBangoF__c,
										        Account.LastName,
										        Account.FirstName,
										        Account.LastNameFurigana__pc,
										        Account.FirstNameFurigana__pc,
										        Account.Phone,
										        Account.MobilePhone__c,
										        Account.BillingState,
										        Account.BillingCity,
										        Account.BillingStreet,
										        Account.BillingPostalCode,
										        //対象者
										        TaishosyaRef__r.TorihikisakiBangoF__c,
										        SimpleYasugoRef__r.ZokugaraSodanshaNitottenoTaishosha__c,
												SimpleYasugoRef__r.ZokugaraMoshuNitottenoTaishosha__c,
												SimpleYasugoRef__r.ZokugaraSodanshaKaramitaMoshu__c,
										        TaishosyaRef__r.LastName,
										        TaishosyaRef__r.FirstName,
										        TaishosyaRef__r.LastNameFurigana__pc,
										        TaishosyaRef__r.FirstNameFurigana__pc,
										        TaishosyaRef__r.PersonBirthdate,
												TaishosyaRef__r.PersonDeathDate__pc,
												// TaishosyaRef__r.Seinengappi__c,
										        // TaishosyaRef__r.Botsunengappi__pc,
										        TaishosyaRef__r.Age__pc,
										        TaishosyaRef__r.Gender__pc,
										        TaishosyaRef__r.BillingPostalCode,
										        TaishosyaRef__r.BillingState,
										        TaishosyaRef__r.BillingCity,
										        TaishosyaRef__r.BillingStreet,
												TaishosyaRef__r.JuminhyouState__c,
												TaishosyaRef__r.JuminhyouCity__c,
										        TaishosyaRef__r.Syuha__c,
												TaishosyaRef__r.SonotanoSyukyoSyuha__c,
										        TaishosyaRef__r.BodaijinoUmu__c,
										        //お迎え先
										        SimpleYasugoRef__r.OmukaeSakiName__c,
										        SimpleYasugoRef__r.OmukaeSakiCity__c,
										        SimpleYasugoRef__r.OmukaeSakiState__c,
										        SimpleYasugoRef__r.OmukaeSakiStreet__c,
										        SimpleYasugoRef__r.OmukaeSakiZipcode__c,
										        SimpleYasugoRef__r.KiboGoanchisaki__c,
										        SimpleYasugoRef__r.GoanchisakiJusho__c,
												//喪主
												MosyuRef__r.TorihikisakiBangoF__c,
										        MosyuRef__r.LastNameFurigana__pc,
										        MosyuRef__r.FirstNameFurigana__pc,
										        MosyuRef__r.LastName,
										        MosyuRef__r.FirstName,
										        MosyuRef__r.BillingState,
										        MosyuRef__r.BillingCity,
										        MosyuRef__r.BillingStreet,
										        MosyuRef__r.BillingPostalCode ,
										        MosyuRef__r.MobilePhone__c ,
										        MosyuRef__r.Phone ,
												MosyuRef__r.PersonBirthdate,
												MosyuRef__r.Gender__pc,
										        //連絡事項
										        SimpleYasugoRef__r.SokyakushoKisaiJiko__c,
										        (
													Select id, TotalPrice, Quantity, UnitPrice,
															Product2.Name, 
															Product2.NameForCustomerExp__c,
															Product2.k_Service_Id_exp__c,
															Product2.ShohinBango__c, 
															Product2.ProductCode,
															Product2.HanbaiKaishiBi__c,
															Product2.k_ShohinSyubetsu_Id_exp__c
													From OpportunityLineItems
													Where (Product2.k_Service_Id_exp__c = '1'
												        	OR Product2.k_Service_Id_exp__c = '2' )
													// AND (Product2.k_ShohinSyubetsu_Id_exp__c = '1'
													// 		OR Product2.k_ShohinSyubetsu_Id_exp__c = '6'
													// 	)
												)
											from Opportunity
											Where Id = :oppIds
										];
			return oppList;
    	}
	}

}