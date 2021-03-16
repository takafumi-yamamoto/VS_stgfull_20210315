public class AnegKekImpQms implements IHdlQms{
	public static String msgType = 'AnegKekImpQms';

	public class Data{
		public String AnegKekImpDataId;
	}

	public static void onAnegKekImpDataAfterInserted(List<AnegKekImpData__c> pNewOnes){
		List<Qms__c> theQmses = new List<Qms__c>();
		for(AnegKekImpData__c aNewOne : pNewOnes){
			Data theData = new Data();
			theData.AnegKekImpDataId = aNewOne.Id;
			theQmses.add(
				QmsBld.newRoot().setMsgType( AnegKekImpQms.msgType ).setData( JSON.serialize( theData ) ).build()
			);
		}
		INSERT theQmses;
	}

	public void handleQms(Qms__c pQms){
		try{
			Data theData = (Data)JSON.deserialize(pQms.Data__c, Data.class);
			run( theData.AnegKekImpDataId );
			UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Completed);
		}catch(Exception ex){
			UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Failed);
			Loggings.writeLog(
				Loggings.createLogEntry(Loggings.Level.Error, '20191029-1554', msgType)
					.setSubjectRecordId(pQms.Id)
					.putAttr('Exception', ex.getMessage())
					.putAttr('LineNumber', '' + ex.getLineNumber())
					.putAttr('getStackTraceString', ex.getStackTraceString())
			);
		}
	}

	public static void run(Id pAnegKekImpDataId){

		AnegKekImpData__c theImpData = (AnegKekImpData__c) SobjectsExtension.firstOrNull(
			[
				SELECT Id, 
				KameitenTorihikiId__c, NpTorihikiId__c,
				KakuteiDate__c, KakuteiKingaku__c,
				SaiteiKingaku__c, 
				AddonKingaku1__c, AddonKingaku2__c, AddonKingaku3__c, AddonKingaku4__c
				FROM AnegKekImpData__c
				WHERE Id = :pAnegKekImpDataId
			]
		);

		Opportunity theOpp = (Opportunity)SobjectsExtension.firstOrNull(
			[
				SELECT Id,
				(SELECT Id FROM AnegKek__r)
				FROM Opportunity 
				WHERE ShodanBango__c = :theImpData.KameitenTorihikiId__c
			]
		);
		if(theOpp == null){
			UPDATE New AnegKekImpData__c (Id = theImpData.Id, ShoriStatus__c = 'Failed',ShoriDescr__c = '該当商談なし;');
			return;
		}
		if(theOpp.AnegKek__r.size() > 0){
			UPDATE New AnegKekImpData__c (Id = theImpData.Id, ShoriStatus__c = 'Failed',ShoriDescr__c = '既に後値決め結果が存在;');
			return;
		}

		KeirSimeLocks.turnOffLockRule();
		AnegKek__c theAnegKek = new AnegKek__c(
			OppRef__c = theOpp.Id,
			KameitenTorihikiId__c = theImpData.KameitenTorihikiId__c,
			NpTorihikiId__c = theImpData.NpTorihikiId__c,
			KakuteiDate__c = theImpData.KakuteiDate__c,
			SaiteiKingaku__c = theImpData.SaiteiKingaku__c
		);
		INSERT theAnegKek;

		List<AnegKekAddOnPay__c> theAnegKekAddOnPays = new List<AnegKekAddOnPay__c>{
			new AnegKekAddOnPay__c(
				AnegKek__c = theAnegKek.Id, Kingaku__c = theImpData.AddonKingaku1__c,
				PaidFor__c = '①お坊さんは礼儀正しく良い印象でしたか？', PaidTo__c = 'Partner'
			),
			new AnegKekAddOnPay__c(
				AnegKek__c = theAnegKek.Id, Kingaku__c = theImpData.AddonKingaku2__c,
				PaidFor__c = '②ご法務の内容はご満足されましたか？', PaidTo__c = 'Partner'
			),
			new AnegKekAddOnPay__c(
				AnegKek__c = theAnegKek.Id, Kingaku__c = theImpData.AddonKingaku3__c,
				PaidFor__c = '③オペレーターは傾聴し、よりそう姿勢が感じられる対応でしたか？', PaidTo__c = 'Yoriso'
			),
			new AnegKekAddOnPay__c(
				AnegKek__c = theAnegKek.Id, Kingaku__c = theImpData.AddonKingaku4__c,
				PaidFor__c = '④お申し込みからお坊さんのお手配が完了するまではスムーズでしたか？', PaidTo__c = 'Yoriso'
			)
		};
		INSERT theAnegKekAddOnPays;

		KeirDenVers.updateVersionToBe(new List<KeirDenVers.ShodanChgEntry>{ new KeirDenVers.ShodanChgEntry('OBO_OPPS',theImpData.KameitenTorihikiId__c) });
		KeirSimeLocks.turnOnLockRule();
		UPDATE New AnegKekImpData__c (Id = theImpData.Id, ShoriStatus__c = 'Completed', ShoriDescr__c = '');

	}
}