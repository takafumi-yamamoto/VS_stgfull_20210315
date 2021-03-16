/*
* 案件：https://github.com/minrevi/issues/issues/895
* テストデータ : https://docs.google.com/spreadsheets/d/1nG24PWd1Wxpziup2cAKMqSjge5pUgY_gAPO_yzWnJyA/edit#gid=1605269975
*
Front からデータ
{
  "simpleSiryoSeikyu": {
    "definitions": {
      "type": "webToCase",
      "columns": {
        "メール処理Id": {
          "Developer": "00N0k000000zMoo",
          "Product": "00N7F00000GofLg",
          "descr": "front側が振る連番",
          "CaseColumn": "uniq_id__c"
        },
        "問合せ日": {
          "Developer": "00N0k0000010hT0",
          "Product": "00N7F00000GofLQ",
          "descr": "",
          "CaseColumn": "ToiawaseDate__c"
        },
        "入口": {
          "Developer": "00N0k000000zMp3",
          "Product": "00N7F00000GofJU",
          "descr": "",
          "CaseColumn": "Entrance__c"
        }
      }
    },
    "cases": [
      {
        "no": 1,
        "description": "シンプル資料請求テスト1",
        "values": {
          "メール処理Id": "123456789",
          "問合せ日": "2018/01/01 01:01",
          "入口": "test"
        }
      },
      {
        "no": 2,
        "description": "シンプル資料請求テスト2",
        "values": {
          "メール処理Id": "111111111",
          "問合せ日": "2018/12/12 01:01",
          "入口": "test2"
        }
      }
    ]
  }
}

FrontData.getCase -> Front からデータのcases

※ FrontからのデータのKeyはラベルですから、ご注意ください。

*/
public class WebFormDataCheck {

	// [WebToCase]シンプル安豪資料請求Web受付
	/**
	uniq_id__c、ToiawaseDate__cは比較しない
	*/
	public static Map<String, String> TYPE_SIMPLE_SIRYOUSEIKYU_WEB_MAP = new Map<String, String>{
		'GaClientId__c' => 'string',           // GaClientId
		'uniq_id__c' => 'string',           // メール処理Id
		'ToiawaseDate__c' => 'datetime',           // 問合せ日
		'Entrance__c' => 'string',           // 入口
		//'RecordTypeId' => 'string',           // レコードタイプ 比較が要らない
		'FormType__c' => 'picklist',           // フォーム種別
		'MemberTourokuKibo__c' => 'picklist',           // メンバー登録希望
		'WebAccountKibo__c' => 'picklist',           // Webアカウント開設希望
		'LastName__c' => 'string',           // 申込者姓
		'FirstName__c' => 'string',           // 申込者名
		'LastNameKana__c' => 'string',           // 申込者姓(カナ)
		'FirstNameKana__c' => 'string',           // 申込者名(カナ)
		'TelNo__c' => 'string',           // 申込者電話番号
		'MailAddress__c' => 'email',           // 申込者メールアドレス
		'PostalCode__c' => 'string',           // 申込者住所.郵便番号
		'State__c' => 'string',           // 申込者住所.都道府県
		'City__c' => 'string',           // 申込者住所.市区郡
		'Street__c' => 'string',           // 申込者住所.町名番地
		'ShiryoSoufuHoho__c' => 'picklist',           // 資料送付方法
		'TaishoushaJokyo__c' => 'picklist',           // 対象者状況
		'KiboAreaState__c' => 'string',           // 葬儀予定地域.都道府県
		'KiboAreaCity__c' => 'string'           // 葬儀予定地域.市区郡
	};

