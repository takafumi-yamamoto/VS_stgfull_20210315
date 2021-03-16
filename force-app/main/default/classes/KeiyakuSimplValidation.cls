public class KeiyakuSimplValidation {

	private static String recordTypeIdKeiyakuSimple = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
	
	public static void onKeiyakuSimplUpsert(List<Keiyaku__c> newList){
		
		Map<Id, Keiyaku__c> oldMap = new Map<Id, Keiyaku__c>([select Id, 
																	Keiyakukaishibi__c,
																	Teikeisaki__c, 
																	Teikeisaki__r.KinyukikanCodeTosha__c, 
																	Teikeisaki__r.KinyukikanMeiTosha__c, 
																	Teikeisaki__r.KozaShubetsuTosha__c, 
																	Teikeisaki__r.KozaBangoTosha__c, 
																	Teikeisaki__r.KozaMeigiKanaTosha__c, 
																	Teikeisaki__r.KozaMeigiTosha__c, 
																	Teikeisaki__r.ShitenCodeTosha__c, 
																	Teikeisaki__r.ShitenMeiTosha__c, 
																	(
																		select Id 
																		from Keiyaku_TesuryoTekiyos__r 
																		where ShoninStatus__c = '承認済' 
																		and TekiyoKaishiBi__c <= :date.today() 
																		and TekiyoSyuryoBi__c >= :date.today()
																	) 
																from Keiyaku__c 
																where Id = :newList]);
		
		for(Keiyaku__c newOne : newList){

			if(newOne.RecordTypeId != recordTypeIdKeiyakuSimple) continue;

			chgKeiyakuStatusKeiyakuchuInsert(newOne);
			chkKeiyakuStatusKeiyakuchuRequiredKeiyakuKaishibi(newOne);
			chkKeiyakuStatusKeiyakuchuRequiredSeikyushoHassoCycle(newOne);
			chkKeiyakuStatusKeiyakuchuRequiredNyukinshimekiriJoken(newOne);
			chgKeiyakuStatusKeiyakuchuToshaFurikomiKoza(newOne, oldMap);
			chgKeiyakuStatusKeiyakuchuYukoTesuryoTekiyo(newOne, oldMap);
		}
	}

	private static void chgKeiyakuStatusKeiyakuchuInsert(Keiyaku__c newOne){

		if( newOne.KeiyakuJokyo__c != '契約中' ) return;
		if( newOne.Id != null ) return;
		newOne.addError('有効な手数料適用がないため【契約状況】を契約中にできません。');
	}

	private static void chkKeiyakuStatusKeiyakuchuRequiredKeiyakuKaishibi(Keiyaku__c newOne){

		if( newOne.KeiyakuJokyo__c != '契約中' ) return;
		if( newOne.Keiyakukaishibi__c != null) return;
		newOne.addError('【契約開始日】が未入力です。');
	}

	private static void chkKeiyakuStatusKeiyakuchuRequiredSeikyushoHassoCycle(Keiyaku__c newOne){

		if( newOne.KeiyakuJokyo__c != '契約中' ) return;
		if( newOne.SeikyushoHassoCycle__c != null) return;
		newOne.addError('【請求書発送サイクル】が未入力です。');
	}

	private static void chkKeiyakuStatusKeiyakuchuRequiredNyukinshimekiriJoken(Keiyaku__c newOne){

		if( newOne.KeiyakuJokyo__c != '契約中' ) return;
		if( newOne.NyukinSimekiriJouken__c != null) return;
		newOne.addError('【入金締切条件】が未入力です。');
	}

	private static void chgKeiyakuStatusKeiyakuchuToshaFurikomiKoza(Keiyaku__c newOne, Map<Id, Keiyaku__c> oldMap){

		if( newOne.KeiyakuJokyo__c != '契約中' ) return;
		if( newOne.Id == null ) return;

		Keiyaku__c oldOne = oldMap.get(newOne.Id);
		if( oldOne.Teikeisaki__r.KinyukikanCodeTosha__c == null || 
			oldOne.Teikeisaki__r.KinyukikanMeiTosha__c == null || 
			oldOne.Teikeisaki__r.KozaShubetsuTosha__c == null || 
			oldOne.Teikeisaki__r.KozaBangoTosha__c == null || 
			oldOne.Teikeisaki__r.KozaMeigiKanaTosha__c == null || 
			oldOne.Teikeisaki__r.KozaMeigiTosha__c == null || 
			oldOne.Teikeisaki__r.ShitenCodeTosha__c == null || 
			oldOne.Teikeisaki__r.ShitenMeiTosha__c == null ){
			newOne.addError('提携先の当社振込用口座情報に不備があります。');
		}
	}

	private static void chgKeiyakuStatusKeiyakuchuYukoTesuryoTekiyo(Keiyaku__c newOne, Map<Id, Keiyaku__c> oldMap){

		if( newOne.KeiyakuJokyo__c != '契約中' ) return;
		if( newOne.Id == null ) return;

		Keiyaku__c oldOne = oldMap.get(newOne.Id);
		if (oldOne.Keiyaku_TesuryoTekiyos__r.size() != 1) newOne.addError('有効な手数料適用がない、または複数存在します。');
	}
}