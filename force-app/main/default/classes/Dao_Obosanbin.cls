public class Dao_Obosanbin {
	public static final String SELECT_FROM_SUB = ' SELECT '
                                    + ' Id, '
									+ ' Name, '
									+ ' Iriguchi__c, '
									+ ' BodaijinoUmu__c, '
									+ ' MemorialServicePlan__c, '
									+ ' MemorialContent__c, '
									+ ' BuddOthr__c, '
									+ ' Kaimyo__c, '
									+ ' SekoTantoSoryoShuha__c, '
									+ ' SekoTantoSoryoSangoJiinMei__c, '
									+ ' SekoTantoSoryoShukyoHojinShubetsu__c, '
									+ ' SekoTantoSoryoSoryoKyojuchi__c, '
									+ ' SonotaSogisha__c, '
									+ ' HoyoBashoMei__c, '
									+ ' HoyoBashoAddress__c, '
									+ ' HoyoBashoTEL__c, '
									+ ' TsuyaDateTime_Inp__c, '
									+ ' KokubetsuDateTime_Inp__c, '
									+ ' KokubetsushikiNichiji__c, '
									+ ' ShukkanDateTimei_Inp__c, '
									+ ' KasoDateTime_Inp__c, '
									+ ' Shonanoka__c, '
									+ ' Saijo__c, '
									+ ' Sogisha__r.Name, '
									+ ' Kasoba__c, '
									+ ' MoshuRef__c, '
									+ ' MoshuName__c, '
									+ ' MoshuFurigana__c, '
									+ ' Taishosha1Ref__c, '
									+ ' Taishosha1Ref__r.LastName, '
									+ ' Taishosha1Ref__r.FirstName, '
									+ ' Taishosha1Ref__r.SeinengappiWareki__c, '
									+ ' Taishosha1Ref__r.BotsunengappiWareki__c, '
									+ ' Taishosha1Ref__r.Syuha__c, '
									+ ' Taishosha1Furigana__c, '
									+ ' Taishosha1Ref__r.ManNenreiExp__c, '
    								+ ' Taishosha1Ref__r.SonotanoSyukyoSyuha__c, '
									+ ' MoshuRef__r.LastName, '
									+ ' MoshuRef__r.FirstName, '
									+ ' MoshuRef__r.phone, '
									+ ' MoshuRef__r.MobilePhone__c, '
									+ ' MoshuKyojuchi__c, '
									+ ' Taishosha1Age__c, '
									//+ ' Taishosha1Botsunengappi__c, '
									//+ ' Taishosha1Seinengappi__c, '
									+ ' Taishosha1Gender__c, '
									+ ' ZokugaraMoshuNitottenoTaishosha1__c, '
									+ ' ZokugaraSodanshaNitottenoTaishosha1__c, '
									+ ' Sogisha__c, '
									+ ' Sogisha__r.NameYago__c, '
									+ ' SogiTantosha__c, '
									+ ' SogiTantoshaTel__c, '
									+ ' SogiTantoshaFax__c, '
									+ ' Tehai__c, '
									+ ' SekotantoSoryoSoryomei__c, '
									+ ' SekoTantoSoryoSoryoRenrakusaki__c, '
									+ ' NyukinDay__c, '
									+ ' NyukinShimeDay__c, '
									+ ' ShiryoSofubi__c, '
									+ ' SekoTantoSoryoFax__c, '
									+ ' TicketExpirationDate__c, '
									+ ' Makurakyo__c, '
									+ ' IraishoKisaiJiko__c, '
									+ ' TehaishoKisaiJiko__c, '
									+ ' SekoTantoSoryoSoryoId__c, '
									+ ' ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.Name, '
									+ ' ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.SeiKana__c, '
									+ ' ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.MeiKana__c, '
									//+ ' ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.LastName, '
									+ ' ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.YusenFaxFormula__c, '
									+ ' ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.TorihikisakiBangoF__c, '
									+ ' ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.Syuha__c, '
									+ ' ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.Name, '
									+ ' ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.HoujinTanniKubun__c,'
									+ ' ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.SyusiSyuhaExp__c,'
									+ ' ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.BillingAddressFormula__c, '
									+ ' ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.BillingState, '
									+ ' ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.YusenTelNoFormula__c, '
									+ ' SaijoAddress__c, '
									+ ' MoshuRef__r.BillingPostalCode, '
									+ ' MoshuRef__r.BillingState, '
									+ ' MoshuRef__r.BillingCity, '
									+ ' MoshuRef__r.BillingStreet, '
									+ ' SaijoPhone__c, '
									+ ' FinalDecisionTotalAmount__c, '
									+ ' TicketSendingDate__c, IraiTehaiDate__c, '
									+ ' Taishosha1Ref__r.Age__pc, '
									+ ' ObosanbinKeiyakuMadoguchi__r.ObousanBinTehaiKubun__c ';
	static final String SELECT_FROM  = SELECT_FROM_SUB
                                    + ' FROM Obosanbin__c ';

	/**
	 * 汎用シンプル安豪取得関数（バインド変数・IN句対応版）
	 * 　バインド変数を用いたIN句の使用のため。
	 *   Integer型・Date型等には現状非対応
	 *
	 * @Auther Mizuno
	 * @param  whereString          Where句。バインド変数の指定方法についてはパラメータのコメント参照。
	 * @param  whereParams          非リスト型のパラメータの配列。文字列等。Where文ではparamXの形式で参照する。
	 * @param  whereArrayableParams リスト型のパラメータの配列。ID配列等。Where文ではarraybleParamXの形式で参照する。
	 * @param  strOrderByParam      strOrderByParam OrderBy句
	 * @return                      return description
	 */
	static public List<Obosanbin__c> getList(String whereString, List<String> whereParams, List<List<String>> whereArrayableParams, String strOrderByParam){
		// このステートメントに定義されている変数が、バインド変数として使用できる。
		// Database.Queryを使用する場合は通常のSOQLと異なり、
		// param[0]のような表現や関数実行結果は使用できないため、
		// 一度素の変数に展開する必要がある。
		// 暫定で各5パラメータに対応
		String param0;
		String param1;
		String param2;
		String param3;
		String param4;
		List<String> arrayableParam0;
		List<String> arrayableParam1;
		List<String> arrayableParam2;
		List<String> arrayableParam3;
		List<String> arrayableParam4;

		if(whereParams != null) {
			param0 = (whereParams.size()>0) ? whereParams[0] : null;
			param1 = (whereParams.size()>1) ? whereParams[1] : null;
			param2 = (whereParams.size()>2) ? whereParams[2] : null;
			param3 = (whereParams.size()>3) ? whereParams[3] : null;
			param4 = (whereParams.size()>4) ? whereParams[4] : null;
		}
		
		if(whereArrayableParams != null) {
			arrayableParam0 = (whereArrayableParams.size()>0) ? whereArrayableParams[0] : null;
			arrayableParam1 = (whereArrayableParams.size()>1) ? whereArrayableParams[1] : null;
			arrayableParam2 = (whereArrayableParams.size()>2) ? whereArrayableParams[2] : null;
			arrayableParam3 = (whereArrayableParams.size()>3) ? whereArrayableParams[3] : null;
			arrayableParam4 = (whereArrayableParams.size()>4) ? whereArrayableParams[4] : null;
		}

		return Database.query(SELECT_FROM + whereString + strOrderByParam);
	}
	
	/**
	 * 汎用シンプル安豪取得関数
	 * @param  strWhereParam   strWhereParam description
	 * @param  strOrderByParam strOrderByParam description
	 * @return                 return description
	 */
	static public List<Obosanbin__c> getList(String strWhereParam, String strOrderByParam){
		return Database.query(SELECT_FROM + strWhereParam + strOrderByParam);
	}


	/**
	 * シンプル安豪取得　ID検索
	 * @param  recordId レコードID
	 * @return          シンプル安豪
	 */ 
	static public Obosanbin__c SearchById(String recordId){
		// ----- パラメータ -------
		List<String> params = new List<String>();
		params.add(recordId); // param0で参照
		// ----- パラメータ(配列型) -------
		List<List<String>> arrayableParams = new List<List<String>>();

		String whereString = 'WHERE id = :param0'; // 規則に従ったバインド変数名にする。
		String strOrderByParam = '';
		List<Obosanbin__c> results = getList(whereString, params, arrayableParams, strOrderByParam);
		if(!results.isEmpty()) {
			return results[0];
		}
		return null;
	}

	// まとめ取得
	
	 static public List<Obosanbin__c> SearchByIds(List<String> idList){
	 	// ----- パラメータ -------
	 	List<String> params = new List<String>();
	 	// ----- パラメータ(配列型) -------
	 	List<List<String>> arrayableParams = new List<List<String>>();
	 	arrayableParams.add(idList); // arrayableParam0 にバインド

		
	 	String whereString = 'WHERE id in (:arrayableParam0) '; // 規則に従ったバインド変数名にする。
	 	String strOrderByParam = 'ORDER BY id';
	 	return getList(whereString, params, arrayableParams, strOrderByParam);
	 }

	 
	/////////////////////////////////////////////
	private static Dao_Obosanbin instance;
	public static Dao_Obosanbin getInstance(){
		if(instance == null){
			instance = new Dao_Obosanbin(Dao_Account.getInstance());
		}
		return instance;
	}

	private Dao_Account f_Dao_Account;

	public Dao_Obosanbin(Dao_Account pDao_Account){
		this.f_Dao_Account = pDao_Account;
	}
	private String getSelectBody(){
		return Dao_Obosanbin.SELECT_FROM + 'where id != null ';
	}

	// public List<Obosanbin__c> selectByKeiyakuTorihikisakiId(String pKeiyakuTorihikisakiId){
	// 	List<Obosanbin__c> theEntities = new List<Obosanbin__c>();
	// 	Account theAccount = this.f_Dao_Account.selectById(pKeiyakuTorihikisakiId);
	// 	if(theAccount == null) return theEntities;
	// 	Id theAccountId = theAccount.Id;
	// 	return Database.query(this.getSelectBody() + 'and KeiyakuSha__c = :theAccountId');
	// }

	public List<Obosanbin__c> selectByIds(List<Id> pIds){
		return Database.query(this.getSelectBody() + 'and Id in :pIds');
	}
}