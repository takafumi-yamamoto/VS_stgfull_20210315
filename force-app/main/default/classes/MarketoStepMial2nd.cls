public class MarketoStepMial2nd implements MarketoCampaignMember{

	public void addCampaignMember(List<Opportunity> ListOpportunity,MarketoManagement__c MarketoManage){

		//issues3806--Start--
		//ナーチャ・ＣＲＭ 構築支援ＰＪにて、利用しなくなったため
		/*
		String StrTaishoushaJokyo = '入院危篤,自宅危篤,危篤,危篤・余命宣告';
		String StrStageName = '問合せ受付,フォロー,事前準備処理中,事前準備完了';

		List<String> l_TaishoushaJokyo = StrTaishoushaJokyo.split(',');
		List<String> l_StageName = StrStageName.split(',');
		Set<String> s_HaishinContactId = new Set<String>();
		Set<String> s_CheckContactId = new Set<String>();
		List<Opportunity> l_TargetOpportunity = new List<Opportunity>();
		List<CampaignMember> l_CheckCampaignMember = new List<CampaignMember>();
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
				query_str  = query_str  + ' ShodanBango__c';
				query_str  = query_str  + ' FROM Opportunity';
				query_str  = query_str  + ' Where Id in :ListOpportunity';
				query_str  = query_str  + ' AND TaishoushaJokyo__c in :l_TaishoushaJokyo';
				query_str  = query_str  + ' AND StageName in :l_StageName';

				//「MarketoManagement__c.TESTMarketoFlg__c」は、本番環境でTESTを行うためのフラグ
				//メールアドレスに'@yoriso.com'が入っているデータのみを処理対象にする
				if(MarketoManage.TESTMarketoFlg__c){
					query_str  = query_str  + ' AND Account.PersonEmail like :StrCheckEmail';
				}
				
				l_TargetOpportunity =Database.query(query_str);

				if(l_TargetOpportunity.size() > 0){

					for(Opportunity sOpportunity :l_TargetOpportunity){
						s_HaishinContactId.add(sOpportunity.Account.PersonContactId);
					}

					if(s_HaishinContactId.size() > 0){

						l_CheckCampaignMember = [SELECT ID, 
														ContactId
												FROM CampaignMember
												WHERE CampaignId = :MarketoManage.Campaign__c
												AND ContactId = :s_HaishinContactId];


						for(CampaignMember sCampaignMember :l_CheckCampaignMember){
							s_CheckContactId.add(sCampaignMember.ContactId);
						}

						for(Opportunity aTargetOpportunity :l_TargetOpportunity){
							if(!s_CheckContactId.contains(aTargetOpportunity.Account.PersonContactId)){
								CampaignMember sCampaignMember = new CampaignMember(
									CampaignId = MarketoManage.Campaign__c,
									ContactId = aTargetOpportunity.Account.PersonContactId,
									Status = '送信');
								l_InCampaignMember.add(sCampaignMember);
							}
						}

						if(l_InCampaignMember.size() > 0){
							insert l_InCampaignMember;
						}

					}

					MarketoCampaignAndOpportunity sMarketoCampaignAndOpportunity = new MarketoCampaignAndOpportunity();
					sMarketoCampaignAndOpportunity.addLinkMarketoCampaignAndOpportunity(l_TargetOpportunity,MarketoManage.Campaign__c);

				}

			}
		}
		*/
		//issues3806--End--

	}

}