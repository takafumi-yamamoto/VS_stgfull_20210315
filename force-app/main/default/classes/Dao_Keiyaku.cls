public class Dao_Keiyaku {

	private static Dao_Keiyaku instance;
	public static Dao_Keiyaku getInstance(){
		if(instance == null) instance = new Dao_Keiyaku();
		return instance;
	}

	private static String getSelectBody(){
		String theTokuyakutenRecTypeDevName = 'TokuyakuTen';
		return 'select '
		+ 'Id, ServiceId__c, KeiyakuBango__c, Keiyakuyuko__c, Teikeisaki__c,KeiyakuJokyo__c, '
		+ 'Teikeisaki__r.BankName__c, Teikeisaki__r.BankBranchName__c, Teikeisaki__r.BankAccountNo__c, '
		+ 'Teikeisaki__r.BankAccountType__c, Teikeisaki__r.AccountTypeForCore__c, Teikeisaki__r.BankAccountMeigi__c, '
		+ 'TeikesakiTorihikisakiBango__c, Teikeisaki__r.SougisyaNo__c, TeikeisakiTodofukenshikugunName__c, '
		+ 'Teikeisaki__r.name, Teikeisaki__r.LastName, Teikeisaki__r.firstName, '
		+ 'Teikeisaki__r.BillingPostalCode, Teikeisaki__r.BillingAddress, Teikeisaki__r.SeikyuSakiTantoName__c, '
		+ 'Teikeisaki__r.NameYagouFurigana__c, Teikeisaki__r.Phone, Teikeisaki__r.MobilePhone__c, Teikeisaki__r.SangoJiinMeiFurigana__c, Teikeisaki__r.recordtypeID,	'
		+ 'KeiyakuTantoTelNo__c, NyukinSimekiriJouken__c, Keiyakukaishibi__c, KeiyakuSyuryoBi__c, paymentCycle__c, '
		+ 'ShoriStatus__c, ShoriStatusBiko__c, TryCount__c, TryLimit__c, CreatedDate, LastModifiedDate, '
		+ '( select id, TogetsuSokyakusu__c from KeiyakusSyuKeiyaku__r where RecordType.DeveloperName = \'TokuyakuTen\' ), '
		+ '( select id from KeiyakusSimpleYasugoKeiyaku__r ) '
		+ 'from Keiyaku__c '
		+ 'where Id != null '
		;
	}

	public List<Keiyaku__c> selectByIds(List<Id> pIds){
		return database.query( getSelectBody() + 'and Id in :pIds' );
	}

	static public List<Keiyaku__c> getListByIds(list<id> ids){
		list<Keiyaku__c> keiyakuLst=[select id,recordtypeID,
		                                    //サービスID
		                                    ServiceId__c,
		                                    //契約番号
		                                    KeiyakuBango__c,
		                                    //契約有効
		                                    Keiyakuyuko__c,
											//契約状況
											KeiyakuJokyo__c,											
		                                    //提携先
		                                    Teikeisaki__c,
		                                    //銀行名
		                                    Teikeisaki__r.BankName__c,
		                                    //銀行支店名
		                                    Teikeisaki__r.BankBranchName__c,		                                    
		                                    //口座番号
		                                    Teikeisaki__r.BankAccountNo__c,
		                                    //口座種別
		                                    Teikeisaki__r.BankAccountType__c,
		                                    //口座種別(Core連携用)
		                                    Teikeisaki__r.AccountTypeForCore__c,		                                    
		                                    //口座名義
		                                    Teikeisaki__r.BankAccountMeigi__c,		                                    
		                                    //提携先の取引先番号
		                                    TeikesakiTorihikisakiBango__c,
		                                    //葬儀社番号
		                                    Teikeisaki__r.SougisyaNo__c,
		                                    //提携先都道府県市区郡名
		                                    TeikeisakiTodofukenshikugunName__c,
		                                    //提携先名
		                                    Teikeisaki__r.name,
		                                    Teikeisaki__r.LastName,
		                                    Teikeisaki__r.firstName,
		                                    //取引先.郵便番号（請求先）
		                                    Teikeisaki__r.BillingPostalCode,
		                                    //取引先.住所(請求先)
		                                    Teikeisaki__r.BillingAddress,		                                    
		                                    //取引先.経理担当者名
		                                    Teikeisaki__r.SeikyuSakiTantoName__c,
		                                    //屋号（カナ）
		                                    Teikeisaki__r.NameYagouFurigana__c,
		                                    //電話1(固定電話)
		                                    Teikeisaki__r.Phone,
		                                    Teikeisaki__r.SangoJiinMeiFurigana__c,
		                                    Teikeisaki__r.recordtypeID,	
		                                    KeiyakuTantoTelNo__c,
		                                    //入金締切条件
		                                    NyukinSimekiriJouken__c,
		                                    //契約開始日
		                                    Keiyakukaishibi__c,
		                                    //契約終了日
		                                    KeiyakuSyuryoBi__c,
		                                    //通常手数料請求サイクル
		                                    paymentCycle__c,
		                                    //処理ステータス
		                                    ShoriStatus__c,
		                                    //処理ステータス備考
		                                    ShoriStatusBiko__c,
		                                    //連携試行回数
		                                    TryCount__c,
		                                    //連携試行最大回数
		                                    TryLimit__c,
		                                    //作成日
		                                    CreatedDate,
		                                    //更新日
		                                    LastModifiedDate,
		                                    (
		                                    	select id,
		                                    			TogetsuSokyakusu__c
		                                    	from KeiyakusSyuKeiyaku__r
		                                    	where RecordType.DeveloperName = 'TokuyakuTen'
		                                    ),
		                                    (
		                                    	select id
		                                    	from KeiyakusSimpleYasugoKeiyaku__r
		                                    )
		                               from Keiyaku__c
		                               where id in :ids];
		return keiyakuLst;
	}
}