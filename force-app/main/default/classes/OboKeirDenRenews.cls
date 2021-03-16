public class OboKeirDenRenews {
	private static String OPP_RECORDTYPE_ID_OBOSANBIN = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId();
	private static String TAGS_MULTI_KESSAI_HOUHOU = '[複数決済方法]';
	private static String TAGS_ATONEGIME_PRICE_UNFIEXED = '[後値決め-未確定]';
	private static String TAGS_ATONEGIME_PRICE_FIXED = '[後値決め-確定済]';

	public static void renew(String pShodanBango){
		
		List<OboKeirDen__c> theOldDenpyos = [SELECT Id, LastSyncVersion__c FROM OboKeirDen__c WHERE ShodanBango__c= :pShodanBango];

		//経理が取り込んだVersion
		String  theLastSyncVer = '0';
		if( theOldDenpyos.size() > 0 ) theLastSyncVer = theOldDenpyos.get(0).LastSyncVersion__c;

		Set<Id> theIdsOfOldKeirDen = new Set<Id>();
		for(OboKeirDen__c aKeirDen : theOldDenpyos){ theIdsOfOldKeirDen.add(aKeirDen.Id); }
		DELETE [ SELECT Id FROM OboKeirDenPayLine__c WHERE Id IN :theIdsOfOldKeirDen ];
		DELETE theOldDenpyos;

		Opportunity theOpp = (Opportunity)SobjectsExtension.firstOrNull(
			[
				SELECT 
				Id, ShodanBango__c, RecordTypeId, RyunyumotoService__c,
				IsClosed, IsWon,
				Utiagebi__c,
				Amount, UriageGakuPartnerExp__c, UriageCyoseiGakuPartnerExp__c, SeikyuZandaka__c,
				ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__c,
				ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.TorihikisakiBango__c,
				ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__c,
				(
					SELECT Id, Product2.ShohinBango__c, Quantity, TotalPrice, Product2.DataKubun__c, TesuryoPartner__c
					FROM OpportunityLineItems
				),
				(
					SELECT Id, SeikyuHouhou__c, SeikyuKingaku__c 
					FROM KaisyuYoteisOpportunity__r
					ORDER BY SeikyuHouhou__c
				),
				(
					SELECT Id, AddonKingakuPaidToPartner__c, AddonKingakuPaidToYoriso__c
					FROM AnegKek__r
				)
				FROM Opportunity 
				WHERE ShodanBango__c = :pShodanBango
			]
		);

		Boolean toNewKuroden = theOpp != null 
			&& theOpp.RecordTypeId == OPP_RECORDTYPE_ID_OBOSANBIN && theOpp.RyunyumotoService__c != '定額僧侶手配代行'
			&& theOpp.IsClosed && theOpp.IsWon;

		if(!toNewKuroden) issueTorikeshiDenpyo(pShodanBango, theOpp, theLastSyncVer);

		try{
			if(toNewKuroden) issueNormalDenpyo(theOpp, theLastSyncVer);
		}catch(OboKeirDenRenews.InvalidDataException ex){
			issueErrDenpyo(pShodanBango, theOpp, theLastSyncVer);
			Loggings.writeLog(
				Loggings.createLogEntry(Loggings.Level.Error, '20191108-2046', 'OboKeirDenRenews.issueErrDenpyo')
					.putAttr('pShodanBango', pShodanBango)
					.putAttr('Exception', ex.getMessage())
					.putAttr('LineNumber', '' + ex.getLineNumber())
					.putAttr('getStackTraceString', ex.getStackTraceString())
			);
		}
		
	}

	private static void issueNormalDenpyo(Opportunity pOpp, String pLastSyncVer){
		Opportunity theOpp = pOpp;
		AnegKek__c theAnegKek = theOpp.AnegKek__r.size() > 0 ? theOpp.AnegKek__r.get(0) : null;

		if( theOpp.SeikyuZandaka__c != 0) throw new InvalidDataException('invalid:お客様への請求残高 != 0');

		Account theTemple = (Account)SobjectsExtension.firstOrNull(
			[
				SELECT Id, TorihikisakiBango__c, Name
				FROM Account 
				WHERE Id = :theOpp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__c
			]
		);
		if( theTemple == null) throw new InvalidDataException('invalid:所属山号寺院なし');

		TesuryoTekiyo__c theTesuryoTekiyo = (TesuryoTekiyo__c)SobjectsExtension.firstOrNull(
			[
				SELECT 
				Id, TesuryoPlanRef__r.CoreTesuryoPlanId__c
				FROM TesuryoTekiyo__c
				WHERE KeiyakuRef__c = :theOpp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__c
				AND ShoninStatus__c = '承認済'
				AND TekiyoKaishiBi__c <= :theOpp.Utiagebi__c
				ORDER BY TekiyoKaishiBi__c DESC
			]
		);
		if( theTesuryoTekiyo == null) throw new InvalidDataException('invalid:手数料適用なし');

		Decimal theRevenue = 0;

		//一時対応 , 他社手配分の手数料の再計算
		Integer theTashaTehaiTesuryoPlanId = 3;
		if(theTesuryoTekiyo.TesuryoPlanRef__r.CoreTesuryoPlanId__c == 3){
			Decimal theProdTesuryo = 0;
			OboFeeEntries.GetUnitPriceReq theReq = new OboFeeEntries.GetUnitPriceReq();
			theReq.baseDate = theOpp.Utiagebi__c;
			theReq.coreTesuryoPlanId = theTesuryoTekiyo.TesuryoPlanRef__r.CoreTesuryoPlanId__c;
			for(OpportunityLineItem aLineItem : theOpp.OpportunityLineItems){ theReq.shohinBangos.add(aLineItem.Product2.ShohinBango__c); }
			
			OboFeeEntries.GetUnitPriceRes theRes = OboFeeEntries.getUnitPrice(theReq);
			List<OpportunityLineItem> opportunityLineItemsToBeUpdated = new List<OpportunityLineItem>();
			for(OpportunityLineItem aLineItem : theOpp.OpportunityLineItems){ 
				String theShohinBango = aLineItem.Product2.ShohinBango__c;
				if( theRes.shohinBangoToUnitPriceMap.containsKey( theShohinBango ) ){
					Decimal theUnitFeePrice = theRes.shohinBangoToUnitPriceMap.get(theShohinBango);
					Decimal newTesuryoPartner = theUnitFeePrice * aLineItem.Quantity;
					theProdTesuryo += newTesuryoPartner;
					if(aLineItem.TesuryoPartner__c != newTesuryoPartner) {
						aLineItem.TesuryoPartner__c = newTesuryoPartner;
						opportunityLineItemsToBeUpdated.add(aLineItem);
					}
				}
			}
			if(opportunityLineItemsToBeUpdated.size() > 0) { 
				KeirSimeLocks.turnOffLockRule();
				Trg_OpportunityLineItem.setTriggerInActive();
				update opportunityLineItemsToBeUpdated; 
				KeirSimeLocks.turnOnLockRule();
				Trg_OpportunityLineItem.setTriggerActive();
			}

			theRevenue = theProdTesuryo + theOpp.UriageCyoseiGakuPartnerExp__c;
		}else{
			theRevenue = theOpp.UriageGakuPartnerExp__c;
		}

		//クーポン(自社負担割引)分の振り替え 売上|原価
		Decimal theJishaFutanWaribikiGaku = 0;
		for(OpportunityLineItem aLineItem : theOpp.OpportunityLineItems){ 
			if( aLineItem.Product2.DataKubun__c == '3:クーポン') theJishaFutanWaribikiGaku += aLineItem.TotalPrice * -1;
		}
		theRevenue -= theJishaFutanWaribikiGaku;

		//create 通常伝票
		OboKeirDen__c theNewKuroden = 
			new OboKeirDen__c(
				IssuedDateTime__c = Datetime.now(),
				RenkeiShoriKbn__c = '通常',
				ShodanBango__c = theOpp.ShodanBango__c,
				OppRef__c = pOpp == null ? null : pOpp.Id,
				LastVersion__c = genNewVerNo(),
				LastSyncVersion__c = pLastSyncVer,
				SalesDate__c = theOpp.Utiagebi__c,
				PartnerId__c = theOpp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.TorihikisakiBango__c,
				TempleCD__c = theTemple.TorihikisakiBango__c, TempleName__c = theTemple.Name,
				Revenue__c = theRevenue,
				Purchase__c = theOpp.Amount - theRevenue,
				AddonKingakuPaidToPartner__c = theAnegKek == null ? 0 : theAnegKek.AddonKingakuPaidToPartner__c,
				AddonKingakuPaidToYoriso__c = theAnegKek == null ? 0 : theAnegKek.AddonKingakuPaidToYoriso__c
			);
		INSERT theNewKuroden;

		//create payment-lines
		Map<String, OboKeirDenPayLine__c> theSeikyuHouhouToPayLineMap = new Map<String, OboKeirDenPayLine__c>();
		for(OkyakusamaSeikyuMeisai__c aSeikyuMeisai : theOpp.KaisyuYoteisOpportunity__r){
			if(aSeikyuMeisai.SeikyuKingaku__c == 0) continue;
			String theSeikyuHouhou = aSeikyuMeisai.SeikyuHouhou__c;
			OboKeirDenPayLine__c theOboKeirDenPayLine = theSeikyuHouhouToPayLineMap.get( theSeikyuHouhou );
			if( theOboKeirDenPayLine == null ){
				theOboKeirDenPayLine = new OboKeirDenPayLine__c( OboKeirDenRef__c = theNewKuroden.Id,  KessaiHouhou__c = theSeikyuHouhou, Payment__c = 0);
				theSeikyuHouhouToPayLineMap.put(theSeikyuHouhou, theOboKeirDenPayLine);
			}
			theOboKeirDenPayLine.Payment__c += aSeikyuMeisai.SeikyuKingaku__c;
		}
		INSERT theSeikyuHouhouToPayLineMap.values();

		//attach tags
		String theTags = '';
		if( theSeikyuHouhouToPayLineMap.size() > 1 ) theTags += TAGS_MULTI_KESSAI_HOUHOU;
		Boolean isAtonegime = theSeikyuHouhouToPayLineMap.containsKey('NpAtoNegime');
		if( isAtonegime && theAnegKek == null ) theTags += TAGS_ATONEGIME_PRICE_UNFIEXED;
		if( isAtonegime && theAnegKek!= null ) theTags += TAGS_ATONEGIME_PRICE_FIXED;
		UPDATE new OboKeirDen__c(Id = theNewKuroden.Id, Tags__c = theTags);
	}

	private static void issueTorikeshiDenpyo(String pShodanBango, Opportunity pOpp, String pLastSyncVer){
		OboKeirDen__c theTorikeshiDen = 
			new OboKeirDen__c(
				IssuedDateTime__c = Datetime.now(),
				RenkeiShoriKbn__c = '取消',
				ShodanBango__c = pShodanBango,
				OppRef__c = pOpp == null ? null : pOpp.Id,
				LastVersion__c = genNewVerNo(),
				LastSyncVersion__c = pLastSyncVer,
				SalesDate__c = null,
				PartnerId__c = null,
				TempleCD__c = null,
				Revenue__c = 0,
				Purchase__c = 0
			);
		INSERT theTorikeshiDen;
	}

	private static void issueErrDenpyo(String pShodanBango, Opportunity pOpp, String pLastSyncVer){
		OboKeirDen__c theErrDen = 
			new OboKeirDen__c(
				IssuedDateTime__c = Datetime.now(),
				RenkeiShoriKbn__c = 'エラー',
				ShodanBango__c = pShodanBango,
				OppRef__c = pOpp == null ? null : pOpp.Id,
				LastVersion__c = genNewVerNo(),
				LastSyncVersion__c = pLastSyncVer,
				SalesDate__c = null,
				PartnerId__c = null,
				TempleCD__c = null,
				Revenue__c = 0,
				Purchase__c = 0
			);
		INSERT theErrDen;
	}

	private static String genNewVerNo(){
		return Datetime.now().format('yyyyMMddHHmmssSSS');
	}
	public class InvalidDataException extends Exception {}

}