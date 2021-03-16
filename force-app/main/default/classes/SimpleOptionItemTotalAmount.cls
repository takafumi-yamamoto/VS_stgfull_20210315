global class SimpleOptionItemTotalAmount{
	
	@future
    public static void doSimpleOptionItemTotalAmountCalculation(String aOpportunityId){

		Opportunity aOpportunity = [select
										Id, 
										ShodanBango__c, 
										SimpleYasugoRef__c,
										SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, 
										(
											select
												Id,
												HinmokuBunrui__c,
												Product2.NameForCustomerExp__c,
												Product2.ShohinBango__c,
												TotalPrice,
												Product2.k_ShohinCategory_Id_exp__c, 
												Product2.DataKubun__c,
												Product2.k_Coupon_Id_exp__c
											from OpportunityLineItems
											where HinmokuBunrui__c != null
											// 以下、支払通知書の「メンバー　WEB事前準備シート記入割引」対応、k_Coupon_Id_exp__c : '1' は「メンバー　WEB事前準備シート記入割引」
											or (Product2.DataKubun__c = '3:クーポン' and Product2.k_Coupon_Id_exp__c = '1')
										)
									from Opportunity
									where Id = :aOpportunityId 
									];

		Keiyaku__c aPartnerKeiyaku = [select 
											Id, 
											KeiyakuBango__c, 
											(select 
												Id, 
												RyoriTesuryoAri__c, 
												HenreihinTesuryoAri__c, 
												UrnOptionTesuryoFlg__c, 
												YorisoOptionFlowersTesuryoFlg__c, 
												OptionTesuryoAri__c 
											from Keiyaku_TesuryoTekiyos__r 
											where ShoninStatus__c = '承認済' 
											and TekiyoKaishiBi__c <= :date.today() 
											and TekiyoSyuryoBi__c >= :date.today()
											)
										from Keiyaku__c 
										where Id = :aOpportunity.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c
										];

		Boolean tesuryoTekiyoRyori = false;
		Boolean tesuryoTekiyoHenreihin = false;
		Boolean tesuryoTekiyoKotsutsubo = false;
		Boolean tesuryoTekiyoYorisoOption = false;
		Boolean tesuryoTekiyoSogishaOption = false;
		if(aPartnerKeiyaku.Keiyaku_TesuryoTekiyos__r.size() != 1){
			Loggings.writeLog(
            	Loggings.createLogEntry(Loggings.Level.Error, '202000401-1833-01', 'OptionTesuryoTekiyo', '有効な手数料適用がない、または複数存在します')
                   .putAttr('契約番号', aPartnerKeiyaku.KeiyakuBango__c)
                   .putAttr('商談番号', aOpportunity.ShodanBango__c)
        	);
		}
		else{	
			TesuryoTekiyo__c aTesuryoTekiyo = aPartnerKeiyaku.Keiyaku_TesuryoTekiyos__r.get(0);
			tesuryoTekiyoRyori = aTesuryoTekiyo.RyoriTesuryoAri__c;
			tesuryoTekiyoHenreihin = aTesuryoTekiyo.HenreihinTesuryoAri__c;
			tesuryoTekiyoKotsutsubo = aTesuryoTekiyo.UrnOptionTesuryoFlg__c;
			tesuryoTekiyoYorisoOption = aTesuryoTekiyo.YorisoOptionFlowersTesuryoFlg__c;
			tesuryoTekiyoSogishaOption = aTesuryoTekiyo.OptionTesuryoAri__c;
		}

		String hontai = '';
		Decimal henreihin = 0;
		Decimal ryori = 0;
		Decimal lastmake = 0;
		Decimal makedress = 0;
		Decimal yukan = 0;
		Decimal makurabana = 0;
		Decimal kanjohanataba = 0;
		Decimal owakarebana = 0;
		Decimal kyoka = 0;
		Decimal ieishashin = 0;
		Decimal kanban = 0;
		Decimal gaisosetsubitsuika = 0;
		Decimal kotsutsuborankup = 0;
		Decimal hitsugi = 0;
		Decimal jimutesuryo = 0;
		Decimal webjizenwaribiki = 0;
		Decimal saidan = 0;
		Decimal embalming = 0;
		Decimal kessaitesuryoatobarai = 0;

		for(OpportunityLineItem aOpportunityLineItem : aOpportunity.OpportunityLineItems){
			if(aOpportunityLineItem.Product2.k_ShohinCategory_Id_exp__c == 'sougiOption'){
				if(aOpportunityLineItem.HinmokuBunrui__c == '返礼品' && tesuryoTekiyoHenreihin) henreihin += aOpportunityLineItem.TotalPrice;
				else if(aOpportunityLineItem.HinmokuBunrui__c == '料理' && tesuryoTekiyoRyori) ryori += aOpportunityLineItem.TotalPrice;
				else if(aOpportunityLineItem.HinmokuBunrui__c == 'ラストメイク' && tesuryoTekiyoSogishaOption) lastmake += aOpportunityLineItem.TotalPrice;
				else if(aOpportunityLineItem.HinmokuBunrui__c == 'メイク＆ドレス(古式湯灌)' && tesuryoTekiyoSogishaOption) makedress += aOpportunityLineItem.TotalPrice;
				else if(aOpportunityLineItem.HinmokuBunrui__c == '湯かん' && tesuryoTekiyoSogishaOption) yukan += aOpportunityLineItem.TotalPrice;
				else if(aOpportunityLineItem.HinmokuBunrui__c == '枕花' && tesuryoTekiyoSogishaOption) makurabana += aOpportunityLineItem.TotalPrice;
				else if(aOpportunityLineItem.HinmokuBunrui__c == '棺上花束' && tesuryoTekiyoSogishaOption) kanjohanataba += aOpportunityLineItem.TotalPrice;
				else if(aOpportunityLineItem.HinmokuBunrui__c == 'お別れ花' && tesuryoTekiyoSogishaOption) owakarebana += aOpportunityLineItem.TotalPrice;
				else if(aOpportunityLineItem.HinmokuBunrui__c == '供花' && tesuryoTekiyoSogishaOption) kyoka += aOpportunityLineItem.TotalPrice;
				else if(aOpportunityLineItem.HinmokuBunrui__c == '遺影写真' && tesuryoTekiyoSogishaOption) ieishashin += aOpportunityLineItem.TotalPrice;
				else if(aOpportunityLineItem.HinmokuBunrui__c == '看板' && tesuryoTekiyoSogishaOption) kanban += aOpportunityLineItem.TotalPrice;
				else if(aOpportunityLineItem.HinmokuBunrui__c == '外装設備追加' && tesuryoTekiyoSogishaOption) gaisosetsubitsuika += aOpportunityLineItem.TotalPrice;
				else if(aOpportunityLineItem.HinmokuBunrui__c == '棺' && tesuryoTekiyoSogishaOption) hitsugi += aOpportunityLineItem.TotalPrice;
				else if(aOpportunityLineItem.HinmokuBunrui__c == '祭壇' && tesuryoTekiyoSogishaOption) saidan += aOpportunityLineItem.TotalPrice;
				else if(aOpportunityLineItem.HinmokuBunrui__c == 'エンバーミング' && tesuryoTekiyoSogishaOption) embalming += aOpportunityLineItem.TotalPrice;
				else if(aOpportunityLineItem.HinmokuBunrui__c == '骨壺ランクアップ' && tesuryoTekiyoKotsutsubo) kotsutsuborankup += aOpportunityLineItem.TotalPrice;
				else if(aOpportunityLineItem.HinmokuBunrui__c == '決済手数料(GMO後払い)') kessaitesuryoatobarai += aOpportunityLineItem.TotalPrice;
			}
			else if(aOpportunityLineItem.Product2.k_ShohinCategory_Id_exp__c == 'yoriso-option'){
				if(aOpportunityLineItem.HinmokuBunrui__c == '祭壇' && tesuryoTekiyoYorisoOption) saidan += aOpportunityLineItem.TotalPrice;
				else if(aOpportunityLineItem.HinmokuBunrui__c == 'お別れ花' && tesuryoTekiyoYorisoOption) owakarebana += aOpportunityLineItem.TotalPrice;
				else if(aOpportunityLineItem.HinmokuBunrui__c == '棺上花束' && tesuryoTekiyoYorisoOption) kanjohanataba += aOpportunityLineItem.TotalPrice;
				else if(aOpportunityLineItem.HinmokuBunrui__c == '枕花' && tesuryoTekiyoYorisoOption) makurabana += aOpportunityLineItem.TotalPrice;
				else if(aOpportunityLineItem.HinmokuBunrui__c == '遺影写真' && tesuryoTekiyoSogishaOption) ieishashin += aOpportunityLineItem.TotalPrice;
			}
			else{
				if(aOpportunityLineItem.HinmokuBunrui__c == '本体') {
					hontai = SgPtSeikPlanNames.getPlanName(
						aOpportunityLineItem.Product2.ShohinBango__c, 
						aOpportunityLineItem.TotalPrice, 
						aOpportunityLineItem.Product2.NameForCustomerExp__c
					);       			
				}
				else if(aOpportunityLineItem.HinmokuBunrui__c == '事務手数料') jimutesuryo += aOpportunityLineItem.TotalPrice;
			}
		}
		SogiShiharaitsuchisyoWaribikiKeisan.ResultSogiwaribiki resultwaribiki = new SogiShiharaitsuchisyoWaribikiKeisan().waribikiTotalization(aOpportunityId);
		SimpleYasugo__c updateSimpleYasugo = new SimpleYasugo__c();
		updateSimpleYasugo.Id = aOpportunity.SimpleYasugoRef__c;
		updateSimpleYasugo.PlanNaiyo__c = hontai;
		updateSimpleYasugo.ReturnGoodsTotalFee__c = henreihin;
		updateSimpleYasugo.CookingTotalFee__c = ryori;
		updateSimpleYasugo.LastMakeupPrice__c = lastmake;
		updateSimpleYasugo.MakeupDressPrice__c = makedress;
		updateSimpleYasugo.YukanPrice__c = yukan;
		updateSimpleYasugo.MakurahanaPrice__c = makurabana;
		updateSimpleYasugo.BouquetPrice__c = kanjohanataba;
		updateSimpleYasugo.PartingPrice__c = owakarebana;
		updateSimpleYasugo.KugePrice__c = kyoka;
		updateSimpleYasugo.IeiPrice__c = ieishashin;
		updateSimpleYasugo.FrontSignPrice__c = kanban;
		updateSimpleYasugo.ExteriorPrice__c = gaisosetsubitsuika;
		updateSimpleYasugo.UrnPrice__c = kotsutsuborankup;
		updateSimpleYasugo.Hitsugi__c = hitsugi;
		updateSimpleYasugo.SaidanPrice__c = saidan;
		updateSimpleYasugo.EmbalmingPrice__c = embalming;
		updateSimpleYasugo.JimuTesuryo__c = jimutesuryo;
		updateSimpleYasugo.AtobaraiTesuryoTotal__c = kessaitesuryoatobarai;
		updateSimpleYasugo.ReportCouponWaribiki__c = webjizenwaribiki;
		updateSimpleYasugo.kishafutankingaku__c = resultwaribiki.kishafutan;
		updateSimpleYasugo.Yorisofutankingaku__c = resultwaribiki.yorisofutan;
		update updateSimpleYasugo;
	}
}