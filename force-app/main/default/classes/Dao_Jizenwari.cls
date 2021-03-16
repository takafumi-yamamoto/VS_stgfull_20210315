public class Dao_Jizenwari {

	static final String SELECT_FROM  
		= ' SELECT '
		+ ' Id, KeiyakuSha__c,'
		+ ' NyukinDay__c, MoushikomiKanryoBi__c, Yuko_kigenStart__c,NyukinKakuninTsuchiBi__c,'
		+ ' JizenWariPlanNameExp__c, settleCompleteDate__c, RiyoKaisuSeigenAriExp__c,'
		+ ' StageName__c, '
    	+ ' JizenWariPlanRef__c, '
    	+ ' Yuko_kigenEnd__c, '
		+ ' cancelReceiptDate__c, KeiyakuStatusCdExp__c, JizenWariPlanCodeExp__c, Name__c '
		+ ' FROM Jizenwari__c ';

	/**
	 * 汎用事前割取得関数（バインド変数・IN句対応版）
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
	static public List<Jizenwari__c> getList(String whereString, List<String> whereParams, List<List<String>> whereArrayableParams, String strOrderByParam){
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
	 * 汎用事前割取得関数
	 * @param  strWhereParam   strWhereParam description
	 * @param  strOrderByParam strOrderByParam description
	 * @return                 return description
	 */
	static public List<Jizenwari__c> getList(String strWhereParam, String strOrderByParam){

		return Database.query(SELECT_FROM + strWhereParam + strOrderByParam);
	}


	/**
	 * 事前割取得　ID検索
	 * @param  recordId レコードID
	 * @return          事前割
	 */ 
	static public Jizenwari__c SearchById(String recordId){
		// ----- パラメータ -------
		List<String> params = new List<String>();
		params.add(recordId); // param0で参照
		// ----- パラメータ(配列型) -------
		List<List<String>> arrayableParams = new List<List<String>>();

		String whereString = 'WHERE id = :param0'; // 規則に従ったバインド変数名にする。
		String strOrderByParam = '';
		List<Jizenwari__c> results = getList(whereString, params, arrayableParams, strOrderByParam);
		if(!results.isEmpty()) {
			return results[0];
		}
		return null;
	}

	// まとめ取得
	
	 static public List<Jizenwari__c> SearchByIds(List<String> idList){
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
	private static Dao_Jizenwari instance;
	public static Dao_Jizenwari getInstance(){
		if(instance == null){
			instance = new Dao_Jizenwari(Dao_Account.getInstance());
		}
		return instance;
	}

	private Dao_Account f_Dao_Account;

	public Dao_Jizenwari(Dao_Account pDao_Account){
		this.f_Dao_Account = pDao_Account;
	}
	private String getSelectBody(){
		return Dao_Jizenwari.SELECT_FROM + 'where id != null ';
	}

	public List<Jizenwari__c> selectByKeiyakuTorihikisakiId(String pKeiyakuTorihikisakiId){
		List<Jizenwari__c> theEntities = new List<Jizenwari__c>();
		//todo:　f_Dao_Account.selectById　要らない
		Account theAccount = this.f_Dao_Account.selectById(pKeiyakuTorihikisakiId);
		if(theAccount == null) return theEntities;
		Id theAccountId = theAccount.Id;
		return Database.query(this.getSelectBody() + 'and KeiyakuSha__c = :theAccountId');
	}

	public List<Jizenwari__c> selectByIds(List<Id> pIds){
		return Database.query(this.getSelectBody() + 'and Id in :pIds');
	}


	public List<Jizenwari__c> selectByKeiyakuTorihikisakiIds(List<Id> accountIds){
		List<Jizenwari__c> theEntities = new List<Jizenwari__c>();
		if(accountIds == null || accountIds.size() == 0) return theEntities;
		return Database.query(this.getSelectBody() + 'and KeiyakuSha__c = :accountIds');
	}

}