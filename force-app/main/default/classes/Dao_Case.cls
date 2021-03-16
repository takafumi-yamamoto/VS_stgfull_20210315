public class Dao_Case {
	/*** ケース レコードタイプ START **/

	public static final String RT_NAME_SIMPLE_YASUGO_SHIRYO_SEIKYU_WEB 	= 'シンプル安豪-資料請求Webフォーム';
	public static final String RT_NAME_SIMPLE_YASUGO_TOIAWASE_WEB		= 'シンプル安豪-お問い合わせWebフォーム';
	public static final String RT_NAME_SIMPLE_YASUGO_ENDINGNOTE_WEB     = 'シンプル安豪-エンディングノート請求Webフォーム';
    public static final String RT_NAME_SIMPLE_YASUGO_TOIAWASE  	        = 'シンプル安豪-お問合せ';
	public static final String RT_NAME_OBOUSANBIN_SHIRYO_SEIKYU 	    = 'お坊さん便-資料請求';
	public static final String RT_NAME_OBOUSANBIN_NET_YOYAKU            = 'お坊さん便-ネット予約';
	public static final String RT_NAME_OBOUSANBIN_TEHAI_DAIKOU          = 'お坊さん便-手配代行';
	public static final String RT_NAME_OBOUSANBIN                       = 'お坊さん便';
	public static final String RT_NAME_OMUKAEFREE                       = 'お迎えフリー';
	public static final String RT_NAME_PARTNER_SUPPORT                  = 'パートナー支援';
	public static final String RT_NAME_BESTBUTSUDAN                     = 'ベスト仏壇';
	public static final String RT_NAME_JIZENWARI_WEB                    = '事前割-Web申込';
	public static final String RT_NAME_KYOUKA                           = '供花配達レビ';
	public static final String RT_NAME_HAKAPITA                         = '墓ピタ';
	public static final String RT_NAME_SPACEFUNERAL                     = '宇宙葬';
	public static final String RT_NAME_KAKUYASUBOSEKI                   = '格安の墓石';
	public static final String RT_NAME_PERPETUALMEMORIAL                = '永代供養';
	public static final String RT_NAME_KAIYOUMIE                        = '海洋散骨';
	public static final String RT_NAME_SEIZENKEIYAKU                    = '生前契約';
	public static final String RT_NAME_SOUGIREV                         = '葬儀レビ';
	public static final String RT_NAME_TAIMENSODAN                      = '対面相談';	


	/*** ケース レコードタイプ END **/


	static final String SELECT_FROM  = ' SELECT '
                                    + '  Id '
									+ ' ,KiboAreaState__c '
									+ ' ,KiboAreaCity__c '
                                    + ' ,RecordTypeId '
									+ ' ,TaishoushaJokyo__c '
									//issues3806--Start--
									+ ' ,TaishoshaKyojuKeitai__c '
									+ ' ,TaishoshaYomeiKikan__c '
									+ ' ,ToiawaseKiinsha__c '
									//issues3806--End--
									+ ' ,Entrance__c'
     								+ ' ,AccountId'
     								+ ' ,Account.Name'
     								+ ' ,ImporantMessage__c'
     								+ ' ,Subject'
     								+ ' ,SiryoSeikyoAri__c'
     								+ ' ,Description'
									
									// 取引先系項目
									+ ' ,LastName__c'
									+ ' ,LastNameKana__c'
									+ ' ,Firstname__c'
									+ ' ,FirstNameKana__c'
									+ ' ,TelNo__c'
									+ ' ,MailAddress__c'
									+ ' ,PostalCode__c'
									+ ' ,State__c'
									+ ' ,City__c'
									+ ' ,Street__c'
									+ ' ,ToiawaseDate__c'
									+ ' ,ShiryoSoufuHoho__c'
									+ ' ,EndingNoteFlg__c'
									+ ' ,TaishoshaRef__c'
									+ ' ,TaishoshaGaMoshikomishaToDoitsu__c'
									+ ' ,ZokugaraSodanshaNitottenoTaishosha__c'
									+ ' ,ZokugaraSodanshaNitottenoTaishoshaSonota__c'
									+ ' ,OmukaesakiMeisho__c'
									+ ' ,OmukaesakiZipCode__c'
									+ ' ,OmukaesakiState__c'
									+ ' ,OmukaesakiCity__c'
									+ ' ,OmukaesakiStreet__c'
									+ ' ,KiboPlan__c'
									+ ' ,AnchiKubun__c'
									+ ' ,ObosanbinOption__c'
									//　資料請求
									+ ' ,ShiryohassosakiCity__c'
									+ ' ,ShiryohassosakiZipCode__c'
									+ ' ,ShiryohassosakiState__c'
									+ ' ,ShiryohassosakiStreet__c'
									+ ' ,Riyokaisu__c'
									+ ' ,KaimyoPlan__c'
									+ ' ,HojiHoyo__c'
									
									+ ' ,ShiryoSoufuSakiAtena__c'
									+ ' ,ShiryoSoufuSakiAtenaKana__c'
									+ ' ,ShiryoSoufuSakiMailAddress__c'
									+ ' ,ShiharaiHouhou__c'

                                    + ' FROM Case ';

	

	/**
	 * 汎用ケース取得関数（バインド変数・IN句対応版）
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
	static public List<Case> getList(String whereString, List<String> whereParams, List<List<Id>> whereArrayableParams, String strOrderByParam){
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
		List<Id> arrayableParam0;
		List<Id> arrayableParam1;
		List<Id> arrayableParam2;
		List<Id> arrayableParam3;
		List<Id> arrayableParam4;

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
	 * 汎用ケース取得関数
	 * @param  strWhereParam   strWhereParam description
	 * @param  strOrderByParam strOrderByParam description
	 * @return                 return description
	 */
	static public List<Case> getList(String strWhereParam, String strOrderByParam){
		return Database.query(SELECT_FROM + strWhereParam + strOrderByParam);
	}

	static public Map<ID, Case> getCaseMapByIds(Set<Id> pIds){
		return new Map<ID, Case>((List<Case>)Database.query(SELECT_FROM + 'where id in :pIds'));
	}

	static public List<Case> SearchByIds(List<Id> idList){
		// ----- パラメータ -------
		List<Id> params = new List<Id>();
		// ----- パラメータ(配列型) -------
		List<List<Id>> arrayableParams = new List<List<Id>>();
		arrayableParams.add(idList); // arrayableParam0 にバインド
		
		// String whereString = 'WHERE id in (:arrayableParam0) '; // 規則に従ったバインド変数名にする。
		String strOrderByParam = ' ORDER BY id';

		// バインド変数verがうまく動かないので、暫定でjoin実装
		String whereString = 'WHERE id in (\'' + String.join(idList, '\',\'') + '\') '; // 規則に従ったバインド変数名にする。
		System.debug(whereString + strOrderByParam);
		return getList(whereString, strOrderByParam);
	}
	
}