	// お坊さん便法事法要僧侶手配申込Web受付
	public static Map<String, String> TYPE_OBOSANBIN_SOURYOUTEHAI_WEB_MAP = new Map<String, String>{
		'uniq_id__c' => 'string',           // メール処理Id
		'ToiawaseDate__c' => 'datetime',           // 問合せ日
		'Entrance__c' => 'string',           // 入口
		'LastName__c' => 'string',           // 申込者姓
		'FirstName__c' => 'string',           // 申込者名
		'LastNameKana__c' => 'string',           // 申込者姓(カナ)
		'FirstNameKana__c' => 'string',           // 申込者名(カナ)
		'TelNo__c' => 'string',           // 申込者電話番号
		'MailAddress__c' => 'email',           // 申込者メールアドレス
		'PostalCode__c' => 'string',           // 申込者住所.郵便番号
		'State__c' => 'string',           // 申込者住所.都道府県
		'City__c' => 'string',           // 申込者住所.市区郡
		// 20190920 一時対応, 申込者住所.町名番地をチェックしない.
		// 'Street__c' => 'string',           // 申込者住所.町名番地
		'ShiryohassosakiZipCode__c' => 'string',           // 資料送付先住所.郵便番号
		'ShiryohassosakiState__c' => 'string',           // 資料送付先住所.都道府県
		'ShiryohassosakiCity__c' => 'string',           // 資料送付先住所.市区郡
		// 20190920 一時対応, 申込者住所.町名番地をチェックしない.
		// 'ShiryohassosakiStreet__c' => 'string',           // 資料送付先住所.町名番地
		'TaishoshaSei__c' => 'string',           // 対象者姓
		'TaishoshaMei__c' => 'string',           // 対象者名
		'TaishoshaSeiFurigana__c' => 'string',           // 対象者姓(カナ)
		'TaishoshaMeiFurigana__c' => 'string',           // 対象者名(カナ)
		'TaishoshaSeinengappi__c' => 'date',           // 対象者生年月日
		'TaishoushaBotsunengappi__c' => 'date',           // 対象者逝去日
		'Shuha__c' => 'picklist',           // 対象者宗派
		'SonotanoSyukyoSyuha__c' => 'string',           // 対象者その他宗派
		'TaishoshaBodaijinoUmu__c' => 'picklist',           // 菩提寺有無
		'HoyobashoMei__c' => 'string',           // 法要場所.名称
		'HoyobashoZipCode__c' => 'string',           // 法要場所.郵便番号
		'HoyobashoState__c' => 'string',           // 法要場所.都道府県
		'HoyobashoCity__c' => 'string',           // 法要場所.市区郡
		'HoyobashoStreet__c' => 'string',           // 法要場所.町名番地
		'TsuikahoyobashoMei__c' => 'string',           // 法要場所2.名称
		'TsuikahoyobashoZipCode__c' => 'string',           // 法要場所2.郵便番号
		'TsuikahoyobashoState__c' => 'string',           // 法要場所2.都道府県
		'TsuikahoyobashoCity__c' => 'string',           // 法要場所2.市区郡
		'TsuikahoyobashoStreet__c' => 'string',           // 法要場所2.町名番地
		'HoyoKiboDate1__c' => 'date',           // 第一希望.日付
		'HoyoKiboTime1__c' => 'picklist',           // 第一希望.時間
		'HoyoKiboMinute1__c' => 'picklist',           // 第一希望.分
		'HoyoKiboDate2__c' => 'date',           // 第二希望.日付
		'HoyoKiboTime2__c' => 'picklist',           // 第二希望.時間
		'HoyoKiboMinute2__c' => 'picklist',           // 第二希望.分
		'HoyoKiboDate3__c' => 'date',           // 第三希望.日付
		'HoyoKiboTime3__c' => 'picklist',           // 第三希望.時間
		'HoyoKiboMinute3__c' => 'picklist',           // 第三希望.分
		'HojiHoyo__c' => 'picklist',           // お坊さん便.法事法要
		'SonotanoHoyo__c' => 'string',           // その他法要
		'TsuikaHoyo__c' => 'multipicklist',           // お坊さん便.追加法要
		'KaimyoHomeijuyo__c' => 'picklist',           // お坊さん便.戒名授与希望
		'KaimyoPlan__c' => 'picklist',           // お坊さん便.希望戒名
		'OkyakusamaCommnet__c' => 'textarea',           // お客様コメント
		'KakuninRenrakuNoKiboUmu__c' => 'picklist',           // 確認連絡の希望有無
		'Riyokaisu__c' => 'picklist',           // 利用回数
		'Obonset__c' => 'picklist',           // お盆セット
		'ProductPlaceSelect__c' => 'picklist',           // 商品送付先
		'ZokugaraSodanshaNitottenoTaishosha__c' => 'picklist'           // 対象者続柄
	};

	// お坊さん便資料請求Web受付
	public static Map<String, String> TYPE_OBOSANBIN_SIRYOUSEIKYU_WEB_MAP = new Map<String, String>{
		'uniq_id__c' => 'string',           // メール処理Id
		'ToiawaseDate__c' => 'datetime',           // 問合せ日
		'Entrance__c' => 'string',           // 入口
		'LastName__c' => 'string',           // 申込者姓
		'FirstName__c' => 'string',           // 申込者名
		'LastNameKana__c' => 'string',           // 申込者姓(カナ)
		'FirstNameKana__c' => 'string',           // 申込者名(カナ)
		'TelNo__c' => 'string',           // 申込者電話番号
		'MailAddress__c' => 'email',           // 申込者メールアドレス
		'HoyouYoteiStaus__c' => 'picklist'           // 法要日時の予定状況
	};

	// シンプル安豪問合せWeb受付
	public static Map<String, String> TYPE_SIMPLE_TOIAWASE_WEB_MAP = new Map<String, String>{
		'uniq_id__c' => 'string',           // メール処理Id
		'ToiawaseDate__c' => 'datetime',           // 問合せ日
		'Entrance__c' => 'string',           // 入口
		'OkyakusamaCommnet__c' => 'textarea',           // お客様コメント
		'LastName__c' => 'string',           // 申込者姓
		'FirstName__c' => 'string',           // 申込者名
		'LastNameKana__c' => 'string',           // 申込者姓(カナ)
		'FirstNameKana__c' => 'string',           // 申込者名(カナ)
		'MailAddress__c' => 'email'          // 申込者メールアドレス
	};

	// シンプル安豪エンディングノート請求Web受付
	public static Map<String, String> TYPE_SIMPLE_ENDORINGU_WEB_MAP = new Map<String, String>{
		'GaClientId__c' => 'string',           // GaClientId
		'uniq_id__c' => 'string',           // メール処理Id
		'ToiawaseDate__c' => 'datetime',           // 問合せ日
		'Entrance__c' => 'string',           // 入口
		'MemberTourokuKibo__c' => 'picklist',           // メンバー登録希望
		'WebAccountKibo__c' => 'picklist',           // Webアカウント開設希望
		'LastName__c' => 'string',           // 申込者姓
		'FirstName__c' => 'string',           // 申込者名
		'LastNameKana__c' => 'string',           // 申込者姓(カナ)
		'FirstNameKana__c' => 'string',           // 申込者名(カナ)
		'PostalCode__c' => 'string',           // 申込者住所.郵便番号
		'State__c' => 'string',           // 申込者住所.都道府県
		'City__c' => 'string',           // 申込者住所.市区郡
		'Street__c' => 'string',           // 申込者住所.町名番地
		'TelNo__c' => 'string',           // 申込者電話番号
		'MailAddress__c' => 'email',           // 申込者メールアドレス
		'KiboAreaState__c' => 'string',           // 葬儀予定地域.都道府県
		'KiboAreaCity__c' => 'string'           // 葬儀予定地域.市区郡
	};


