public class Ctl_Achievement_CampaignSougiBouquet{

	Id CaseRecordTypeId;
	
	public Ctl_Achievement_CampaignSougiBouquet(){
		CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoJizenJunbiWebForm').getRecordTypeId();
	}

	public void OnAfterInsert(List<Account> newAccList){

		List<String> AccIdListadd = new List<String>();

		// キャンペーンのアチーブメントを登録対象かを判定するための処理
		for(Account aAcc :newAccList){
			if(aAcc.MemberTourokuZumi__c && aAcc.JizenJizenSheetTeishutsuzumi__c ){
				AccIdListadd.add(aAcc.Id);
			}
		}

		if(AccIdListadd.size() > 0){
			AchivementInsert(AccIdListadd);
		}
	}

	public void OnAfterUpdate(List<Account> newAccList, Map<ID, Account> oldAccountMap){

		List<String> AccIdList = new List<String>();
		List<String> CaseAccIdListadd = new List<String>();
		List<String> AccIdListadd = new List<String>();

		// キャンペーンのアチーブメントを登録対象かを判定するための処理
		for(Account aAcc :newAccList){
			Account AccOld = oldAccountMap.get(aAcc.Id);
			if(aAcc.JizenJizenSheetTeishutsuzumi__c && aAcc.JizenJizenSheetTeishutsuzumi__c != AccOld.JizenJizenSheetTeishutsuzumi__c && aAcc.AcvmYorisokaiinYoyakuMinDate__c != null ){
				AccIdList.add(aAcc.Id);
			}
		}
		
		// Webフロント マイページで登録されたデータかをチェックするための処理
		if(AccIdList.size() > 0){
			CaseAccIdListadd = getCaseJizenJunbiWebForm(AccIdList);
			if(CaseAccIdListadd.size() == 0){
				for(String aId :AccIdList){
					 System.debug('CaseAccIdListadd ' + CaseAccIdListadd);
					if(CaseAccIdListadd.contains(aId) == false){
						AccIdListadd.add(aId);
					}
				}
			}else{
				AccIdListadd = AccIdList;
			}
		}

		if(AccIdListadd.size() > 0){
			AchivementInsert(AccIdListadd);
		}
	}

	private void AchivementInsert(List<String> AccIdList){

		List<String> AchievementsTorokuzimiAccId = new List<String>();
		List<String> AccIdAchievementsTorokuTaishoList = new List<String>();
		Map<String,YorisoCampaigntMaster__mdt> CampaignApplicationDetail = new Map<String,YorisoCampaigntMaster__mdt>();
		List<Achievement__c> theAchievementsToBeInseted = new List<Achievement__c>();

		// すでにキャンペーンのアチーブメントを登録されていることを確認する処理
		if(AccIdList.size() > 0){
			AchievementsTorokuzimiAccId = getAchievements(AccIdList);
			for(String aAccountId :AccIdList){
				if(AchievementsTorokuzimiAccId.contains(aAccountId) == False){
					AccIdAchievementsTorokuTaishoList.add(aAccountId);
				}
			}
		}

		CampaignApplicationDetail = getDataYorisoCampaigntMaster();

		// キャンペーンのアチーブメントを登録するための処理
		if(AccIdAchievementsTorokuTaishoList.size() > 0 && CampaignApplicationDetail.size() > 0){
			for(String AccTorokuId :AccIdAchievementsTorokuTaishoList){
				Achievement__c aAchievement = createAchivement(AccTorokuId,CampaignApplicationDetail.get('campaign_sougi_bouquet'));
				if(aAchievement != null){
					theAchievementsToBeInseted.add(aAchievement);
				}
			}
		}
		

		if(theAchievementsToBeInseted.size() > 0){
			Insert theAchievementsToBeInseted;
		}
		
	}

	// キャンペーンのアチーブメント設定処理
	private Achievement__c createAchivement(String AccTorokuId, YorisoCampaigntMaster__mdt YCM){
		return new Achievement__c(
			TorihikiSakiRef__c = AccTorokuId,
			Syubetsu__c = YCM.campaignID__c,
			YukoFlag__c = true, 
			BaitaiToroku__c = 'Phone',
			YukoKaishiBi__c = Date.today(),
			YukoShuryoBi__c = YCM.campaignshuryobi__c
		);
	}

	// キャンペーン情報のデータ取得処理
	public Map<String,YorisoCampaigntMaster__mdt> getDataYorisoCampaigntMaster(){
		Date selectDate = Date.today();
		List<YorisoCampaigntMaster__mdt> YorisoCampaigntApplication = new List<YorisoCampaigntMaster__mdt>();
		Map<String,YorisoCampaigntMaster__mdt> CampaignApplicationDetail = new Map<String,YorisoCampaigntMaster__mdt>();
		
		YorisoCampaigntApplication = [SELECT Id, 
											campaignID__c, 
											campaignsummary__c, 
											campaignmoshikomikaishibi__c, 
											campaignmoshikomishuryobi__c, 
											campaignmoshikomiDeadlinedays__c, 
											campaignkaishibi__c,
											campaignshuryobi__c 
									  FROM YorisoCampaigntMaster__mdt 
									  WHERE campaignkaishibi__c <= :selectDate 
									  AND campaignshuryobi__c >= :selectDate
									  AND campaignID__c = 'campaign_sougi_bouquet'];
		for(YorisoCampaigntMaster__mdt y :YorisoCampaigntApplication){
			CampaignApplicationDetail.put(y.campaignID__c,y);
		}

		return CampaignApplicationDetail;
	}

	// すでにキャンペーンのアチーブメントを登録されていることを確認するためのデータ取得処理
	public List<String> getAchievements(List<String> ListAccountId){
		List<Achievement__c> ListAchievement = new List<Achievement__c>();
		List<String> returnAccountId = new List<String>();
		ListAchievement = [select Id, 
								TorihikiSakiRef__c
							from Achievement__c
							where TorihikiSakiRef__c in :ListAccountId
							and Syubetsu__c = 'campaign_sougi_bouquet'];
		for(Achievement__c aAchievement :ListAchievement){
			returnAccountId.add(aAchievement.TorihikiSakiRef__c);
		}
		return returnAccountId;
	}

	// Webフロント マイページで登録されたデータかをチェックするためのデータ取得処理
	public List<String> getCaseJizenJunbiWebForm(List<String> ListAccountId){
		List<Account> ListAccount = new List<Account>();
		List<String> returnAccountId = new List<String>();
		ListAccount = [SELECT Id ,
							(select AccountId 
							from Cases 
							where CampaignMoshikomiName__c includes ('campaign_sougi_bouquet') 
							and RecordTypeId = :CaseRecordTypeId) 
						FROM Account 
						WHERE Id in :ListAccountId];

		for(Account aAcc :ListAccount){
			 System.debug('Ctl_Achievement_CampaignSougiBouquet aAcc ' + aAcc);
			if(aAcc.Cases.size() <= 0){
				returnAccountId.add(aAcc.Id);
			}
		}
		return returnAccountId;
	}

}