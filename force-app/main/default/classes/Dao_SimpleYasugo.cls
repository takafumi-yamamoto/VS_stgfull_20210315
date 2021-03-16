public class Dao_SimpleYasugo {

	static final String SELECT_FROM  = ' SELECT '
                                    + ' Id, '
									+ ' Name, '
									+ ' ShiryoSofuHoho__c, '
									+ ' MitsumorijuryoDay__c, '
									+ ' SeikyushojuryoDay__c, '
									+ ' OmukaeSakiZipcode__c, '
									+ ' OmukaeSakiState__c, '
									+ ' OmukaeSakiCity__c, '
									+ ' OmukaeSakiStreet__c, '
									+ ' OmukaeSakiName__c, '
									+ ' SokyakushoKisaiJiko__c, '
									+ ' TaishoushaBotsunengappi__c, '
									+ ' GoanchisakiJusho__c, '
									+ ' KiboGoanchisaki__c, '
									+ ' AnchiSaki__c, '
									+ ' KiboAreaRef__r.Name, '
									+ ' TaishoshaRef__c, ' // TaishoshaRef__r.AcvmSimYasSiryoMinDate__c,'
									+ ' TaishoshaMemberTokutenKubun__c, '
									+ ' TaishoshaMemberTokutenKubunCode__c, '
									+ ' TaishoshaMemberKubun__c, '
									+ ' TaishoshaMemberKubunCode__c, '
									+ ' TaishoshaRef__r.Syuha__c, '
									+ ' TaishoshaAddress__c, '
									+ ' TaishoshaJuminhyouAddress__c, '
									+ ' TaishoshaGender__c, '
									+ ' TaishoushaSeinengappi__c, '
									+ ' TaishoshaAge__c, '
									+ ' TaishoshaRef__r.Name, '
									+ ' TaishoshaRef__r.NameFurigana__c, '
									+ ' TaishoshaRef__r.Phone, '
									+ ' TaishoshaRef__r.MobilePhone__c, '
									+ ' TaishoshaRef__r.LastName, '
									+ ' TaishoshaRef__r.FirstName, '
									+ ' TaishoshaNameFurigana__c, '
//									+ ' JuyoRenrakuJiko__c, '
									+ ' MonkArrangements__c, '
									+ ' MoshuAddress__c, '
									+ ' MoshuTelNo__c, '
									+ ' MoshuRef__r.LastName, '
									+ ' MoshuRef__r.FirstName, '
									+ ' MoshuRef__r.Name, '
									+ ' MoshuRef__r.NameFurigana__c, '
									+ ' MoshuRef__r.Phone, '
									+ ' MoshuRef__r.MobilePhone__c, '
									+ ' MoshuFurigana__c, '
									+ ' SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name, '
									+ ' ZokugaraSodanshaNitottenoTaishosha__c, '
									+ ' TaishoshaBodaijinoUmu__c, '
									+ ' SimpleYasugoKeiyakuRef__r.Teikeisaki__r.YusenFaxFormula__c, '
									+ ' SimpleYasugoKeiyakuRef__r.FaxSoshinsakiFukusuAri__c, '
         //                           + ' CaseRef__c, '
         //                           + ' CaseRef__r.RecordTypeId, '
									//+ ' CaseRef__r.Name, '
									+ ' ButsuguNashiKibo__c, '
									+ ' SaidanKibo__c, '
									+ ' KanjoHanatabaKibo__c, '
									+ ' KagobanaKibo__c, '
									+ ' MakurabanaKibo__c, '
									+ ' OpportunityRef__c '
                                    + ' FROM SimpleYasugo__c ';

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
	static public List<SimpleYasugo__c> getList(String whereString, List<String> whereParams, List<List<String>> whereArrayableParams, String strOrderByParam){
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
	static public List<SimpleYasugo__c> getList(String strWhereParam, String strOrderByParam){
		return Database.query(SELECT_FROM + strWhereParam + strOrderByParam);
	}


	/**
	 * シンプル安豪取得　ID検索
	 * @param  recordId レコードID
	 * @return          シンプル安豪
	 */ 
	static public SimpleYasugo__c SearchById(String recordId){
		// ----- パラメータ -------
		List<String> params = new List<String>();
		params.add(recordId); // param0で参照
		// ----- パラメータ(配列型) -------
		List<List<String>> arrayableParams = new List<List<String>>();

		String whereString = 'WHERE id = :param0'; // 規則に従ったバインド変数名にする。
		String strOrderByParam = '';
		List<SimpleYasugo__c> results = getList(whereString, params, arrayableParams, strOrderByParam);
		if(!results.isEmpty()) {
			return results[0];
		}
		return null;
	}

	// まとめ取得
	
	 static public List<SimpleYasugo__c> SearchByIds(List<String> idList){
	 	// ----- パラメータ -------
	 	List<String> params = new List<String>();
	 	// ----- パラメータ(配列型) -------
	 	List<List<String>> arrayableParams = new List<List<String>>();
	 	arrayableParams.add(idList); // arrayableParam0 にバインド

		
	 	String whereString = 'WHERE id in (:arrayableParam0) '; // 規則に従ったバインド変数名にする。
	 	String strOrderByParam = 'ORDER BY id';
	 	return getList(whereString, params, arrayableParams, strOrderByParam);
	 }

	static public Map<ID, SimpleYasugo__c> getMapByIds(list<id> ids){
		return new Map<ID, SimpleYasugo__c>([
				 								SELECT 
			                                		Id,
													(SELECT Id
														FROM OpportunitysSimpleYasugo__r
														WHERE Utiagebi__c = THIS_MONTH
													)
			                                 	FROM SimpleYasugo__c
			                                 	WHERE ID = :ids
		                                 	]);
	}


	 static public List<SimpleYasugo__c> getByIds(List<Id> idList){

		return Database.query(SELECT_FROM +  + 'where Id in :idList');
	 }
}