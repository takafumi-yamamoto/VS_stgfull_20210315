public class KeirDenSogiTransSlips {
	
	private Boolean isSogishaOption(String pShohinCategoryId, String pShohinShubetsuId){
		if(pShohinCategoryId == 'yoriso-option') return false;
		if(pShohinCategoryId == 'yoriso-option-campaign') return false;
		
		String ShohinShubetsu_OptionItaku_Id = '3'; //オプション（委託）
		String ShohinShubetsu_OptionTehai_Id = '4'; //オプション（手配）
		if(pShohinShubetsuId == ShohinShubetsu_OptionItaku_Id) return true;
		if(pShohinShubetsuId == ShohinShubetsu_OptionTehai_Id) return true;
		return false;
	}

	private Boolean isKessaiTesuryo(String pShohinBango, String pShohinCategoryId){
		String ShohinBango_of_GmoAtobaraiRiyoRyo_for_Simple = 'SBG-0002010';
		String ShohinBango_of_GmoAtobaraiRiyoRyo_for_Yasugo = 'SBG-0002011';
		if(pShohinBango == ShohinBango_of_GmoAtobaraiRiyoRyo_for_Simple) return true;
		if(pShohinBango == ShohinBango_of_GmoAtobaraiRiyoRyo_for_Yasugo) return true;
		if(pShohinCategoryId == 'payment') return true;
		return false;
	}

	public Opportunity getOppData(String pShodanBango){
		Opportunity theOpp = (Opportunity)SobjectsExtension.firstOrNull([
			SELECT 
			Id, ShodanBango__c, RecordTypeId, RecordType.DeveloperName,
			IsClosed, IsWon, Utiagebi__c,
			AccountId, Account.TorihikisakiBango__c,
			Amount, SeikyuZandaka__c,
			(
				SELECT Id, TotalPrice, Product2.DataKubun__c,  Product2.ShohinBango__c, Product2.Name,
				Product2.k_ShohinSyubetsu_Id_exp__c, Product2.k_ShohinCategory_Id_exp__c
				FROM OpportunityLineItems
			),
			(
				SELECT Id, SeikyuHouhou__c, SeikyuKingaku__c, 
				SousaiSakiShodanRef__r.ShodanBango__c, SousaiSakiShodanRef__r.RecordType.DeveloperName
				FROM KaisyuYoteisOpportunity__r
			),
			SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Id,
			SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.TorihikisakiBango__c,
			SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.KeiriTorihikiSakiName__c,
			TesuryoPartnerForPlan__c, TesuryoPartnerForOption__c,
			TesuryoPartnerForSogiOption__c, TesuryoPartnerForYorisoOption__c,
			JimuTesuryo__c, UriageCyoseiGakuPartnerExp__c, TokuyakutenTesuryo__c,
			NyukinSimekiriBiPartner__c, SeikyuYoteiGakuPartnerExp__c, 
			ShiharaiKijitsuPartner__c, ShiharaiYoteiGakuPartnerExp__c
			FROM Opportunity 
			WHERE ShodanBango__c = :pShodanBango
		]);
		return theOpp;
	}

	public class InvalidOppDataException extends Exception {}
	public TransSlip createTransSlip(Opportunity pOpp){

		TransSlip theTransSlip = new TransSlip();

		theTransSlip.ShodanBango = pOpp.ShodanBango__c;
		if( String.isBlank(theTransSlip.ShodanBango) ) throw new InvalidOppDataException('ShodanBango shoud be.;');

		theTransSlip.UriageDate = pOpp.Utiagebi__c;
		if( theTransSlip.UriageDate == null ) throw new InvalidOppDataException('UriageDate shoud be.;');

		theTransSlip.Customer_TorihikisakiBango = pOpp.Account.TorihikisakiBango__c;
		if( String.isBlank( theTransSlip.Customer_TorihikisakiBango ) ) throw new InvalidOppDataException('Customer shoud be.;');

		theTransSlip.Partner_TorihikisakiBango = pOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.TorihikisakiBango__c;
		if( String.isBlank( theTransSlip.Partner_TorihikisakiBango ) ) throw new InvalidOppDataException('Partner shoud be.;');

		theTransSlip.Partner_KeiriTorihikiSakiName = 
			String.isBlank(pOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.KeiriTorihikiSakiName__c)
			? '' : pOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.KeiriTorihikiSakiName__c;

		theTransSlip.SeikyuToPartner_Kingaku = pOpp.SeikyuYoteiGakuPartnerExp__c == null ? 0 : pOpp.SeikyuYoteiGakuPartnerExp__c;
		theTransSlip.SeikyuToPartner_DueDate = pOpp.NyukinSimekiriBiPartner__c;
		theTransSlip.ShiharaiToPartner_Kingaku = pOpp.ShiharaiYoteiGakuPartnerExp__c == null ? 0 : pOpp.ShiharaiYoteiGakuPartnerExp__c; 
		theTransSlip.ShiharaiToPartner_DueDate = pOpp.ShiharaiKijitsuPartner__c;

		//パートナからの購入
		for( OpportunityLineItem aOppLineItem : pOpp.OpportunityLineItems){
			Decimal theKingaku = aOppLineItem.TotalPrice == null ? 0 : aOppLineItem.TotalPrice * -1;
			if(theKingaku == 0) continue;
			if(aOppLineItem.Product2.DataKubun__c == '3:クーポン') continue;
			if( this.isKessaiTesuryo(aOppLineItem.Product2.ShohinBango__c, aOppLineItem.Product2.k_ShohinCategory_Id_exp__c) ){
				continue;
			}

			Kamokus theKamoku = Kamokus.SogiPlan;
			if( this.isSogishaOption( aOppLineItem.Product2.k_ShohinCategory_Id_exp__c, aOppLineItem.Product2.k_ShohinSyubetsu_Id_exp__c)
			){
				theKamoku = Kamokus.SogishaOption;
			}
			if( aOppLineItem.Product2.k_ShohinCategory_Id_exp__c == 'yoriso-option' || aOppLineItem.Product2.k_ShohinCategory_Id_exp__c =='yoriso-option-campaign'){
				theKamoku = Kamokus.YorisoOption;
			}

			if(aOppLineItem.Product2.DataKubun__c == '2:割引プラン') theKamoku = Kamokus.WaribikiPlan;

			theTransSlip.SaikenOnPartnerList.add( 
				new SaikenOnPartner().setKamoku(theKamoku).setKingaku(theKingaku).addCaption(aOppLineItem.Product2.Name)
			);
		}

		//客への販売
		for( OpportunityLineItem aOppLineItem : pOpp.OpportunityLineItems){
			Decimal theKingaku = aOppLineItem.TotalPrice == null ? 0 : aOppLineItem.TotalPrice;
			if(theKingaku == 0) continue;

			Kamokus theKamoku = Kamokus.SogiPlan;
			if( this.isSogishaOption(aOppLineItem.Product2.k_ShohinCategory_Id_exp__c, aOppLineItem.Product2.k_ShohinSyubetsu_Id_exp__c)
			){
				theKamoku = Kamokus.SogishaOption;
			}
			if( aOppLineItem.Product2.k_ShohinCategory_Id_exp__c == 'yoriso-option' || aOppLineItem.Product2.k_ShohinCategory_Id_exp__c =='yoriso-option-campaign' ){
				theKamoku = Kamokus.YorisoOption;
			}

			if(aOppLineItem.Product2.DataKubun__c == '2:割引プラン') theKamoku = Kamokus.WaribikiPlan;
			if(aOppLineItem.Product2.DataKubun__c == '3:クーポン') theKamoku = Kamokus.Coupon;
			if( this.isKessaiTesuryo(aOppLineItem.Product2.ShohinBango__c, aOppLineItem.Product2.k_ShohinCategory_Id_exp__c) ){
				theKamoku = Kamokus.KessaiTesuryo;
			}

			String theHinmoku = '';
			if(aOppLineItem.Product2.k_ShohinCategory_Id_exp__c == 'chokusou') theHinmoku = '10_お葬式_直葬';
			if(aOppLineItem.Product2.k_ShohinCategory_Id_exp__c == 'kasou') theHinmoku = '10_お葬式_火葬式';
			if(aOppLineItem.Product2.k_ShohinCategory_Id_exp__c == 'ichinichi') theHinmoku = '10_お葬式_一日葬';
			if(aOppLineItem.Product2.k_ShohinCategory_Id_exp__c == 'kazokusou') theHinmoku = '10_お葬式_家族葬';
			if(aOppLineItem.Product2.k_ShohinCategory_Id_exp__c == 'ippansou') theHinmoku = '10_お葬式_一般葬';
			if(aOppLineItem.Product2.k_ShohinCategory_Id_exp__c == 'yasugou-kasou') theHinmoku = '10_お葬式_火葬式';
			if(aOppLineItem.Product2.k_ShohinCategory_Id_exp__c == 'yasugou-ichinichi') theHinmoku = '10_お葬式_一日葬';
			if(aOppLineItem.Product2.k_ShohinCategory_Id_exp__c == 'yasugou-kazoku') theHinmoku = '10_お葬式_家族葬';
			theTransSlip.SaikenOnCustomerList.add( 
				new SaikenOnCustomer().setKamoku(theKamoku).setKingaku(theKingaku).addCaption(aOppLineItem.Product2.Name)
					.setHinmoku(theHinmoku)
			);
		}

		//客の決済
		for(OkyakusamaSeikyuMeisai__c aSeikyuMeisai : pOpp.KaisyuYoteisOpportunity__r){
			Decimal theKingaku = aSeikyuMeisai.SeikyuKingaku__c == null ? 0 : aSeikyuMeisai.SeikyuKingaku__c;
			if(theKingaku == 0) continue;
			KessaiKouzas theKessaiKouza = KessaiKouzas.None;
			if( aSeikyuMeisai.SeikyuHouhou__c == 'Partner') theKessaiKouza = KessaiKouzas.Partner;
			if( aSeikyuMeisai.SeikyuHouhou__c == 'sousai') theKessaiKouza = KessaiKouzas.MaeukeSosai;
			if( aSeikyuMeisai.SeikyuHouhou__c == 'furikomi') theKessaiKouza = KessaiKouzas.Cash;
			if( aSeikyuMeisai.SeikyuHouhou__c == 'orico_loan') theKessaiKouza = KessaiKouzas.Orico_Loan;
			if( aSeikyuMeisai.SeikyuHouhou__c == 'orico_credit') theKessaiKouza = KessaiKouzas.Orico_Cred;
			if( aSeikyuMeisai.SeikyuHouhou__c == 'sosaifujo') theKessaiKouza = KessaiKouzas.Partner;
			if( aSeikyuMeisai.SeikyuHouhou__c == 'gmo_credit') theKessaiKouza = KessaiKouzas.Gmo_Cred;
			if( aSeikyuMeisai.SeikyuHouhou__c == 'gmo_atobarai') theKessaiKouza = KessaiKouzas.Gmo_Atobarai;
			if(theKessaiKouza == KessaiKouzas.None){
				throw new InvalidOppDataException( 
					String.format('unknown SeikyuHouhou__c:{0};', 
						new List<String>{ aSeikyuMeisai.SeikyuHouhou__c == null ? 'null' : aSeikyuMeisai.SeikyuHouhou__c } ) 
				);
			}

			String theSosaiSakiShodanBango = '';
			Kamokus theSosaiSakiKamoku = Kamokus.None;	
			if( aSeikyuMeisai.SeikyuHouhou__c == 'sousai'){
				theSosaiSakiShodanBango = aSeikyuMeisai.SousaiSakiShodanRef__r.ShodanBango__c;
				if( String.isBlank(theSosaiSakiShodanBango) ){
					throw new InvalidOppDataException('theSosaiSakiShodanBango should be.;');
				}
				if(aSeikyuMeisai.SousaiSakiShodanRef__r.RecordType.DeveloperName == 'Seizenkeiyaku') theSosaiSakiKamoku = Kamokus.SeizenKeiyaku;
				
				if(theSosaiSakiKamoku == Kamokus.None){
					throw new InvalidOppDataException('cant resolve sosai-aite kamoku.;');		
				}
			}
			theTransSlip.KessaiFromCustomerList.add( 
				new KessaiFromCustomer()
					.setKessaiKouza(theKessaiKouza).setKingaku(theKingaku)
					.setSosaiSakiShodanBango(theSosaiSakiShodanBango).setSosaiSakiKamoku(theSosaiSakiKamoku)
					.addCaption(aSeikyuMeisai.SeikyuHouhou__c)
			);
		}

		//パートナーへの販売
		{
			{ //プラン手数料(Kamokus.SogiPlanTesuryo)として
				Decimal thePlanTesuryo = pOpp.TesuryoPartnerForPlan__c == null ? 0 : pOpp.TesuryoPartnerForPlan__c;
				if( thePlanTesuryo != 0){
					theTransSlip.SaikenOnPartnerList.add( 
						new SaikenOnPartner().setKamoku(Kamokus.SogiPlanTesuryo).setKingaku(thePlanTesuryo).addCaption('手数料-葬儀プラン')
					);
				}
				Decimal theJimuTesuryo = pOpp.JimuTesuryo__c == null ? 0 : pOpp.JimuTesuryo__c;
				if( theJimuTesuryo != 0){
					theTransSlip.SaikenOnPartnerList.add( 
						new SaikenOnPartner().setKamoku(Kamokus.SogiPlanTesuryo).setKingaku(theJimuTesuryo).addCaption('手数料-事務手数料')
					);
				}
				Decimal theTesuryoCyosei = pOpp.UriageCyoseiGakuPartnerExp__c == null ? 0 : pOpp.UriageCyoseiGakuPartnerExp__c;
				if( theTesuryoCyosei != 0){
					theTransSlip.SaikenOnPartnerList.add( 
						new SaikenOnPartner().setKamoku(Kamokus.SogiPlanTesuryo).setKingaku(theTesuryoCyosei).addCaption('手数料-手数料調整')
					);
				}
			}

			//よりそうオプション手数料売上
			Decimal theYorisoOptionTesuryo = pOpp.TesuryoPartnerForYorisoOption__c == null ? 0 : pOpp.TesuryoPartnerForYorisoOption__c;
			if( theYorisoOptionTesuryo != 0){
				theTransSlip.SaikenOnPartnerList.add( 
					new SaikenOnPartner().setKamoku(Kamokus.YorisoOptionTesuryo).setKingaku(theYorisoOptionTesuryo).addCaption('手数料-よりそうオプション')
				);
			}

			//葬儀社オプション手数料売上
			Decimal theOptionTeusyo_Total = pOpp.TesuryoPartnerForOption__c == null ? 0 : pOpp.TesuryoPartnerForOption__c;
			Decimal theSogishaOptionTesuryo = theOptionTeusyo_Total - theYorisoOptionTesuryo;
			if( theSogishaOptionTesuryo != 0){
				theTransSlip.SaikenOnPartnerList.add( 
					new SaikenOnPartner().setKamoku(Kamokus.SogishaOptionTesuryo).setKingaku(theSogishaOptionTesuryo).addCaption('手数料-葬儀社オプション')
				);
			}


			//特約店手数料売上
			Decimal theTokuyakuTesuryo = pOpp.TokuyakutenTesuryo__c == 0 ? 0 : pOpp.TokuyakutenTesuryo__c;
			if( theTokuyakuTesuryo != 0){
				theTransSlip.SaikenOnPartnerList.add( 
					new SaikenOnPartner().setKamoku(Kamokus.SogiTokuyakuTesuryo).setKingaku(theTokuyakuTesuryo).addCaption('手数料-特約店手数料')
						.setHinmoku('51_特約店手数料')
				);
			}
			
		}

		return theTransSlip;
	}

	public enum Kamokus{ 
		None,
		SogiPlan, SogishaOption, YorisoOption,
		WaribikiPlan, Coupon, 
		SogiPlanTesuryo, 
		SogishaOptionTesuryo, 
		YorisoOptionTesuryo,
		SogiTokuyakuTesuryo,
		SeizenKeiyaku, Lawson,
		KessaiTesuryo
	}
	public enum KessaiKouzas{ 
		None,
		Cash, MaeukeSosai,
		Partner,
		Orico_Loan, Orico_Cred,
		Gmo_Cred, Gmo_Atobarai
	}
	public class TransSlip{
		public String ShodanBango;
		public Date UriageDate;
		public String Customer_TorihikisakiBango;
		public String Partner_TorihikisakiBango;
		public String Partner_KeiriTorihikiSakiName;
		public Decimal SeikyuToPartner_Kingaku;
		public Date SeikyuToPartner_DueDate;
		public Decimal ShiharaiToPartner_Kingaku;
		public Date ShiharaiToPartner_DueDate;
		public List<SaikenOnCustomer> SaikenOnCustomerList = new List<SaikenOnCustomer>();
		public List<KessaiFromCustomer> KessaiFromCustomerList = new List<KessaiFromCustomer>();
		public List<SaikenOnPartner> SaikenOnPartnerList = new List<SaikenOnPartner>();
	}

	public class SaikenOnCustomer{
		public Kamokus Kamoku;
		public SaikenOnCustomer setKamoku(Kamokus pValue){ this.Kamoku = pValue; return this; }
		public Decimal Kingaku;
		public SaikenOnCustomer setKingaku(Decimal pValue){ this.Kingaku = pValue; return this; }
		public String Hinmoku = '';
		public SaikenOnCustomer setHinmoku(String pValue){ this.Hinmoku = pValue; return this; }
		public List<String> Captions = new List<String>();
		public SaikenOnCustomer addCaption(String pValue){ if( !String.isBlank(pValue) ) this.Captions.add(pValue); return this; }
		public SaikenOnCustomer addCaptions(List<String> pValue){ if( pValue != null ) this.Captions.addAll(pValue); return this; }
	}
	public class KessaiFromCustomer{
		public KessaiKouzas KessaiKouza;
		public KessaiFromCustomer setKessaiKouza(KessaiKouzas pValue){ this.KessaiKouza = pValue; return this; }
		public String SosaiSakiShodanBango;
		public KessaiFromCustomer setSosaiSakiShodanBango(String pValue){ this.SosaiSakiShodanBango = pValue; return this; }
		public Kamokus SosaiSakiKamoku;
		public KessaiFromCustomer setSosaiSakiKamoku(Kamokus pValue){ this.SosaiSakiKamoku = pValue; return this; }
		public Decimal Kingaku;
		public KessaiFromCustomer setKingaku(Decimal pValue){ this.Kingaku = pValue; return this; }
		public List<String> Captions = new List<String>();
		public KessaiFromCustomer addCaption(String pValue){ if( !String.isBlank(pValue) ) this.Captions.add(pValue); return this; }
		public KessaiFromCustomer addCaptions(List<String> pValue){ if( pValue != null ) this.Captions.addAll(pValue); return this; }
	}
	public class SaikenOnPartner{
		public Kamokus Kamoku;
		public SaikenOnPartner setKamoku(Kamokus pValue){ this.Kamoku = pValue; return this; }
		public Decimal Kingaku;
		public SaikenOnPartner setKingaku(Decimal pValue){ this.Kingaku = pValue; return this; }
		public String Hinmoku = '';
		public SaikenOnPartner setHinmoku(String pValue){ this.Hinmoku = pValue; return this; }
		public List<String> Captions = new List<String>();
		public SaikenOnPartner addCaption(String pValue){ if( !String.isBlank(pValue) ) this.Captions.add(pValue); return this; }
		public SaikenOnPartner addCaptions(List<String> pValue){ if( pValue != null ) this.Captions.addAll(pValue); return this; }

	}
}