	// お坊さん便予約
	// 不要
	public static Map<String, String> TYPE_OBOSANBIN_YOUYAKU_WEB_MAP = new Map<String, String>{
		'uniq_id__c' => 'string',           // メール処理Id
		'ToiawaseDate__c' => 'datetime',           // 問合せ日
		'Entrance__c' => 'string',           // 入口
		'LastName__c' => 'string',           // 申込者姓
		'FirstName__c' => 'string',           // 申込者名
		'LastNameKana__c' => 'string',           // 申込者姓(カナ)
		'FirstNameKana__c' => 'string',           // 申込者名(カナ)
		'TelNo__c' => 'string',           // 申込者電話番号
		'MailAddress__c' => 'email',           // 申込者メールアドレス
		'PostalCode__c' => 'string',           // 申込者住所.郵便番号
		'State__c' => 'string',           // 申込者住所.都道府県
		'City__c' => 'string',           // 申込者住所.市区郡
		'Street__c' => 'string',           // 申込者住所.町名番地
		'ShiryohassosakiZipCode__c' => 'string',           // 資料送付先住所.郵便番号
		'ShiryohassosakiState__c' => 'string',           // 資料送付先住所.都道府県
		'ShiryohassosakiCity__c' => 'string',           // 資料送付先住所.市区郡
		'ShiryohassosakiStreet__c' => 'string',           // 資料送付先住所.町名番地
		'TaishoshaSei__c' => 'string',           // 対象者姓
		'TaishoshaMei__c' => 'string',           // 対象者名
		'TaishoshaSeiFurigana__c' => 'string',           // 対象者姓(カナ)
		'TaishoshaMeiFurigana__c' => 'string',           // 対象者名(カナ)
		'TaishoshaSeinengappi__c' => 'date',           // 対象者生年月日
		'TaishoushaBotsunengappi__c' => 'date',           // 対象者逝去日
		'Shuha__c' => 'picklist',           // 対象者宗派
		'SonotanoSyukyoSyuha__c' => 'string',           // 対象者その他宗派
		'TaishoshaBodaijinoUmu__c' => 'picklist',           // 菩提寺有無
		'HoyobashoMei__c' => 'string',           // 法要場所.名称
		'HoyobashoZipCode__c' => 'string',           // 法要場所.郵便番号
		'HoyobashoState__c' => 'string',           // 法要場所.都道府県
		'HoyobashoCity__c' => 'string',           // 法要場所.市区郡
		'HoyobashoStreet__c' => 'string',           // 法要場所.町名番地
		'TsuikahoyobashoMei__c' => 'string',           // 法要場所2.名称
		'TsuikahoyobashoZipCode__c' => 'string',           // 法要場所2.郵便番号
		'TsuikahoyobashoState__c' => 'string',           // 法要場所2.都道府県
		'TsuikahoyobashoCity__c' => 'string',           // 法要場所2.市区郡
		'TsuikahoyobashoStreet__c' => 'string',           // 法要場所2.町名番地
		'HoyoKiboDate1__c' => 'date',           // 第一希望.日付
		'HoyoKiboTime1__c' => 'picklist',           // 第一希望.時間
		'HoyoKiboMinute1__c' => 'picklist',           // 第一希望.分
		'HoyoKiboDate2__c' => 'date',           // 第二希望.日付
		'HoyoKiboTime2__c' => 'picklist',           // 第二希望.時間
		'HoyoKiboMinute2__c' => 'picklist',           // 第二希望.分
		'HoyoKiboDate3__c' => 'date',           // 第三希望.日付
		'HoyoKiboTime3__c' => 'picklist',           // 第三希望.時間
		'HoyoKiboMinute3__c' => 'picklist',           // 第三希望.分
		'HojiHoyo__c' => 'picklist',           // お坊さん便.法事法要
		'SonotanoHoyo__c' => 'string',           // その他法要
		'TsuikaHoyo__c' => 'multipicklist',           // お坊さん便.追加法要
		'KaimyoHomeijuyo__c' => 'picklist',           // お坊さん便.戒名授与希望
		'KaimyoPlan__c' => 'picklist',           // お坊さん便.希望戒名
		'OkyakusamaCommnet__c' => 'textarea',           // お客様コメント
		'KakuninRenrakuNoKiboUmu__c' => 'picklist',           // 確認連絡の希望有無
		'Riyokaisu__c' => 'picklist'           // 利用回数
	};

	private List<String> logMsg;
	private Boolean checkResult;
	private String dataType;
	private Id recordTypeId;
	private Map<String, String> dataMap;
	private List<Case> toBeDeletedCaseList;
	private CaseAutoTestConfig__c config;

	public static final String MAIL_TYPE_DELETE_LOG = 'delete_log';
	public static final String MAIL_TYPE_CHECK_LOG = 'check_log';



	public List<Case> getToBeDeletedCaseList(){
		return this.toBeDeletedCaseList;
	}


	public WebFormDataCheck(){
		this.logMsg = new List<String>();
		this.checkResult = True;
		this.config = CaseAutoTestConfig__c.getInstance('default');
	}

	public void startToCheckData(String testDataStr, String dataType){
		try {
			this.dataType = dataType;
			this.toBeDeletedCaseList = new List<Case>();
			setDataMap(dataType);
			setRecordType(dataType);

			FrontData frontData = new FrontData(testDataStr, this.dataType, this.dataMap, this.logMsg);
			System.debug(frontData);
			List<Case> frontCases = frontData.caseDataList;
			System.debug(frontCases);
			Map<String,Case> sfCaseData = getSfCaseData(frontCases);
			this.tryToCompare(frontCases, sfCaseData);
			//this.deleteAutoCreateData(this.toBeDeletedCaseList);
		}
		catch (FrontDataException ex) {
			System.debug(ex);
			addErrorLog(ex.getMessage());
			addErrorLog('Front data:');
			addErrorLog(testDataStr);
		}
		catch (Exception ex) {
			System.debug(ex);
			addErrorLog(ex.getMessage());
			addErrorLog('Front data:');
			addErrorLog(testDataStr);
		}

		//this.sendMail();

	}


