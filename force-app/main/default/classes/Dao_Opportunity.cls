public class Dao_Opportunity {
	//商談のレコードタイプ名
    public static final string RD_NAME_TORIHIKISHODAN    = '取引商談';
    public static final String RD_NAME_SIMPLE_YASUGO 	 = 'シンプル安豪';
    public static final String RD_NAME_SEIZENKEIYAKU 	 = '生前契約';
    public static final String RD_NAME_OBOSANBIN 	     = 'お坊さん便';
    public static final String RD_NAME_PERPETUALMEMORIAL = '永代供養';
    public static final String RD_NAME_BESTBUTSUDAN 	 = 'ベスト仏壇';
    public static final String RD_NAME_KYOUKA 	         = '供花配達レビ';
    public static final String RD_NAME_KAIYOUMIE 	     = '海洋散骨';
    public static final String RD_NAME_SPACEFUNERAL 	 = '宇宙葬';
    public static final String RD_NAME_HAKAPITA 	     = '墓ピタ';
    public static final String RD_NAME_KAKUYASUBOSEKI 	 = '格安墓石';
    public static final String RD_NAME_OMUKAEFREE 	     = 'お迎えフリー';
    public static final String RD_NAME_TAIMENSODAN 	     = '対面相談';
    public static final String RD_NAME_JIZENWARI 	     = '事前割';
    
	static final String SELECT_FROM_STR =   
		  ' SELECT '
		+ ' Id, ShodanBango__c, ShodanBangoF__c,Name, RecordType.DeveloperName,RecordTypeId,KessaiKingakuGoukei__c,SeikyuZandaka__c,'
		+ ' StageName,iswon, SubPhase__c,PartnerSeikyuGakuExp__c,Amount,SiryoSeikyoAri__c,ShiryoSeikyuUmuExp__c,PartnerSiharaiGakuExp__c,'
		+ ' EditUser__c, OppEditDate__c, '
		+ ' SimpleYasugoRef__c, ObosanbinRef__c, ObosanbinRef__r.Id, JizenwariRef__c, SeizenKeiyakuRef__c,KaiyoSankotsuUmieRef__c,EitaiKuyoRef__c,'
		+ ' AccountId, Account.LastName, Account.FirstName,Account.Name,'
		+ ' Account.NameFurigana__c, '
		+ ' Account.Phone, Account.MobilePhone__c, Account.YusenFaxFormula__c, '
		+ ' Account.BillingPostalCode, Account.BillingState, Account.BillingCity, Account.BillingStreet,'
		+ ' Account.BillingAddressFormula__c, '
		+ ' Account.MemberTokutenKubunCode__c, '
		// + ' Account.AcvmSimYasSiryoMinDate__c, '
		+ ' Account.TorihikisakiBango__c, '
		+ ' Account.TorihikisakiBangoF__c, '
		+ ' Account.ManNenreiExp__c, '
		+ ' Account.Syuha__c, Account.SonotanoSyukyoSyuha__c, '
		+ ' Account.JizenJizenSheetTeishutsuzumi__c, '
		+ ' Account.AcvmJizenJunbiMinDate__c, '
		// issues4156 --Start--
		+ ' Account.MemberTourokuZumi__c, '
		+ ' Account.MemberKubunCode__c, '
		+ ' Account.AcvmOsoushikiYoyakuMinDate__c, '
		+ ' Account.RecordType.Name, '
		// issues4156 --end--
		+ ' SurveyDiscountAgreeStatus__c, '
		+ ' AllianceRef__r.Teikeisaki__r.Name, '
		+ ' SodanshaMemberKubun__c, SodanshaMemberKubunCode__c, '   
		+ ' SodanshaMemberTokutenKubun__c, SodanshaMemberTokutenKubunCode__c, '
		+ ' RyunyumotoService__c, KiboShiharaiHouhou__c, '
		+ ' SimpleYasugoRef__r.PartnerTorihikiSakiBangoExp__c, '
		+ ' SimpleYasugoRef__r.TaishoshaRef__r.LastName, '
        + ' SimpleYasugoRef__r.TaishoshaRef__r.FirstName, '
        + ' SimpleYasugoRef__r.TaishoshaRef__r.JizenJizenSheetTeishutsuzumi__c, '
        + ' SimpleYasugoRef__r.TaishoshaRef__r.AcvmJizenJunbiMinDate__c, '
		// issues4156 --Start--
		+ ' SimpleYasugoRef__r.TaishoshaRef__r.MemberTourokuZumi__c, '
		+ ' SimpleYasugoRef__r.TaishoshaRef__r.MemberKubunCode__c, '
		+ ' SimpleYasugoRef__r.TaishoshaRef__r.AcvmOsoushikiYoyakuMinDate__c, '
		+ ' SimpleYasugoRef__r.TaishoshaRef__r.RecordType.Name, '
		+ ' SimpleYasugoRef__r.ButsuguNashiKibo__c, '
		// issues4156 --end--
		+ 'ObosanbinRef__r.PartnerTorihikiSakiBangoExp__c,'	
		+ 'ObosanbinRef__r.Taishosha1Ref__r.name,'				
		+ 'ObosanbinRef__r.Taishosha1Ref__r.LastName,'		
		+ 'ObosanbinRef__r.Taishosha1Ref__r.FirstName,'	
		+ 'EitaiKuyoRef__r.TaishoshaRef__r.name,'
		+ 'EitaiKuyoRef__r.TaishoshaRef__r.LastName,'
		+ 'EitaiKuyoRef__r.TaishoshaRef__r.FirstName,'	
		+ 'EitaiKuyoRef__r.PartnerTorihikiSakiBangoExp__c,'
		+ 'SogiReviRef__r.TaisyosyaRef__r.name,'
		+ 'SogiReviRef__r.TaisyosyaRef__r.LastName,'
		+ 'SogiReviRef__r.TaisyosyaRef__r.FirstName,'	
		+ 'KaiyoSankotsuUmieRef__r.TaishoshaRef__r.name,'
		+ 'KaiyoSankotsuUmieRef__r.TaishoshaRef__r.LastName,'
		+ 'KaiyoSankotsuUmieRef__r.TaishoshaRef__r.FirstName,'
		+ 'KaiyoSankotsuUmieRef__r.PartnerTorihikiSakiBangoExp__c,'
		+ 'MosyuDaikoRef__r.PartnerTorihikiSakiBangoExp__c,'	
		+ 'SogiReviRef__r.PartnerTorihikiSakiBangoExp__c,'			
	    + ' BestButsudanRef__r.TodokesakiName__c, '   
	    + ' BestButsudanRef__r.TodokesakiKana__c, '
	    + ' BestButsudanRef__r.TodokesakiZipCode__c, '   
	    + ' BestButsudanRef__r.TodokesakiState__c, '   
	    + ' BestButsudanRef__r.TodokesakiCity__c, '   
	    + ' BestButsudanRef__r.TodokesakiStreet__c, '   
	    + ' BestButsudanRef__r.TodokesakiTelNo__c, '   
	    + ' BestButsudanRef__r.TaishoshaRef__r.LastName, ' 
	    + ' BestButsudanRef__r.TaishoshaRef__r.FirstName, ' 	
		+ 'TorihikiShodanRef__c,'
		+ 'TorihikiShodanRef__r.ShodanBangoF__c,'
		+ 'TaisyousyaNameTxt__c,'
		+ 'Account.AccountNumber,'
		+ 'Utiagebi__c,'
		+ 'KetteiTeikeisaki__r.AccountNumber,'
		+ 'KetteiTeikeisaki__r.TorihikisakiBango__c,'
		+ 'KetteiTeikeisaki__r.TorihikisakiBangoF__c,'
		+ 'KetteiTeikeisaki__c,'
		+ 'JucyuGokeiKingakuWaribikiJogai__c,'
		+ 'KakuteibiSyodan__c,Iriguchi__c, AllianceRef__c, CaseRef__c,'		
		+ 'TryCount__c,'
		+ 'TryLimit__c,'
		+ 'Req_Day__c,'
		+ 'ShoninStatus__c,'
		+ 'TaishoshaId__c, ShiharaiKijitsuPartner__c, NyukinSimekiriBiPartner__c, '
		+ 'TaishosyaRef__c, MosyuRef__c, KetteiSakiRef__c, KeiyakuSyaRef__c, KetteiPlanName__c, '
		//　検索用データstart
        + ' SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c,'
        + ' SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.NameYagouFurigana__c,'
        + ' SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Phone,'
        + ' EitaiKuyoRef__r.KetteiJiin__c,'
        + ' EitaiKuyoRef__r.KetteiJiin__r.Teikeisaki__r.SangoJiinMeiFurigana__c,'
        + ' EitaiKuyoRef__r.KetteiJiin__r.KeiyakuTantoTelNo__c,'
        + ' SogiReviRef__r.KetteiSogisya__c,'
        + ' SogiReviRef__r.KetteiSogisya__r.Teikeisaki__r.NameYagouFurigana__c,'
		+ ' ShiryoSoufuSakiAtena__c, ShiryoSoufuSakiAtenaKana__c, ShiryoSoufuSakiPostalCode__c, ShiryoSoufuSakiState__c,'
		+ ' ShiryoSoufuSakiCity__c, ShiryoSoufuSakiStreet__c, ShiryoSoufuSakiMailAddress__c,'
        + ' SogiReviRef__r.KetteiSogisya__r.Teikeisaki__r.Phone,'
        //　検索用データend

		//+ ' ( SELECT RecordTypeId FROM UketsukeServicesSyodan__r), '
		+ ' ( SELECT SeikyuHouhou__c,SeikyuKingaku__c FROM KaisyuYoteisOpportunity__r), '
		// issues4156 --Start--
		// + ' ( SELECT Id,TesuryoPartner__c,OpportunityId,Product2.KaikeiHinmokuCode__c,Product2.ProductCode,Product2.Name,Product2.SyohinKategoriCode__c,Product2.k_ShohinSyubetsuRef__r.ID__c,Product2.k_ShohinCategory_Id_exp__c,product2.k_WaribikiPlan_Id_exp__c,Product2.k_Coupon_Id_exp__c,Product2.k_ShohinCategory_Name_exp__c,TotalPrice, Quantity,Product2.KuponCode__c,UnitPrice,Product2.SougiPlan__c,Product2.ShohinBango__c,Product2.k_Service_Name_exp__c,Product2.DataKubun__c,Product2.WaribikiPlanCode__c,Product2.k_WaribikiPlan_Name_exp__c,Product2.k_Service_Id_exp__c FROM OpportunityLineItems)';
		+ ' ( SELECT Id,TesuryoPartner__c,OpportunityId,Product2.KaikeiHinmokuCode__c,Product2.ProductCode,Product2.Name,Product2.SyohinKategoriCode__c,Product2.k_ShohinSyubetsuRef__r.ID__c,Product2.k_ShohinCategory_Id_exp__c,product2.k_WaribikiPlan_Id_exp__c,Product2.k_Coupon_Id_exp__c,Product2.k_ShohinCategory_Name_exp__c,TotalPrice, Quantity,Product2.KuponCode__c,UnitPrice,Product2.SougiPlan__c,Product2.ShohinBango__c,Product2.k_Service_Name_exp__c,Product2.DataKubun__c,Product2.WaribikiPlanCode__c,Product2.k_WaribikiPlan_Name_exp__c,Product2.k_Service_Id_exp__c,Product2.LatestFlg__c FROM OpportunityLineItems)';
		// issues4156 --end--


	static final String SELECT_FROM =
			SELECT_FROM_STR
		+ ' FROM Opportunity ';

	static final String SELECT_FROM_OBO =
			SELECT_FROM_STR + ' , '
		+ ' OwnerId,'
		+ ' ObosanbinRef__r.MemorialServicePlan__c,'
		+ ' ObosanbinRef__r.KasoDateTime_Inp__c,'
		+ ' ObosanbinRef__r.KokubetsushikiNichiji__c,'
		+ ' ObosanbinRef__r.TsuyaDateTime_Inp__c,'
		+ ' ObosanbinRef__r.KokubetsuDateTime_Inp__c,'
		+ ' ObosanbinRef__r.SekotantoSoryoSoryomei__c,'
		+ ' ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__c,'
		+ ' ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.ObousanBinTehaiKubun__c,'
		+ ' ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__c,'
		+ ' ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.Name,'
		+ ' ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.SeiKana__c,'
		+ ' ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.MeiKana__c,'
		//+ ' ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.PersonContactId,'
		//+ ' ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.LastNameFurigana__pc,'
		//+ ' ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.FirstNameFurigana__pc,'
		+ ' ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.Phone,'
		+ ' ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.MobilePhone__c,'
		+ ' ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.SangoJiinMeiFurigana__c,'
		+ ' ObosanbinRef__r.ObosanbinKeiyakuSekotanto__c,'
		+ ' ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.Teikeisaki__c,'
		+ ' ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.Name,'
		+ ' ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.SeiKana__c,'
		+ ' ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.MeiKana__c,'
		//+ ' ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.LastName,'
		//+ ' ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.FirstName,'
		//+ ' ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.LastNameFurigana__pc,'
		//+ ' ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.FirstNameFurigana__pc,'
		+ ' ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.Phone,'
		+ ' ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.MobilePhone__c,'
		+ ' ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.SangoJiinMeiFurigana__c,'
		+ ' ObosanbinRef__r.SekoTantoSoryoSoryoRenrakusaki__c,'
		+ ' ObosanbinRef__r.SekoTantoSoryoSangoJiinMeiFurigana__c'
		+ ' FROM Opportunity ';

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
	static public List<Opportunity> getList(String whereString, List<String> whereParams, List<List<String>> whereArrayableParams, String strOrderByParam){
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
	static public List<Opportunity> getList(String strWhereParam, String strOrderByParam){
		return Database.query(SELECT_FROM + strWhereParam + strOrderByParam);
	}


	/**
	 * シンプル安豪取得　ID検索
	 * @param  recordId レコードID
	 * @return          シンプル安豪
	 */ 
	static public Opportunity SearchById(String recordId){

		// ----- パラメータ -------
		List<String> params = new List<String>();
		params.add(recordId); // param0で参照
		// ----- パラメータ(配列型) -------
		List<List<String>> arrayableParams = new List<List<String>>();

		String whereString = 'WHERE id = :param0'; // 規則に従ったバインド変数名にする。
		String strOrderByParam = '';
		List<Opportunity> results = getList(whereString, params, arrayableParams, strOrderByParam);
		if(!results.isEmpty()) {
			return results[0];
		}

		return null;
	}

	static public List<Opportunity> SearchByIds(List<Id> idList){
		// ----- パラメータ -------
		List<Id> params = new List<Id>();
		// ----- パラメータ(配列型) -------
		List<List<Id>> arrayableParams = new List<List<Id>>();
		arrayableParams.add(idList); // arrayableParam0 にバインド
		
		// String whereString = 'WHERE id in (:arrayableParam0) '; // 規則に従ったバインド変数名にする。
		String strOrderByParam = ' ORDER BY id';

		// バインド変数verがうまく動かないので、暫定でjoin実装
		String whereString = 'WHERE id in (\'' + String.join(idList, '\',') + '\') '; // 規則に従ったバインド変数名にする。
		System.debug(whereString + strOrderByParam);
		return getList(whereString, strOrderByParam);
	}
	

	// 
	// まとめ取得
	//
	 static public List<Opportunity> SearchByIds(List<String> idList){
	 	// ----- パラメータ -------
	 	List<String> params = new List<String>();
	 	// ----- パラメータ(配列型) -------
	 	List<List<String>> arrayableParams = new List<List<String>>();
	 	arrayableParams.add(idList); // arrayableParam0 にバインド

		
	 	String whereString = 'WHERE id in (:arrayableParam0) '; // 規則に従ったバインド変数名にする。
	 	String strOrderByParam = 'ORDER BY id';
	 	return getList(whereString, params, arrayableParams, strOrderByParam);
	 }

	 // instance definition from here ////////////////////////////////////////////////////

	private static Dao_Opportunity instance;
	public static Dao_Opportunity getInstance(){
		if(instance == null){ instance = new Dao_Opportunity(); }
		return instance;
	}
	private Dao_Opportunity(){}

	public List<Opportunity> selectByIds(List<Id> pIds){
		return Database.query(Dao_Opportunity.SELECT_FROM + 'where id in :pIds');
	}

	public List<Opportunity> selectByJizenwariIds(List<Id> pIds){
		return Database.query(Dao_Opportunity.SELECT_FROM + 'where JizenwariRef__c in :pIds');
	}
	public List<Opportunity> selectBySeizenKeiyakuIds(List<Id> pIds){
		return Database.query(Dao_Opportunity.SELECT_FROM + 'where SeizenKeiyakuRef__c in :pIds');
	}
	public List<Opportunity> selectByObosanbinIds(List<Id> pIds){
		return Database.query(Dao_Opportunity.SELECT_FROM + 'where ObosanbinRef__c in :pIds');
	}
	public List<Opportunity> selectAllDataByObosanbinIds(List<Id> pIds){
		return Database.query(Dao_Opportunity.SELECT_FROM_OBO + 'where ObosanbinRef__c in :pIds');
	}
	public List<Opportunity> selectBySimpleYasugoIds(List<Id> pIds){
		return Database.query(Dao_Opportunity.SELECT_FROM + 'where SimpleYasugoRef__c in :pIds');
	}
	public List<Opportunity> selectByEitaiKuyoIds(List<Id> pIds){
		return Database.query(Dao_Opportunity.SELECT_FROM + 'where EitaiKuyoRef__c in :pIds');
	}
	public List<Opportunity> selectByKaiyoSankotsuUmieIds(List<Id> pIds){
		return Database.query(Dao_Opportunity.SELECT_FROM + 'where KaiyoSankotsuUmieRef__c in :pIds');
	}
	public List<Opportunity> selectByBestButsudanIds(List<Id> pIds){
		return Database.query(Dao_Opportunity.SELECT_FROM + 'where BestButsudanRef__c in :pIds');
	}
	public List<Opportunity> selectBySougiRevIds(List<Id> pIds){
		return Database.query(Dao_Opportunity.SELECT_FROM + 'where SogiReviRef__c in :pIds');
	}
	public List<Opportunity> selectByCaseRefIds(List<Id> pIds){
		return Database.query(Dao_Opportunity.SELECT_FROM + 'where CaseRef__c in :pIds');
	}

}