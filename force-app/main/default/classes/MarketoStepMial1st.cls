public class MarketoStepMial1st implements MarketoCampaignMember{

	public void addCampaignMember(List<Opportunity> ListOpportunity,MarketoManagement__c MarketoManage){

		//issues3806--Start--
		//String StrTaishoushaJokyo = '通院中,入院・通院中,入院中,健在,検査,自宅療養中,生前,老人ホーム,事前相談,入院余命1ヶ月,入院余命2週間,入院余命3ヶ月,入院余命6ヶ月,余命宣告,余命宣告(1ヶ月以上),余命宣告(1ヶ月以内),余命宣告(2週間以内),未聴取により不明';
		String StrTaishoushaJokyo = '危篤,余命宣告,高齢終末期,闘病中（重度）,闘病中（軽度）,闘病中（度合不明）,健在,未聴取により不明';
		//issues3806--End--
		String StrStageName = '問合せ受付,フォロー,事前準備処理中,事前準備完了';
		String StrSubPhase = '3分コール接続待,お客様情報一時聴取/入力中,資料作成/発送待ち,資料到着確認待ち（危篤/余命宣告［急］）,資料到着確認待ち（健在/余命宣告［不急］）,フォロー（危篤/余命宣告［急］）,フォロー（健在/余命宣告［不急］）,事前割申込中/発効待ち,お葬式予約お申込中,事前準備シート提出済,住所不備';

		List<String> l_TaishoushaJokyo = StrTaishoushaJokyo.split(',');
		List<String> l_StageName = StrStageName.split(',');
		List<String> l_SubPhase = StrSubPhase.split(',');
		Set<String> s_HaishinContactId = new Set<String>();
		Set<String> s_KaijoContactId = new Set<String>();
		Set<String> s_CheckOpportunityId = new Set<String>();
		List<Opportunity> l_Opportunity = new List<Opportunity>();
		List<Opportunity> l_TargetOpportunity = new List<Opportunity>();
		List<CampaignMember> l_OutCampaignMember = new List<CampaignMember>();
		List<CampaignMember> l_InCampaignMember = new List<CampaignMember>();
		String StrCheckEmail = '%@yoriso.com';

		if(MarketoManage.MarketoFlg__c){

			if(String.isNotBlank(MarketoManage.Campaign__c)){

				String query_str  = '';
				query_str  = 'SELECT';
				query_str  = query_str  + ' Id,';
				query_str  = query_str  + ' Account.PersonContactId,';
				query_str  = query_str  + ' Account.PersonEmail,';
				query_str  = query_str  + ' TaishoushaJokyo__c,';
				query_str  = query_str  + ' StageName,';
				query_str  = query_str  + ' SubPhase__c,';
				query_str  = query_str  + ' ShodanBango__c';
				query_str  = query_str  + ' FROM Opportunity';
				query_str  = query_str  + ' Where Id in :ListOpportunity';

				//「MarketoManagement__c.TESTMarketoFlg__c」は、本番環境でTESTを行うためのフラグ
				//メールアドレスに'@yoriso.com'が入っているデータのみを処理対象にする
				if(MarketoManage.TESTMarketoFlg__c){
					query_str  = query_str  + ' AND Account.PersonEmail like :StrCheckEmail';
				}
				
				l_TargetOpportunity =Database.query(query_str);

				if(l_TargetOpportunity.size() > 0){

					for(Opportunity sOpportunity :l_TargetOpportunity){
						if(String.isNotBlank(sOpportunity.Account.PersonContactId)){
							if(l_TaishoushaJokyo.indexOf(sOpportunity.TaishoushaJokyo__c) > -1){
								if(l_StageName.indexOf(sOpportunity.StageName) > -1){
									if(l_SubPhase.indexOf(sOpportunity.SubPhase__c) > -1){
										s_HaishinContactId.add(sOpportunity.Account.PersonContactId);
										l_Opportunity.add(sOpportunity);
									}else{
										s_KaijoContactId.add(sOpportunity.Account.PersonContactId);
									}
								}else{
									s_KaijoContactId.add(sOpportunity.Account.PersonContactId);
								}
							}else{
								s_KaijoContactId.add(sOpportunity.Account.PersonContactId);
							}
						}
					}

					if(s_KaijoContactId.size() > 0){
						l_OutCampaignMember = [SELECT ID 
												FROM CampaignMember
												WHERE CampaignId = :MarketoManage.Campaign__c
												AND ContactId = :s_KaijoContactId];
						if(l_OutCampaignMember.size() > 0){
							delete l_OutCampaignMember;
						}
					}

					if(s_HaishinContactId.size() > 0){
						List<CampaignMember> ListCMCheck = [SELECT ID,
																	ContactId
															FROM CampaignMember
															WHERE CampaignId = :MarketoManage.Campaign__c
															AND ContactId = :s_HaishinContactId];
						SET<String> s_CheckContactId = new SET<String>();
						for(CampaignMember aCM :ListCMCheck){
							s_CheckContactId.add(aCM.ContactId);
						}
						for(String aConId :s_HaishinContactId){
							if(!s_CheckContactId.contains(aConId)){
								CampaignMember sCampaignMember = new CampaignMember(
									CampaignId = MarketoManage.Campaign__c,
									ContactId = aConId,
									Status = '送信');
								l_InCampaignMember.add(sCampaignMember);
							}
						}
						if(l_InCampaignMember.size() > 0){
							insert l_InCampaignMember;
						}
					}

					if(l_Opportunity.size() > 0){
						MarketoCampaignAndOpportunity sMarketoCampaignAndOpportunity = new MarketoCampaignAndOpportunity();
						sMarketoCampaignAndOpportunity.addLinkMarketoCampaignAndOpportunity(l_Opportunity,MarketoManage.Campaign__c);
					}
				}
			}
		}
	}

}