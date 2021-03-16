public class KeirDenSogiFreees {

	private TaxRates m_TaxRates;
	private KeirDenSogiFreees(TaxRates pTaxRates){ this.m_TaxRates = pTaxRates; }
	public static KeirDenSogiFreees instance(){ return new KeirDenSogiFreees( TaxRates.instance() ); }

	public class Deal{
		public String KanriBango = '';
		public Deal setKanriBango(String pValue){ this.KanriBango = pValue; return this; }
		public Date HasseiDate;
		public Deal setHasseiDate(Date pValue){ this.HasseiDate = pValue; return this; }
		public String ShushiKubun;
		public Deal setShushiKubun(String pValue){ this.ShushiKubun = pValue; return this; }
		public String TorihikisakiName;
		public Deal setTorihikisakiName(String pValue){ this.TorihikisakiName = pValue; return this; }
		public Date ShiharaiKijitsu;
		public Deal setShiharaiKijitsu(Date pValue){ this.ShiharaiKijitsu = pValue; return this; }
		List<KanjoLine> KanjoLines = new List<KanjoLine>();
		public Deal addKanjoLine(KanjoLine pValue){ this.KanjoLines.add(pValue); return this; }
		List<KessaiLine> KessaiLines = new List<KessaiLine>();
		public Deal addKessaiLine(KessaiLine pValue){ this.KessaiLines.add(pValue); return this; }
		public List<String> Captions = new List<String>();
		public Deal addCaption(String pValue){ if( !String.isBlank(pValue) ) this.Captions.add(pValue); return this; }
		public Decimal getKanjoAmount(){
			Decimal theAmount = 0;
			for(KanjoLine aKanjoLine: this.KanjoLines){ 
				theAmount += aKanjoLine.Kingaku; 
			}
			return theAmount;
		} 
		public void reverseShushi(){
			if(this.ShushiKubun == '収入'){
				this.ShushiKubun = '支出';
			}
			else if(this.ShushiKubun == '支出'){
				this.ShushiKubun = '収入';
			}

			for(KanjoLine aKanjoLine : this.KanjoLines){ 
				aKanjoLine.Kingaku *= -1; 
			}
			for(KessaiLine aKessaiLine : this.KessaiLines){ 
				aKessaiLine.ShiharaiKingaku *= -1; 
			}
		}
	}

	public class KanjoLine{
		public String KanjoKamoku;
		public KanjoLine setKanjoKamoku(String pValue){ this.KanjoKamoku = pValue; return this; }
		public String ZeiKubun;
		public KanjoLine setZeiKubun(String pValue){ this.ZeiKubun = pValue; return this; }
		public String ZeiKeisanKubun;
		public KanjoLine setZeiKeisanKubun(String pValue){ this.ZeiKeisanKubun = pValue; return this; }
		public Decimal Kingaku;
		public KanjoLine setKingaku(Decimal pValue){ this.Kingaku = pValue; return this; }
		public String Hinmoku;
		public KanjoLine setHinmoku(String pValue){ this.Hinmoku = pValue; return this; }
		public List<String> MemoTags = new List<String>();
		public KanjoLine addMemoTag(String pValue){ this.MemoTags.add(pValue); return this; }
		public String Bumon;
		public KanjoLine setBumon(String pValue){ this.Bumon = pValue; return this; }
		public String Biko;
		public KanjoLine setBiko(String pValue){ this.Biko = pValue; return this; }
		public List<String> Captions = new List<String>();
		public KanjoLine addCaptions(List<String> pValue){ if( pValue != null ) this.Captions.addAll(pValue); return this; }
	}
	public class KessaiLine{
		public Date ShiharaiDate;
		public KessaiLine setShiharaiDate(Date pValue){ this.ShiharaiDate = pValue; return this; }
		public String ShiharaiKoza;
		public KessaiLine setShiharaiKoza(String pValue){ this.ShiharaiKoza = pValue; return this; }
		public Decimal ShiharaiKingaku;
		public KessaiLine setShiharaiKingaku(Decimal pValue){ this.ShiharaiKingaku = pValue; return this; }
		public List<String> Captions = new List<String>();
		public KessaiLine addCaptions(List<String> pValue){ if( pValue != null ) this.Captions.addAll(pValue); return this; }
	}

	public class InvalidTransSlipException extends Exception {}
	public List<Deal> createDeals(KeirDenSogiTransSlips.TransSlip pTransSlip){

		List<KeirDenSogiTransSlips.SaikenOnCustomer> theSaikenOnCustomerList = this.reduce(pTransSlip.SaikenOnCustomerList);
		List<KeirDenSogiTransSlips.KessaiFromCustomer> theKessaiFromCustomerList = this.reduce(pTransSlip.KessaiFromCustomerList);
		List<KeirDenSogiTransSlips.SaikenOnPartner> theSaikenOnPartnerList = this.reduce(pTransSlip.SaikenOnPartnerList);

		List<Deal> theDeals = new List<Deal>();

		{ //ユーザー伝票
			Deal theDeal_ForCustomer = new Deal()
				.addCaption('ユーザー伝票').setShushiKubun('収入').setKanriBango( this.getKanriBango(pTransSlip.ShodanBango) )
				.setTorihikisakiName('ユーザー').setHasseiDate(pTransSlip.UriageDate);

			//ユーザー伝票/ユーザー購入
			for(KeirDenSogiTransSlips.SaikenOnCustomer aSaikenOnCustomer: theSaikenOnCustomerList){
				if(aSaikenOnCustomer.Kamoku == KeirDenSogiTransSlips.Kamokus.SogiPlan){
					theDeal_ForCustomer.addKanjoLine(
						new KanjoLine().addCaptions(aSaikenOnCustomer.Captions)
							.setKanjoKamoku('葬儀プラン売上高').setZeiKubun( this.injectTaxRate('課税売上{0}%', pTransSlip.UriageDate) )
							.setKingaku(aSaikenOnCustomer.Kingaku).setZeiKeisanKubun('内税')
							.setHinmoku(aSaikenOnCustomer.Hinmoku)
							.setBumon('葬儀').addMemoTag( this.omitHead0(pTransSlip.ShodanBango) )
							.setBiko('葬儀プラン')
					);
				}
				else if(aSaikenOnCustomer.Kamoku == KeirDenSogiTransSlips.Kamokus.YorisoOption){
					theDeal_ForCustomer.addKanjoLine(
						new KanjoLine().addCaptions(aSaikenOnCustomer.Captions)
							.setKanjoKamoku('よりそうOP売上高').setZeiKubun( this.injectTaxRate('課税売上{0}%', pTransSlip.UriageDate) )
							.setKingaku(aSaikenOnCustomer.Kingaku).setZeiKeisanKubun('内税')
							.setBumon('葬儀').addMemoTag( this.omitHead0(pTransSlip.ShodanBango) )
							.setBiko('よりそうオプション')
					);
				}
				else if(aSaikenOnCustomer.Kamoku == KeirDenSogiTransSlips.Kamokus.SogishaOption){
					theDeal_ForCustomer.addKanjoLine(
						new KanjoLine().addCaptions(aSaikenOnCustomer.Captions)
							.setKanjoKamoku('葬儀OP外注費').setZeiKubun( this.injectTaxRate('課対仕入{0}%', pTransSlip.UriageDate) )
							.setKingaku(aSaikenOnCustomer.Kingaku).setZeiKeisanKubun('内税')
							.setBumon('葬儀').addMemoTag( this.omitHead0(pTransSlip.ShodanBango) )
							.setBiko('葬儀社オプション')
					);
				}
				else if(aSaikenOnCustomer.Kamoku == KeirDenSogiTransSlips.Kamokus.WaribikiPlan){
					theDeal_ForCustomer.addKanjoLine(
						new KanjoLine().addCaptions(aSaikenOnCustomer.Captions)
							.setKanjoKamoku('葬儀プラン売上高').setZeiKubun( this.injectTaxRate('課税売上{0}%', pTransSlip.UriageDate) )
							.setKingaku(aSaikenOnCustomer.Kingaku).setZeiKeisanKubun('内税')
							.setBumon('葬儀').addMemoTag( this.omitHead0(pTransSlip.ShodanBango) )
							.setBiko('割引プラン')
					);
				}
				else if(aSaikenOnCustomer.Kamoku == KeirDenSogiTransSlips.Kamokus.Coupon){
					theDeal_ForCustomer.addKanjoLine(
						new KanjoLine().addCaptions(aSaikenOnCustomer.Captions)
							.setKanjoKamoku('葬儀プラン売上高').setZeiKubun( this.injectTaxRate('課税売上{0}%', pTransSlip.UriageDate) )
							.setKingaku(aSaikenOnCustomer.Kingaku).setZeiKeisanKubun('内税')
							.setBumon('葬儀').addMemoTag( this.omitHead0(pTransSlip.ShodanBango) )
							.setBiko('値引')
					);
				}
				else if(aSaikenOnCustomer.Kamoku == KeirDenSogiTransSlips.Kamokus.KessaiTesuryo){
					theDeal_ForCustomer.addKanjoLine(
						new KanjoLine().addCaptions(aSaikenOnCustomer.Captions)
							.setKanjoKamoku('支払手数料').setZeiKubun( this.injectTaxRate('課対仕入{0}%', pTransSlip.UriageDate) )
							.setKingaku(aSaikenOnCustomer.Kingaku).setZeiKeisanKubun('内税')
							.setBumon('葬儀').addMemoTag( this.omitHead0(pTransSlip.ShodanBango) )
							.setBiko('支払手数料')
					);
				}
				else{
					throw new InvalidTransSlipException( 
						String.format('unknown Kamoku:{0};', 
							new List<String>{ aSaikenOnCustomer.Kamoku == null ? 'null' : String.valueOf(aSaikenOnCustomer.Kamoku)  } ) 
					);
				}
			}

			//ユーザー伝票/ユーザー決済
			for(KeirDenSogiTransSlips.KessaiFromCustomer aKessaiFromCustomer: theKessaiFromCustomerList){
				String theShiharaiKoza = 'unknown';
				if(aKessaiFromCustomer.KessaiKouza == KeirDenSogiTransSlips.KessaiKouzas.Cash) theShiharaiKoza = '決済-現金';
				if(aKessaiFromCustomer.KessaiKouza == KeirDenSogiTransSlips.KessaiKouzas.MaeukeSosai) theShiharaiKoza = '決済-前受相殺';
				if(aKessaiFromCustomer.KessaiKouza == KeirDenSogiTransSlips.KessaiKouzas.Partner) theShiharaiKoza = '決済-パートナー';
				if(aKessaiFromCustomer.KessaiKouza == KeirDenSogiTransSlips.KessaiKouzas.Orico_Loan) theShiharaiKoza = '決済-オリコローン';
				if(aKessaiFromCustomer.KessaiKouza == KeirDenSogiTransSlips.KessaiKouzas.Orico_Cred) theShiharaiKoza = '決済-オリコカード';
				if(aKessaiFromCustomer.KessaiKouza == KeirDenSogiTransSlips.KessaiKouzas.Gmo_Cred) theShiharaiKoza = '決済-GMOクレカ';
				if(aKessaiFromCustomer.KessaiKouza == KeirDenSogiTransSlips.KessaiKouzas.Gmo_Atobarai) theShiharaiKoza = '決済-GMO後払い';
				if(theShiharaiKoza == 'unknown'){
					throw new InvalidTransSlipException( 
						String.format('unknown KessaiKouza:{0};', 
							new List<String>{ aKessaiFromCustomer.KessaiKouza == null ? 'null' : String.valueOf(aKessaiFromCustomer.KessaiKouza)  } ) 
					);
				}
				theDeal_ForCustomer.addKessaiLine(
					new KessaiLine().addCaptions(aKessaiFromCustomer.Captions)
						.setShiharaiKoza(theShiharaiKoza).setShiharaiKingaku(aKessaiFromCustomer.Kingaku).setShiharaiDate(pTransSlip.UriageDate)
				);
			}

			if( theDeal_ForCustomer.getKanjoAmount() < 0 ) theDeal_ForCustomer.reverseShushi();
			theDeals.add(theDeal_ForCustomer);
		}

		//決済振替伝票
		for(KeirDenSogiTransSlips.KessaiFromCustomer aKessaiFromCustomer: theKessaiFromCustomerList){
			if( aKessaiFromCustomer.Kingaku == 0) continue;

			if(aKessaiFromCustomer.KessaiKouza == KeirDenSogiTransSlips.KessaiKouzas.MaeukeSosai){
				String theSosaiPattern = 'unknown';

				if(aKessaiFromCustomer.SosaiSakiKamoku == KeirDenSogiTransSlips.Kamokus.SeizenKeiyaku) theSosaiPattern = '生前契約';
				if(theSosaiPattern == 'unknown'){
					throw new InvalidTransSlipException( 
						String.format('unknown SosaiSakiKamoku:{0};', 
							new List<String>{ aKessaiFromCustomer.SosaiSakiKamoku == null ? 'null' : String.valueOf(aKessaiFromCustomer.SosaiSakiKamoku)  } ) 
					);
				}

				String theTorihikiSakiName = 'ユーザー';
				if(theSosaiPattern == '生前契約') theTorihikiSakiName = 'シンプル生前契約';

				theDeals.add(
					new Deal().addCaption('決済振替伝票/決済-前受相殺').setShushiKubun( aKessaiFromCustomer.Kingaku > 0 ? '支出' : '収入' )
						.setKanriBango( this.getKanriBango(pTransSlip.ShodanBango) )
						.setTorihikisakiName(theTorihikiSakiName).setHasseiDate(pTransSlip.UriageDate)
						.addKanjoLine(
							new KanjoLine().addCaptions(aKessaiFromCustomer.Captions)
								.setKanjoKamoku('前受金').setKingaku(aKessaiFromCustomer.Kingaku)
								.setZeiKeisanKubun('内税').setZeiKubun('対象外')
								.setBumon('葬儀').addMemoTag( this.omitHead0(aKessaiFromCustomer.SosaiSakiShodanBango) )
						)
						.addKessaiLine(
							new KessaiLine().addCaptions(aKessaiFromCustomer.Captions)
								.setShiharaiKoza('決済-前受相殺').setShiharaiKingaku(aKessaiFromCustomer.Kingaku)
								.setShiharaiDate(pTransSlip.UriageDate)
						)
				);
			}
			if(aKessaiFromCustomer.KessaiKouza == KeirDenSogiTransSlips.KessaiKouzas.Partner){
				theDeals.add(
					new Deal().addCaption('決済振替伝票/決済-パートナー').setShushiKubun( aKessaiFromCustomer.Kingaku > 0 ? '支出' : '収入' )
						.setKanriBango( this.getKanriBango(pTransSlip.ShodanBango) )
						.setTorihikisakiName(pTransSlip.Partner_KeiriTorihikiSakiName).setHasseiDate(pTransSlip.UriageDate)
						.addKanjoLine(
							new KanjoLine().addCaptions(aKessaiFromCustomer.Captions)
								.setKanjoKamoku('未収入金_パートナー決済').setKingaku(aKessaiFromCustomer.Kingaku)
								.setZeiKeisanKubun('内税').setZeiKubun('対象外')
								.setBumon('葬儀').addMemoTag( this.omitHead0(pTransSlip.ShodanBango) )
						)
						.addKessaiLine(
							new KessaiLine().addCaptions(aKessaiFromCustomer.Captions)
								.setShiharaiKoza('決済-パートナー').setShiharaiKingaku(aKessaiFromCustomer.Kingaku)
								.setShiharaiDate(pTransSlip.UriageDate)
						)
				);
			}
			if(aKessaiFromCustomer.KessaiKouza == KeirDenSogiTransSlips.KessaiKouzas.Orico_Loan){
				theDeals.add(
					new Deal().addCaption('決済振替伝票/決済-オリコローン').setShushiKubun( aKessaiFromCustomer.Kingaku > 0 ? '支出' : '収入' )
						.setKanriBango( this.getKanriBango(pTransSlip.ShodanBango) )
						.setTorihikisakiName('オリコ（ローン）').setHasseiDate(pTransSlip.UriageDate)
						.addKanjoLine(
							new KanjoLine().addCaptions(aKessaiFromCustomer.Captions)
								.setKanjoKamoku('未収入金').setKingaku(aKessaiFromCustomer.Kingaku)
								.setZeiKeisanKubun('内税').setZeiKubun('対象外')
								.setBumon('葬儀').addMemoTag( this.omitHead0(pTransSlip.ShodanBango) )
						)
						.addKessaiLine(
							new KessaiLine().addCaptions(aKessaiFromCustomer.Captions)
								.setShiharaiKoza('決済-オリコローン').setShiharaiKingaku(aKessaiFromCustomer.Kingaku)
								.setShiharaiDate(pTransSlip.UriageDate)
						)
				);
			}
			if(aKessaiFromCustomer.KessaiKouza == KeirDenSogiTransSlips.KessaiKouzas.Orico_Cred){
				theDeals.add(
					new Deal().addCaption('決済振替伝票/決済-オリコクレカ').setShushiKubun( aKessaiFromCustomer.Kingaku > 0 ? '支出' : '収入' )
						.setKanriBango( this.getKanriBango(pTransSlip.ShodanBango) )
						.setTorihikisakiName('オリエントコーポレーション（カード）').setHasseiDate(pTransSlip.UriageDate)
						.addKanjoLine(
							new KanjoLine().addCaptions(aKessaiFromCustomer.Captions)
								.setKanjoKamoku('未収入金').setKingaku(aKessaiFromCustomer.Kingaku)
								.setZeiKeisanKubun('内税').setZeiKubun('対象外')
								.setBumon('葬儀').addMemoTag( this.omitHead0(pTransSlip.ShodanBango) )
						)
						.addKessaiLine(
							new KessaiLine().addCaptions(aKessaiFromCustomer.Captions)
								.setShiharaiKoza('決済-オリコカード').setShiharaiKingaku(aKessaiFromCustomer.Kingaku)
								.setShiharaiDate(pTransSlip.UriageDate)
						)
				);
			}
			if(aKessaiFromCustomer.KessaiKouza == KeirDenSogiTransSlips.KessaiKouzas.Gmo_Cred){
				theDeals.add(
					new Deal().addCaption('決済振替伝票/決済-GMOクレカ').setShushiKubun( aKessaiFromCustomer.Kingaku > 0 ? '支出' : '収入' )
						.setKanriBango( this.getKanriBango(pTransSlip.ShodanBango) )
						.setTorihikisakiName('GMOペイメントゲートウェイ（カード）').setHasseiDate(pTransSlip.UriageDate)
						.addKanjoLine(
							new KanjoLine().addCaptions(aKessaiFromCustomer.Captions)
								.setKanjoKamoku('未収入金').setKingaku(aKessaiFromCustomer.Kingaku)
								.setZeiKeisanKubun('内税').setZeiKubun('対象外')
								.setBumon('葬儀').addMemoTag( this.omitHead0(pTransSlip.ShodanBango) )
						)
						.addKessaiLine(
							new KessaiLine().addCaptions(aKessaiFromCustomer.Captions)
								.setShiharaiKoza('決済-GMOクレカ').setShiharaiKingaku(aKessaiFromCustomer.Kingaku)
								.setShiharaiDate(pTransSlip.UriageDate)
						)
				);
			}
			if(aKessaiFromCustomer.KessaiKouza == KeirDenSogiTransSlips.KessaiKouzas.Gmo_Atobarai){
				theDeals.add(
					new Deal().addCaption('決済振替伝票/決済-GMO後払い').setShushiKubun( aKessaiFromCustomer.Kingaku > 0 ? '支出' : '収入' )
						.setKanriBango( this.getKanriBango(pTransSlip.ShodanBango) )
						.setTorihikisakiName('GMO後払い').setHasseiDate(pTransSlip.UriageDate)
						.addKanjoLine(
							new KanjoLine().addCaptions(aKessaiFromCustomer.Captions)
								.setKanjoKamoku('未収入金').setKingaku(aKessaiFromCustomer.Kingaku)
								.setZeiKeisanKubun('内税').setZeiKubun('対象外')
								.setBumon('葬儀').addMemoTag( this.omitHead0(pTransSlip.ShodanBango) )
						)
						.addKessaiLine(
							new KessaiLine().addCaptions(aKessaiFromCustomer.Captions)
								.setShiharaiKoza('決済-GMO後払い').setShiharaiKingaku(aKessaiFromCustomer.Kingaku)
								.setShiharaiDate(pTransSlip.UriageDate)
						)
				);
			}
		}

		{ //パートナー伝票
			Deal theDeal_ForPartner = new Deal()
				.addCaption('パートナー伝票').setShushiKubun('収入')
				.setKanriBango( this.getKanriBango(pTransSlip.ShodanBango) )
				.setTorihikisakiName(pTransSlip.Partner_KeiriTorihikiSakiName).setHasseiDate(pTransSlip.UriageDate);

			//パートナー伝票/パートナー取引
			for(KeirDenSogiTransSlips.SaikenOnPartner aSaikenOnPartner: theSaikenOnPartnerList){
				if(aSaikenOnPartner.Kamoku == KeirDenSogiTransSlips.Kamokus.SogiPlan){
					theDeal_ForPartner.addKanjoLine(
						new KanjoLine().addCaptions(aSaikenOnPartner.Captions)
							.setKanjoKamoku('葬儀外注費（原）').setZeiKubun( this.injectTaxRate('課対仕入{0}%', pTransSlip.UriageDate) )
							.setKingaku(aSaikenOnPartner.Kingaku) .setZeiKeisanKubun('内税')
							.setBumon('葬儀').addMemoTag( this.omitHead0(pTransSlip.ShodanBango) )
							.setBiko('葬儀プラン')
					);
				}
				else if(aSaikenOnPartner.Kamoku == KeirDenSogiTransSlips.Kamokus.WaribikiPlan){
					theDeal_ForPartner.addKanjoLine(
						new KanjoLine().addCaptions(aSaikenOnPartner.Captions)
							.setKanjoKamoku('葬儀外注費（原）').setZeiKubun( this.injectTaxRate('課対仕入{0}%', pTransSlip.UriageDate) )
							.setKingaku(aSaikenOnPartner.Kingaku) .setZeiKeisanKubun('内税')
							.setBumon('葬儀').addMemoTag( this.omitHead0(pTransSlip.ShodanBango) )
							.setBiko('割引プラン')
					);
				}
				else if(aSaikenOnPartner.Kamoku == KeirDenSogiTransSlips.Kamokus.YorisoOption){
					theDeal_ForPartner.addKanjoLine(
						new KanjoLine().addCaptions(aSaikenOnPartner.Captions)
							.setKanjoKamoku('葬儀外注費（原）').setZeiKubun( this.injectTaxRate('課対仕入{0}%', pTransSlip.UriageDate) )
							.setKingaku(aSaikenOnPartner.Kingaku).setZeiKeisanKubun('内税')
							.setBumon('葬儀').addMemoTag( this.omitHead0(pTransSlip.ShodanBango) )
							.setBiko('よりそうオプション')
					);
				}
				else if(aSaikenOnPartner.Kamoku == KeirDenSogiTransSlips.Kamokus.SogishaOption){
					theDeal_ForPartner.addKanjoLine(
						new KanjoLine().addCaptions(aSaikenOnPartner.Captions)
							.setKanjoKamoku('葬儀OP外注費').setZeiKubun( this.injectTaxRate('課対仕入{0}%', pTransSlip.UriageDate) )
							.setKingaku(aSaikenOnPartner.Kingaku) .setZeiKeisanKubun('内税')
							.setBumon('葬儀').addMemoTag( this.omitHead0(pTransSlip.ShodanBango) )
							.setBiko('葬儀社オプション')
					);
				}
				else if(aSaikenOnPartner.Kamoku == KeirDenSogiTransSlips.Kamokus.SogiPlanTesuryo){
					theDeal_ForPartner.addKanjoLine(
						new KanjoLine().addCaptions(aSaikenOnPartner.Captions)
							.setKanjoKamoku('葬儀外注費（原）').setZeiKubun( this.injectTaxRate('課対仕入{0}%', pTransSlip.UriageDate) )
							.setKingaku(aSaikenOnPartner.Kingaku) .setZeiKeisanKubun('内税')
							.setBumon('葬儀').addMemoTag( this.omitHead0(pTransSlip.ShodanBango) )
							.setBiko('手数料-葬儀プラン')
					);
				}
				else if(aSaikenOnPartner.Kamoku == KeirDenSogiTransSlips.Kamokus.SogishaOptionTesuryo){
					theDeal_ForPartner.addKanjoLine(
						new KanjoLine().addCaptions(aSaikenOnPartner.Captions)
							.setKanjoKamoku('葬儀OP売上高').setZeiKubun( this.injectTaxRate('課税売上{0}%', pTransSlip.UriageDate) )
							.setKingaku(aSaikenOnPartner.Kingaku) .setZeiKeisanKubun('内税')
							.setBumon('葬儀').addMemoTag( this.omitHead0(pTransSlip.ShodanBango) )
							.setBiko('手数料-葬儀社オプション')
					);
				}
				else if(aSaikenOnPartner.Kamoku == KeirDenSogiTransSlips.Kamokus.YorisoOptionTesuryo){
					theDeal_ForPartner.addKanjoLine(
						new KanjoLine().addCaptions(aSaikenOnPartner.Captions)
							.setKanjoKamoku('葬儀外注費（原）').setZeiKubun( this.injectTaxRate('課対仕入{0}%', pTransSlip.UriageDate) )
							.setKingaku(aSaikenOnPartner.Kingaku) .setZeiKeisanKubun('内税')
							.setBumon('葬儀').addMemoTag( this.omitHead0(pTransSlip.ShodanBango) )
							.setBiko('手数料-よりそうオプション')
					);
				}
				else if(aSaikenOnPartner.Kamoku == KeirDenSogiTransSlips.Kamokus.SogiTokuyakuTesuryo){
					theDeal_ForPartner.addKanjoLine(
						new KanjoLine().addCaptions(aSaikenOnPartner.Captions)
							.setKanjoKamoku('葬儀外注費（原）').setZeiKubun( this.injectTaxRate('課対仕入{0}%', pTransSlip.UriageDate) )
							.setKingaku(aSaikenOnPartner.Kingaku) .setZeiKeisanKubun('内税')
							.setHinmoku(aSaikenOnPartner.Hinmoku)
							.setBumon('葬儀').addMemoTag( this.omitHead0(pTransSlip.ShodanBango) )
							.setBiko('手数料-特約店手数料')
					);
				}
				else{
					throw new InvalidTransSlipException( 
						String.format('unknown Kamoku:{0};', 
							new List<String>{ aSaikenOnPartner.Kamoku == null ? 'null' : String.valueOf(aSaikenOnPartner.Kamoku)  } ) 
					);					
				}
			}

			//パートナー伝票/パートナー回収代行
			for(KeirDenSogiTransSlips.KessaiFromCustomer aKessaiFromCustomer: theKessaiFromCustomerList){
				if( aKessaiFromCustomer.KessaiKouza == KeirDenSogiTransSlips.KessaiKouzas.Partner ){
					theDeal_ForPartner.addKanjoLine(
						new KanjoLine().addCaptions(aKessaiFromCustomer.Captions)
							.setKanjoKamoku('未収入金_パートナー決済').setZeiKubun( '対象外' )
							.setKingaku(aKessaiFromCustomer.Kingaku) .setZeiKeisanKubun('内税')
							.setBumon('葬儀').addMemoTag( this.omitHead0(pTransSlip.ShodanBango) )
					);
				}
			}

			if( theDeal_ForPartner.getKanjoAmount() >= 0 ){
				theDeal_ForPartner.setShiharaiKijitsu( pTransSlip.SeikyuToPartner_DueDate );
			}else{
				theDeal_ForPartner.reverseShushi();
				theDeal_ForPartner.setShiharaiKijitsu( pTransSlip.ShiharaiToPartner_DueDate );
			}
			theDeals.add(theDeal_ForPartner);
		}

		return theDeals;
	}

	private List<KeirDenSogiTransSlips.SaikenOnCustomer> reduce(List<KeirDenSogiTransSlips.SaikenOnCustomer> pList ){
		//return pList;
		Map<String, KeirDenSogiTransSlips.SaikenOnCustomer> theMap = new Map<String, KeirDenSogiTransSlips.SaikenOnCustomer>();
		for( KeirDenSogiTransSlips.SaikenOnCustomer aEntry : pList){
			List<String> theKeyElems = new List<String>();
			theKeyElems.add( String.valueOf(aEntry.Kamoku) );
			theKeyElems.add( String.isBlank(aEntry.Hinmoku) ? 'none' : aEntry.Hinmoku );
			String theKey = String.join(theKeyElems,'-');
			if( !theMap.containsKey( theKey ) ){
				theMap.put( theKey, aEntry );
			}else{
				theMap.get(theKey).Kingaku += aEntry.Kingaku;
				theMap.get(theKey).addCaptions(aEntry.Captions);
			}
		}
		return theMap.values();
	}
	private List<KeirDenSogiTransSlips.KessaiFromCustomer> reduce(List<KeirDenSogiTransSlips.KessaiFromCustomer> pList ){
		//return pList;
		Map<String, KeirDenSogiTransSlips.KessaiFromCustomer> theMap = new Map<String, KeirDenSogiTransSlips.KessaiFromCustomer>();
		for( KeirDenSogiTransSlips.KessaiFromCustomer aEntry : pList){
			List<String> theKeyElems = new List<String>();
			theKeyElems.add( String.valueOf(aEntry.KessaiKouza) );
			theKeyElems.add( String.isBlank(aEntry.SosaiSakiShodanBango) ? 'none' : aEntry.SosaiSakiShodanBango );
			theKeyElems.add( aEntry.SosaiSakiKamoku == null ? 'none' : String.valueOf(aEntry.SosaiSakiKamoku) );
			String theKey = String.join(theKeyElems,'-');
			if( !theMap.containsKey( theKey ) ){
				theMap.put( theKey, aEntry );
			}else{
				theMap.get(theKey).Kingaku += aEntry.Kingaku;
				theMap.get(theKey).addCaptions(aEntry.Captions);
			}
		}
		return theMap.values();
	}
	private List<KeirDenSogiTransSlips.SaikenOnPartner> reduce(List<KeirDenSogiTransSlips.SaikenOnPartner> pList ){
		//return pList;
		Map<String, KeirDenSogiTransSlips.SaikenOnPartner> theMap = new Map<String, KeirDenSogiTransSlips.SaikenOnPartner>();
		for( KeirDenSogiTransSlips.SaikenOnPartner aEntry : pList){
			String theKey = String.ValueOf(aEntry.Kamoku);
			if( !theMap.containsKey( theKey ) ){
				theMap.put( theKey, aEntry );
			}else{
				theMap.get(theKey).Kingaku += aEntry.Kingaku;
				theMap.get(theKey).addCaptions(aEntry.Captions);
			}
		}
		return theMap.values();
	}

	private String injectTaxRate(String pTemplate, Date pHasseiDate){
		Integer theTaxRate = (Integer)(this.m_TaxRates.getRate(pHasseiDate) * 100);
		return String.format( pTemplate, new List<String>{ String.valueOf(theTaxRate) } );
	}

	public List<FreDlCsvRow__c> toFreDlCsvRows(List<Deal> pDeals, String pShodanBango){

		List<FreDlCsvRow__c> theRows = new List<FreDlCsvRow__c>();

		Integer DealCount = 0;
		for(Deal aDeal : pDeals){
			DealCount++;
			String theDealNo = String.Join( new List<String>{ pShodanBango , String.valueOf(DealCount) } ,'-' );

			Integer LineNo = 0;
			theRows.add(
				new FreDlCsvRow__c(
					KanriBango__c = aDeal.KanriBango,
					DealNo__c = theDealNo, RowType__c = 'Header', DealLineNo__c = LineNo,
					ShushiKubun__c = aDeal.ShushiKubun, HasseiDate__c = aDeal.HasseiDate, 
					ShiharaiKijitsu__c = aDeal.ShiharaiKijitsu, TorihikisakiName__c = aDeal.TorihikisakiName,
					Captions__c = (aDeal.Captions == null ? '' : JSON.serializePretty(aDeal.Captions).Left(500) )
				)
			);

			for( KanjoLine aKanjoLine : aDeal.KanjoLines ){
				LineNo ++;
				theRows.add(
					new FreDlCsvRow__c(
						DealNo__c = theDealNo, RowType__c = 'Kanjo', DealLineNo__c = LineNo,
						KanjoKamoku__c = aKanjoLine.KanjoKamoku, ZeiKubun__c = aKanjoLine.ZeiKubun, Kingaku__c = aKanjoLine.Kingaku,
						ZeiKeisanKubun__c = aKanjoLine.ZeiKeisanKubun, ZeiGaku__c = null, Biko__c = aKanjoLine.Biko,
						Hinmoku__c = aKanjoLine.Hinmoku, Bumon__c = aKanjoLine.Bumon, MemoTag__c = String.join( aKanjoLine.MemoTags, ',' ),
						Captions__c = (aKanjoLine.Captions == null ? '' : JSON.serializePretty(aKanjoLine.Captions).Left(500) )
					)
				);
			}

			for( KessaiLine aKessaiLine : aDeal.KessaiLines ){
				LineNo ++;
				theRows.add(
					new FreDlCsvRow__c(
						DealNo__c = theDealNo, RowType__c = 'Kessai', DealLineNo__c = LineNo,
						ShiharaiDate__c = aKessaiLine.ShiharaiDate, 
						ShiharaiKoza__c = aKessaiLine.ShiharaiKoza, 
						ShiharaiKingaku__c = aKessaiLine.ShiharaiKingaku,
						Captions__c = (aKessaiLine.Captions == null ? '' : JSON.serializePretty(aKessaiLine.Captions).Left(500) )
					)
				);
			}
		}

		return theRows;
	}

	private String omitHead0(String pValue){
		return pValue.left(1) == '0'
			? pValue.substring(1, pValue.length() )
			: pValue;
	}
	private String getKanriBango(String pShodanBango){
		return 'SF' + pShodanBango;
	}
}