	private void tryToCompare(List<Case> frontCases, Map<String,Case> sfCaseData){
		System.debug('>>>>>>tryToCompare');
		addLog('');
		Integer successCounter = 0;
		Integer failedCounter = 0;
		for(Case frontCase : frontCases){
			addLog('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
			String key = getUniqKey(frontCase);
			System.debug('>>>>>>tryToCompare Key : ' + key);
			if(sfCaseData.containsKey(key)){
				Case sfCase = sfCaseData.get(key);
				addLog('>>>>>>比較開始 :');
				addLog('>>>>>>case Id : ' + sfCase.Id);
				addLog('>>>>>>data type : ' + this.dataType);
				addLog('>>>>>>recordTypeId : ' + this.recordTypeId);
				addLog('>>>>>>data key : ' + key);
				addLog('>>>>>>frontCase : ' + frontCase);
				addLog('>>>>>>sfCase : ' + sfCase);
				addLog('>>>>>>front compare with sf>>>>>>');
				Boolean result = compareCase(frontCase, sfCase);
				if(result){
					addLog('>>比較結果：　差異なし、成功');
					successCounter++;
				} else{
					addErrorLog('>>比較結果：　差異あり！！');
					failedCounter++;
				}

				//add to delete list
				this.toBeDeletedCaseList.add(sfCase);
			} else {
				addErrorLog('Salesforce側、ケースオブジェクトデータが見つかりません。');
				addLog('>>>>>>key : ' + key);
				addLog('>>>>>>frontCase : ' + frontCase);
				failedCounter++;
			}
			addLog('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
			addLog('');
			addLog('');
			addLog('');
		}
		addLog('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
		addLog('>>>>>>比較完了');
		addLog('成功件数：' + successCounter);
		addLog('失敗件数：' + failedCounter);
		addLog('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
	}

	private Boolean compareCase(Case frontCase, Case sfCase){
		System.debug('>>>>>>compareCase');
		Boolean result = true;
		for(String field : this.dataMap.keySet()){
			System.debug('>>>>>>field: ' + field);

			Object o1 = frontCase.get(field);
			Object o2 = sfCase.get(field);

			Boolean checkIsEqual = isEqual(field, o1, o2);
			if(checkIsEqual){
				if(field == 'uniq_id__c' || field == 'GaClientId__c'){
					addLog('>>' + field + ' ok:  '+ o1 + ' , ' + o2 + ' is not null');
				} else if(field == 'ToiawaseDate__c'){
					addLog('>>' + field + ' ok:  ' + o1 + ' , ' + o2 + ' is today');
				} else {
					addLog('>>' + field + ' ok:  ' + o1 + ' = ' + o2);
				}
			} else{
				if(field == 'uniq_id__c' || field == 'GaClientId__c'){
					addErrorLog('>>差異あり項目：' + field + ' error:  '+ o1 + ' , ' + o2 + ' is null');
				} else if(field == 'ToiawaseDate__c'){
					addErrorLog('>>差異あり項目：' + field + ' error:  ' + o1 + ' , ' + o2 + ' is not today');
				} else {
					addErrorLog('>>差異あり項目：' + field + ' error:  ' + o1 + ' != ' + o2);
				}
				result = false;
			}
		}
		return result;
	}

	private Boolean isEqual(String field, Object frontObj, Object sfObj){
		if(field == 'uniq_id__c' || field == 'GaClientId__c'){
			try {
				return String.isNotBlank((String)sfObj);
			}
			catch (Exception e) {
			    return false;
			}
		} else if(field == 'ToiawaseDate__c'){
			try {
				Boolean result = Date.today() == Utility_Common.DateTimeToDateConversion((Datetime)sfObj);
				return result;
			}
			catch (Exception e) {
			    return false;
			}
		} else {
			return frontObj == sfObj;
		}
	}


	private void setRecordType(String dataType){
		if(dataType == RsCoreApi_TestDataClient.TYPE_OBOSANBIN_SOURYOUTEHAI_WEB) {
			this.recordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','ObousanbinNetYoyaku');
		} else if(dataType == RsCoreApi_TestDataClient.TYPE_OBOSANBIN_SIRYOUSEIKYU_WEB) {
			this.recordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','ObousanbinShiryoSeikyu');
		} else if(dataType == RsCoreApi_TestDataClient.TYPE_SIMPLE_SIRYOUSEIKYU_WEB) {
			this.recordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoShiryoSeikyuWebForm');
		} else if(dataType == RsCoreApi_TestDataClient.TYPE_OBOSANBIN_YOUYAKU_WEB) {
			this.recordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','ObousanbinNetYoyaku');
		} else if(dataType == RsCoreApi_TestDataClient.TYPE_SIMPLE_TOIAWASE_WEB) {
			this.recordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoOtoiawaseWebForm');
		} else if(dataType == RsCoreApi_TestDataClient.TYPE_SIMPLE_ENDORINGU_WEB) {
			this.recordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoEndingnoteWebForm');
		}
	}

	/**
	The uniqu key
	*/
	private String getUniqKey(Case aCase){
		if(this.dataType == RsCoreApi_TestDataClient.TYPE_OBOSANBIN_SOURYOUTEHAI_WEB) {
			// お坊さん便法事法要僧侶手配申込Web受付
			// お客様コメント
			String key = this.recordTypeId + aCase.OkyakusamaCommnet__c;
			return key;
		} else if(this.dataType == RsCoreApi_TestDataClient.TYPE_SIMPLE_SIRYOUSEIKYU_WEB){
			// [WebToCase]シンプル安豪資料請求Web受付
			String key = this.recordTypeId + aCase.MailAddress__c;
			return key;
		} else{
			// その他
			//key = '[WebToCase]シンプル安豪資料請求Web受付abcd123451234543214';
			String key = this.recordTypeId + aCase.Lastname__c + aCase.Firstname__c;
			return key;
		}
	}

	private Map<String,Case> getSfCaseData(List<Case> frontCases){
		Map<String,Case> sfCaseData = new Map<String, Case>();
		List<String> keyList = new List<String>();
		List<Case> sfCaseList = new List<Case>();

		if(this.dataType == RsCoreApi_TestDataClient.TYPE_OBOSANBIN_SOURYOUTEHAI_WEB
		 || this.dataType == RsCoreApi_TestDataClient.TYPE_SIMPLE_SIRYOUSEIKYU_WEB
			) {
			for(Case aCase : frontCases){
				keyList.add(aCase.MailAddress__c);
			}
			sfCaseList = CaseDaos.GetInstance().getDataForCheckSelectByRecordTypeIdAndMailAddress(this.recordTypeId , keyList);
		} else{
			for(Case aCase : frontCases){
				keyList.add(aCase.Lastname__c);
				//keyList.add('[WebToCase]シンプル安豪資料請求Web受付abcd123451234543214'); // test
			}
			/**
			get datamap
			*/
			sfCaseList = CaseDaos.GetInstance().getDataForCheckSelectByRecordTypeIdAndKey(this.recordTypeId , keyList);
		}


		for(Case aCase : sfCaseList){
			String key = getUniqKey(aCase);
			if(!sfCaseData.containsKey(key)){
				sfCaseData.put(key, aCase);
			}
		}
		return sfCaseData;

	}

	public void addLog(String msg){
		if(this.logMsg == null) this.logMsg = new List<String>();
		this.logMsg.add(msg);
	}
	public void addErrorLog(String msg){
		if(this.logMsg == null) this.logMsg = new List<String>();
		this.logMsg.add(msg);
		this.checkResult = False;
	}

	public void sendMail(){
		this.sendMail(MAIL_TYPE_CHECK_LOG);
	}

	public void sendMail(String mailLogType) {
		System.debug('send mail');

		System.debug('>>>>>>>>>>>>>>>>print log');
		System.debug(this.logMsg.size());
		System.debug(String.join(this.logMsg, '\n'));

		// メールフォーマット
		/**
		ケース自動テスト設定 CaseAutoTestConfig__c
		*/
		String mailAddressStr = this.config.SendMailAddress__c;
		if(String.isBlank(mailAddressStr))
			return;
		List<String> strToAddres = mailAddressStr.split('\n');
		System.debug('>>>send mail to ' + strToAddres);

		String strSubject = getMailSubject(mailLogType);
		String strText = String.join(this.logMsg, '\n');

		System.debug(strSubject);

		try {
		    Com_Utility.sendEmail(strToAddres, strSubject, strText);
		}
		catch (Exception e) {
		    System.debug('>>>>>>>>>>>>>>>>>sendMail exception!!');
		    System.debug(e);
		}

	}

	private String getMailSubject(String mailLogType){
		String strSubject = '';

		if(mailLogType == MAIL_TYPE_DELETE_LOG){
			if(this.checkResult) {
				System.debug('check OK!');
				strSubject = '【ケース作成データ削除】実行結果通知：　成功 ' + getNow();

			} else {
				System.debug('some Error');
				strSubject = '【ケース作成データ削除】実行結果通知：　失敗 ' + getNow();
			}
		} else{
			if(this.checkResult) {
				System.debug('check OK!');
				strSubject = '【ケース作成データ自動確認】【' + this.dataType + '】実行結果通知：　成功 ' + getNow();

			} else {
				System.debug('some Error');
				strSubject = '【ケース作成データ自動確認】【' + this.dataType + '】実行結果通知：　失敗 ' + getNow();
			}

		}

		return strSubject;

	}

	private Datetime getNow(){
		Datetime now = Datetime.now();
		Integer offset = UserInfo.getTimezone().getOffset(now);
		Datetime now1 = DateTime.now().addSeconds(offset/1000);
		return now1;
	}

	/**
	*
	*/
	public void deleteAutoCreateData(){
		this.logMsg = new List<String>();
		List<Case> sfCases = [SELECT id, CaseNumber, Lastname__c, LastNameKana__c, CreatedDate,
									(SELECT ID, Name,
											SimpleYasugoRef__c, SimpleYasugoRef__r.Name, SimpleYasugoRef__r.CreatedDate,
											ObosanbinRef__c, ObosanbinRef__r.Name, ObosanbinRef__r.CreatedDate,
											TorihikiShodanRef__c, TorihikiShodanRef__r.Name, TorihikiShodanRef__r.CreatedDate,
											CreatedDate
									 FROM OpportunitysCase__r)
							  FROM Case Where LastNameKana__c = 'ジドウシケン'];
		List<Account> accList = [SELECT	Id,	Name, LastName,	FirstName, CreatedDate,
										(select id, name, CreatedDate from TorihikisakiWebAccountIrais__r)
								 FROM Account Where LastNameFurigana__pc = 'ジドウシケン'];

		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
		Map<Id, SimpleYasugo__c> simpleMap = new Map<Id, SimpleYasugo__c>();
		Map<Id, Obosanbin__c> oboMap = new Map<Id, Obosanbin__c>();
		Map<Id, WebAccountTourokuIrai__c> webAccountTourokuIraiMap = new Map<Id, WebAccountTourokuIrai__c>();
		for(Case sfCase : sfCases){
			for(Opportunity aOpp : sfCase.OpportunitysCase__r){
				oppMap.put(aOpp.Id, aOpp);
				if(String.isNotBlank(aOpp.TorihikiShodanRef__c)) oppMap.put(aOpp.TorihikiShodanRef__c, aOpp.TorihikiShodanRef__r);
				if(String.isNotBlank(aOpp.SimpleYasugoRef__c)) simpleMap.put(aOpp.SimpleYasugoRef__c, aOpp.SimpleYasugoRef__r);
				if(String.isNotBlank(aOpp.ObosanbinRef__c)) oboMap.put(aOpp.ObosanbinRef__c, aOpp.ObosanbinRef__r);
			}

		}
		for(Account acc : accList){
			for(WebAccountTourokuIrai__c irai : acc.TorihikisakiWebAccountIrais__r){
				webAccountTourokuIraiMap.put(irai.id, irai);
			}
		}

		List<Opportunity> oppList = oppMap.values();
		List<SimpleYasugo__c> simpleList = simpleMap.values();
		List<Obosanbin__c> oboList = oboMap.values();
		List<WebAccountTourokuIrai__c> iraiList = webAccountTourokuIraiMap.values();
		try{
			if(this.config.isAutoDeleteTestData__c){
				delete oppList;
				delete sfCases;
				delete simpleList;
				delete oboList;
				delete iraiList;
				delete accList;
				addLog('>>>>ケース自動化テスト削除成功!');
			} else {
				addLog('>>>>ケース自動化テスト削除が実行されません!');
			}

			addLog('');
			addLog('');
			addLog('>>>>生成したケース、商談、シンプル安豪、お坊さん便:');
			addLog('>>ケースcase:' + sfCases.size() + '件');
			addLog(string.join(sfCases,',\n'));

			addLog('');
			addLog('>>商談Opportunity:' + oppList.size() + '件');
			addLog(string.join(oppList,',\n'));

			addLog('');
			addLog('>>シンプル安豪SimpleYasugo__c:' + simpleList.size() + '件');
			addLog(string.join(simpleList,',\n'));

			addLog('');
			addLog('>>お坊さん便Obosanbin__c:' + oboList.size() + '件');
			addLog(string.join(oboList,',\n'));

			addLog('');
			addLog('>>WebAccountTourokuIrai__c:' + iraiList.size() + '件');
			addLog(string.join(iraiList,',\n'));

			addLog('');
			addLog('>>Account:' + accList.size() + '件');
			addLog(string.join(accList,','));

	        Loggings.writeLog(
	            Loggings.createLogEntry(
	                Loggings.Level.Info, '20180913-1800-01', 'WebFormDataCheck.deleteAutoCreateData')
	                .putAttr('Case', string.join(sfCases,',\n'))
	                .putAttr('Opportunity', string.join(oppList,',\n'))
	                .putAttr('SimpleYasugo__c', string.join(simpleList,',\n'))
	                .putAttr('Obosanbin__c', string.join(oboList,',\n'))
	                .putAttr('WebAccountTourokuIrai__c', string.join(iraiList,',\n'))
	                .putAttr('Account', string.join(accList,',\n'))
	        );

		}catch(Exception ex){
		    addErrorLog('>>>ケース自動化テスト削除失敗');
			addLog('');
			addLog('');
		    addErrorLog(ex.getMessage());

			System.debug(ex);
	        Loggings.writeLog(
	            Loggings.createLogEntry(
	                Loggings.Level.Error, '20180821-1430-01', 'WebFormDataCheck.deleteAutoCreateData')
	                .putAttr('Case', string.join(sfCases,',\n'))
	                .putAttr('Opportunity', string.join(oppList,',\n'))
	                .putAttr('SimpleYasugo__c', string.join(simpleList,',\n'))
	                .putAttr('Obosanbin__c', string.join(oboList,',\n'))
	                .putAttr('WebAccountTourokuIrai__c', string.join(iraiList,',\n'))
	                .putAttr('Account', string.join(accList,',\n'))
	                .putAttr('Exception', ex.getMessage())
	        );
		}
		System.debug(sfCases);
	}

	private void setDataMap(String dataType){
    //public static final String TYPE_OBOSANBIN_SOURYOUTEHAI_WEB = 'お坊さん便法事法要僧侶手配申込Web受付';
    //public static final String TYPE_OBOSANBIN_SIRYOUSEIKYU_WEB = 'お坊さん便資料請求Web受付';
    //public static final String TYPE_SIMPLE_SIRYOUSEIKYU_WEB = '[WebToCase]シンプル安豪資料請求Web受付';
    //public static final String TYPE_OBOSANBIN_YOUYAKU_WEB = 'お坊さん便予約';
    //public static final String TYPE_SIMPLE_TOIAWASE_WEB = 'シンプル安豪問合せWeb受付';
    //public static final String TYPE_SIMPLE_ENDORINGU_WEB = 'シンプル安豪エンディングノート請求Web受付';
	    this.dataMap = new Map<String,String>();
		if(dataType == RsCoreApi_TestDataClient.TYPE_OBOSANBIN_SOURYOUTEHAI_WEB) {
			this.dataMap = WebFormDataCheck.TYPE_OBOSANBIN_SOURYOUTEHAI_WEB_MAP;
		} else if(dataType == RsCoreApi_TestDataClient.TYPE_OBOSANBIN_SIRYOUSEIKYU_WEB) {
			this.dataMap = WebFormDataCheck.TYPE_OBOSANBIN_SIRYOUSEIKYU_WEB_MAP;
		} else if(dataType == RsCoreApi_TestDataClient.TYPE_SIMPLE_SIRYOUSEIKYU_WEB) {
			this.dataMap = WebFormDataCheck.TYPE_SIMPLE_SIRYOUSEIKYU_WEB_MAP;
		} else if(dataType == RsCoreApi_TestDataClient.TYPE_OBOSANBIN_YOUYAKU_WEB) {
			this.dataMap = WebFormDataCheck.TYPE_OBOSANBIN_YOUYAKU_WEB_MAP;
		} else if(dataType == RsCoreApi_TestDataClient.TYPE_SIMPLE_TOIAWASE_WEB) {
			this.dataMap = WebFormDataCheck.TYPE_SIMPLE_TOIAWASE_WEB_MAP;
		} else if(dataType == RsCoreApi_TestDataClient.TYPE_SIMPLE_ENDORINGU_WEB) {
			this.dataMap = WebFormDataCheck.TYPE_SIMPLE_ENDORINGU_WEB_MAP;
		}
	}

	public class FrontDataException extends Exception {}

	public class FrontData {

		public Map<String, Object> frontData;
		//public Map<String, Object> simpleSiryoSeikyu;
		public String defType;
		public Map<String, Map<String,Object>> columns;
		public Map<String, Object> formDefinitions;
		public List<Object> cases ;

		public List<Case> caseDataList ;

		public List<String> logMsgList ;
		private Map<String, String> dataMap;
		private String dataType;


		public FrontData(String frontDataStr, String dataType, Map<String,String> dataMap, List<String> logMsgList){
			try {
				this.dataMap = dataMap;
				this.dataType = dataType;
				this.logMsgList = logMsgList;

				this.frontData = (Map<String, Object>)json.deserializeUntyped(frontDataStr);
				//this.simpleSiryoSeikyu = (Map<String, Object>)frontData.get('simpleSiryoSeikyu');
				this.formDefinitions = (Map<String, Object>)frontData.get('formDefinitions');
				this.cases = (List<Object>)frontData.get('cases');

				// columns
				Map<String, Object> tmpColumns = (Map<String, Object>)formDefinitions.get('columns');
				this.columns = new Map<String, Map<String,Object>>();
				for(String key : tmpColumns.keySet()){
					this.columns.put(key, (Map<String, Object>)tmpColumns.get(key));
				}
				this.defType = (String)formDefinitions.get('type');

				convertToCase();

			}
			catch (Exception ex) {
				System.debug(ex);
			    throw new FrontDataException('Exception: フォロー側データ転換できません。FrontData: ' + ex.getMessage());
			}

		}


		public String getCaseColumn(String columnName){
			Map<String,Object> column = columns.get(columnName);
			return String.valueOf(column.get('CaseColumn'));
		}

		public Map<String, Object> getCaseValueMap(Object aCase){
			try {
				Map<String, Object> tmpCase = (Map<String, Object>)aCase;
				return (Map<String, Object>)tmpCase.get('values');
			}
			catch (Exception ex) {
				System.debug(aCase);
				System.debug(ex);
			    throw new FrontDataException('フォロー側データ転換できません。getCaseValueMap() Exception: ' + String.valueOf(aCase));
			}
		}


		public String getCaseNo(Object aCase){
			try {
				Map<String, Object> tmpCase = (Map<String, Object>)aCase;
				return String.valueOf(tmpCase.get('no'));
			}
			catch (Exception ex) {
				System.debug(aCase);
				System.debug(ex);
			    throw new FrontDataException('フォロー側データ転換できません。getCaseNo() Exception: ' + String.valueOf(aCase));
			}
		}

		public String getCaseDescription(Object aCase){
			try {
				Map<String, Object> tmpCase = (Map<String, Object>)aCase;
				return String.valueOf(tmpCase.get('description'));
			}
			catch (Exception ex) {
				System.debug(aCase);
				System.debug(ex);
			    throw new FrontDataException('フォロー側データ転換できません。getCaseDescription() Exception: '+ String.valueOf(aCase));
			}
		}

		//TODO
		public String getCaseValue(Object aCase, String key){
			try {
				Map<String, Object> tmpCase = (Map<String, Object>)aCase;
				return String.valueOf(tmpCase.get('no'));
			}
			catch (Exception ex) {
				System.debug(aCase);
				System.debug(ex);
			    throw new FrontDataException('フォロー側データ転換できません。getCaseValue() Exception: '+ String.valueOf(aCase));
			}
		}

		private void convertToCase(){
			this.caseDataList = new List<Case>();

			for(Object aCase : this.cases ){
				Map<String,Object> caseValueMap = this.getCaseValueMap(aCase);
				System.debug('????' + caseValueMap);

				Case caseData = new Case();
				logMsgList.add('>>>>>>>>>>Front -> Case転換開始');
				for(String columnName : this.columns.keySet() ){
					String caseColumn = this.getCaseColumn(columnName);
					Object caseValue = caseValueMap.get(columnName);
					System.debug(columnName + ' : ' + caseColumn + ' : ' + caseValue);

					if(this.dataMap.containsKey(caseColumn)){
						System.debug('dataMap find ' + caseColumn + ' : ' + this.dataMap.get(caseColumn));

						/*else if('HoyoKiboTime1__c' == caseColumn) {
							Object hojiHoyoObj = caseValueMap.get('お坊さん便.法事法要');
							logMsgList.add('##########' + hojiHoyoObj);
							if(hojiHoyoObj != null){
								String hojihoyo = Api_V1_ItemValueMaster.getHojiHoyo(String.valueOf(hojiHoyoObj));
								logMsgList.add('##########' + hojihoyo);
								if( hojihoyo == '初盆・新盆' || hojihoyo == '	お盆（先祖供養）' || hojihoyo == 'お盆（故人1名のみ）') {
									caseData.HoyoKiboTime1__c = '9';
								} else {
									caseData.put(caseColumn, caseValue);
								}
							} else {
									caseData.put(caseColumn, caseValue);
							}
							continue;
						}  else  */
						if('HoyoKiboMinute1__c' == caseColumn) {
							Object hojiHoyoObj = caseValueMap.get('お坊さん便.法事法要');
							logMsgList.add('##########' + hojiHoyoObj);
							if(hojiHoyoObj != null){
								String hojihoyo = Api_V1_ItemValueMaster.getHojiHoyo(String.valueOf(hojiHoyoObj));
								logMsgList.add('##########' + hojihoyo);
								if( hojihoyo == '初盆・新盆' || hojihoyo == '	お盆（先祖供養）' || hojihoyo == 'お盆（故人1名のみ）') {
									caseData.HoyoKiboMinute1__c = '00';
								} else {
									caseData.put(caseColumn, caseValue);
								}
							} else {
									caseData.put(caseColumn, caseValue);
							}
							continue;
						}

						if(caseValue == null){
	                		logMsgList.add('null data : ' + columnName + ' : ' + caseColumn + ' : ' + caseValue);
	                		caseData.put(caseColumn, caseValue);
	                	} else if(String.isBlank(String.valueOf(caseValue))){
	                		logMsgList.add('blank data : ' + columnName + ' : ' + caseColumn + ' : ' + caseValue);
	                		caseData.put(caseColumn, null);
	                	} else {
	                		convertToCaseSpecialLogic(caseData, columnName, caseColumn, caseValue, caseValueMap);

	                	}
	                } else if(caseColumn == 'RecordType') {
	                	caseData.put('RecordTypeId', caseValue);
	                }
				}
				this.caseDataList.add(caseData);
			}
		}


		/**
		TODO: 特別処理
		caseValueMap フロントからのデータマップ
		*/
		private void convertToCaseSpecialLogic(Case caseData, String columnName, String caseColumn, Object caseValue, Map<String,Object> caseValueMap){
			System.debug('>>>>>>>>>>>>>>>columnName : caseColumn : caseValue');
			System.debug('>>>>>>>>>>>>>>>' + columnName + ' : ' + caseColumn + ' : ' + caseValue +'');

			if('datetime' == this.dataMap.get(caseColumn)) {
        		try {
        		    //caseData.ToiawaseDate__c      = Com_Utility.toDateTime(String.valueOf(caseValue));
        		    if(String.valueOf(caseValue) == '%today%') {
						caseData.put(caseColumn, DateTime.now() );
        		    } else {
        		    	caseData.put(caseColumn, DateTime.parse(String.valueOf(caseValue)).addHours(9) );
        		    }
        		} catch (Exception e) {
        			String errMsg = 'Front側から無効のデータ(DateTime変換エラー) : ' + columnName + ' : ' + caseColumn + ' : ' + caseValue;
        		    logMsgList.add(errMsg);
        		    //throw new FrontDataException(errMsg);
        		}
			} else if('date' == this.dataMap.get(caseColumn)) {
        		try {
        		    caseData.put(caseColumn, Com_Utility.toDate(String.valueOf(caseValue)));
        		}
        		catch (Exception e) {
        			String errMsg = 'Front側から無効のデータ(Date変換エラー) : ' + columnName + ' : ' + caseColumn + ' : ' + caseValue;
        		    logMsgList.add(errMsg);
        		    //throw new FrontDataException(errMsg);
        		}
			} else if('TelNo__c' == caseColumn) {
				String customer_tel = String.valueOf(caseValue);
				if(Com_Utility.isMobile(customer_tel)) {
	                //申込者携帯電話番号
	                caseData.KeitaiDenwa__c       = customer_tel;
	            } else{
	                //申込者固定電話番号
	                caseData.TelNo__c             = customer_tel;
	            }
			} else if('HoyouYoteiStaus__c' == caseColumn) {
				caseData.HoyouYoteiStaus__c      = Api_V1_ItemValueMaster.getHoyouYoteiStaus(String.valueOf(caseValue));
			} else if('TaishoshaBodaijinoUmu__c' == caseColumn) {
	            //菩提寺有無
	            caseData.TaishoshaBodaijinoUmu__c       = Api_V1_ItemValueMaster.getTaisyosyaBodaijiUmu(String.valueOf(caseValue));
			} else if('HojiHoyo__c' == caseColumn) {
	            //お坊さん便.法事法要
	            caseData.HojiHoyo__c       = Api_V1_ItemValueMaster.getHojiHoyo(String.valueOf(caseValue));
			} else if('KaimyoHomeijuyo__c' == caseColumn) {
	            //お坊さん便.戒名授与希望
	            caseData.KaimyoHomeijuyo__c       = Api_V1_ItemValueMaster.getKaimyoHomeijuyo(String.valueOf(caseValue));
			} else if('KaimyoPlan__c' == caseColumn) {
	            //お坊さん便.希望戒名
	            caseData.KaimyoPlan__c       = Api_V1_ItemValueMaster.getKaimyoPlan(String.valueOf(caseValue));
			} else if('KakuninRenrakuNoKiboUmu__c' == caseColumn) {
	            //確認連絡の希望有無
	            caseData.KakuninRenrakuNoKiboUmu__c       = Api_V1_ItemValueMaster.getKakuninRenrakuNoKiboUmu(String.valueOf(caseValue));
			} else if('Riyokaisu__c' == caseColumn) {
	            //利用回数
	            caseData.Riyokaisu__c       = Api_V1_ItemValueMaster.getRiyokaisu(String.valueOf(caseValue));
			}  else if('TaishoushaJokyo__c' == caseColumn) {
	            //対象者状況
	            String tmp = String.valueOf(caseValue);
	            if(tmp == 'すでにご逝去'){
	                tmp = '死亡';
	            }
	            caseData.TaishoushaJokyo__c       = tmp;
			} else if('Obonset__c' == caseColumn) {
	            //対象者状況
	            String tmp = String.valueOf(caseValue);
	            if(tmp == 'yes'){
	                tmp = '新盆セット+お盆用提灯(1万1000円)';
	            }
	            caseData.Obonset__c       = tmp;
			} else {
				caseData.put(caseColumn, caseValue);
			}

		}
	}
}