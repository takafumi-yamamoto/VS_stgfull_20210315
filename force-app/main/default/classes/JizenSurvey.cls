public class JizenSurvey {

	public void JizenSurveyUpdate(list<case> CaseLst){

		List<opportunity> insOppLst=new List<opportunity>();
		List<Opportunity> updOppLst = new List<Opportunity>();

		List<ID> accountIdList = new List<ID>();	
		for (case c:CaseLst){
			if(c.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoJizenJunbiWebForm').getRecordTypeId()){
				accountIdList.add(c.AccountId);
			}
		}
		

		if(accountIdList.size() > 0){
			List<SimpleYasugo__c> updateSimpleYasugoList = new List<SimpleYasugo__c>();
			Map<ID, Account> jizenJunbiAccountMap = new Map<ID, Account>([select 
													Id, 
													(
														select Id,
																SimpleYasugoRef__c,
																SimpleYasugoRef__r.PreliminaryConsultationDate__c
														from Opportunities
														where IsClosed = false and RecordType.DeveloperName = 'SimpleYasugo'
													)
												from Account 
												where Id = :accountIdList
											]);

			List<MailAlert__c> maList = new List<MailAlert__c>();

			List<Account> AccountListupdate = new List<Account>();

			for (case c:CaseLst){
				if(jizenJunbiAccountMap.containskey(c.AccountId)){

					Account tempAccount = jizenJunbiAccountMap.get(c.AccountId);

					if(tempAccount.Opportunities.size() == 0){
						opportunity oppTmp=new opportunity();
						oppTmp=CaseToJizenJunbiOpportunity(c);
						if (oppTmp!=null){
							insOppLst.add(oppTmp);
						}
					}
					else if(tempAccount.Opportunities.size() == 1){
						
						Boolean to_update_opp = !String.isBlank(c.YorisoWoSittaKikkake__c);
						if( to_update_opp ){
							Opportunity a_opp_exists = tempAccount.Opportunities.get(0);
							updOppLst.add( new Opportunity(Id = a_opp_exists.Id, YorisoWoSittaKikkake__c = c.YorisoWoSittaKikkake__c) );
						}

						ID simpleYasugoId = tempAccount.Opportunities.get(0).SimpleYasugoRef__c;
						Date PreliminaryConsultationDate = tempAccount.Opportunities.get(0).SimpleYasugoRef__r.PreliminaryConsultationDate__c;
						String StrDate = String.valueOf(PreliminaryConsultationDate);
						updateSimpleYasugoList.add(simpleJizenjunbiUpdate(c, simpleYasugoId,StrDate));
					}
					else{
						MailAlert__c ma = new MailAlert__c();
						ma.ToAddress__c = Label.WebJizenJunbiMihaneiAddress;
						ma.Title__c = '【Web事前準備更新エラー】';
						ma.Body__c = 'お客様からWeb事前準備の登録がありましたが商談が複数あるため反映されませんでした。\r\n' + 
													'内容を確認して手動で反映してください。\r\n' + 
													'\r\n' + 
													'■ケースデータ\r\n' + 
													URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/Case/' + c.Id + '/view' + '\r\n';
						maList.add(ma);
						Account Acc = new Account(
							Id = tempAccount.id,
							JizenJizenSheetTeishutsuzumi__c = True
						);
						AccountListupdate.add(Acc);
						
					}
				}
			}
			if(updOppLst.size() > 0) { UPDATE updOppLst; }
			if(insOppLst.size() > 0) insert insOppLst;
			if(updateSimpleYasugoList.size() > 0) update updateSimpleYasugoList;
			if(maList.size() > 0) insert maList;
			if(AccountListupdate.size() > 0) update AccountListupdate;

		}
	}


	public SimpleYasugo__c simpleJizenjunbiUpdate(Case c, ID simpleJizenjunbiId, String StrDate){

		SimpleYasugo__c service = new SimpleYasugo__c(ID=simpleJizenjunbiId);
		String a_kiboarea_id = getKiboAreaId(c.KiboAreaState__c, c.KiboAreaCity__c);
		if( !String.isBlank(a_kiboarea_id) ){
			service.KiboAreaRef__c = a_kiboarea_id;
		}

		//資料送付方法
		if(c.ShiryoSoufuHoho__c == 'メール希望' || c.ShiryoSoufuHoho__c == 'メール（自動）希望'){
			service.MailSofuYohi__c = true;
		}

		if(c.ShiryoSoufuHoho__c == '郵送希望'){
			service.YusoYohiShubetsu__c = '通常';
		}

		//エンディングノートの有無
		service.EndingNoteFlg__c = c.EndingNoteFlg__c;

		// 対象者
		service.TaishoshaRef__c = c.TaishoshaRef__c;

		// お葬式対象者
		service.TaishoshaGaMoshikomishaToDoitsu__c = c.TaishoshaGaMoshikomishaToDoitsu__c;

		service.ZokugaraSodanshaNitottenoTaishosha__c = c.ZokugaraSodanshaNitottenoTaishosha__c;

		service.ZokugaraSodanshaNitottenoTaishoshaSonota__c = c.ZokugaraSodanshaNitottenoTaishoshaSonota__c;

		service.OmukaeSakiName__c = c.OmukaesakiMeisho__c;

		String strAddress = '';
		if(String.isNotBlank(c.OmukaesakiZipCode__c)){
			strAddress += c.OmukaesakiZipCode__c + ' ';
		}
		if(String.isNotBlank(c.OmukaesakiState__c)){
			strAddress += c.OmukaesakiState__c;
		}
		if(String.isNotBlank(c.OmukaesakiCity__c)){
			strAddress += c.OmukaesakiCity__c;
		}
		if(String.isNotBlank(c.OmukaesakiStreet__c)){
			strAddress += c.OmukaesakiStreet__c;
		}
		service.OmukaeSakiStreet__c = strAddress;
			
		if(c.AnchiKubun__c == '自宅安置'){
			service.KiboGoanchisaki__c = '自宅';
		}else if(c.AnchiKubun__c == '葬儀社預かり安置'){
			service.KiboGoanchisaki__c = '預かり安置';
		}else{
			service.KiboGoanchisaki__c = '';
		}

		service.SogiPlanUketsuke__c = c.KiboPlan__c;
		if(c.ObosanbinOption__c == 'なし'){
			service.MonkArrangements__c = '無';
			service.Kaimyojuyo__c = '戒名の授与を希望しない';
		}else if(c.ObosanbinOption__c == '葬儀読経のみ'){
			service.MonkArrangements__c = '有';
			service.Kaimyojuyo__c = '戒名の授与を希望しない';
		}else if(c.ObosanbinOption__c == '葬儀読経＋戒名授与'){
			service.MonkArrangements__c = '有';
			service.Kaimyojuyo__c = '戒名の授与を希望する';
		}

		if(String.isBlank(StrDate)){
			service.JizenJunbiSheetGoannaiJokyo__c = '受領';
			service.JizenJunbiSheetGoteishutsuShudan__c = 'WEB登録';
			service.PreliminaryConsultationDate__c = date.today();
		}

		return service;
	}

	public opportunity CaseToJizenJunbiOpportunity(Case c){

		Opportunity opp= new Opportunity();

		String serviceName='';
		String stageName = '';
		String subPhase = '';
		map<string,object> ParamMap=new map<string,object>();
		
		serviceName ='シンプル安豪';
		stageName = '問合せ受付';
		subPhase = 'お客様情報一時聴取/入力中'; 

		opp.AccountId = c.accountId;
		opp.Name = c.Lastname__c + ' ' + c.Firstname__c + '_' + serviceName;

		//商談レコードタイプ
		opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();

		//完了予定日
		opp.CloseDate = date.Today();

		//フェーズ
		opp.StageName = stageName;

		//ケース
		opp.CaseRef__c = c.id;

		//入口
		opp.Iriguchi__c = c.Entrance__c;

		//対象者状況
		opp.TaishoushaJokyo__c = c.TaishoushaJokyo__c;

		//対象者居住状態（初回）
		opp.TaishoshaKyojuKeitai__c = c.TaishoshaKyojuKeitai__c;

		//余命期間（初回）
		opp.TaishoshaYomeiKikan__c = c.TaishoshaYomeiKikan__c;

		//問い合わせ起因者（初回）
		opp.ToiawaseKiinsha__c = c.ToiawaseKiinsha__c;

		//重要連絡事項
		opp.JuyoRenrakuJiko__c = c.ImporantMessage__c;

		//問合せ日
		opp.Req_Day__c = c.ToiawaseDate__c;

		//サブフェーズ
		opp.SubPhase__c = subPhase;

		//価格表

		opp.Pricebook2Id = '01s7F0000064fmI';

		//対象者様のご状態（初回）決定フラグ
		opp.TaishoushaJokyoKeteiFlg__c = True;

		if( !String.isBlank(c.YorisoWoSittaKikkake__c) ){ opp.YorisoWoSittaKikkake__c = c.YorisoWoSittaKikkake__c; }
		return opp;
	}

	/**
	 * 希望エリアID取得
	 * @param	state 都道府県
	 * @param	city	市区群(+町名、市区群Name項目形式)
	 * @return			 市区群ID
	 */ 
	private Id getKiboAreaId(String state, String city) {
		List<Shikugun__c> kiboAreaList = Dao_Shikugun.SearchShikugunByFullName(state + city);
		if(!kiboAreaList.isEmpty()) {
				return kiboAreaList[0].id;
		}
		return null;
	}
}